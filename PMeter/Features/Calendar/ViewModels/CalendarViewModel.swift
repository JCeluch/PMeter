//
//  CalendarViewModel.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//


import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class CalendarViewModel {

    // Słownik date → wpisy dla danego dnia (szybkie O(1) lookup)
    private(set) var entriesByDay: [DateComponents: [CycleEntry]] = [:]
    private(set) var visibleDays: [CalendarDay] = []
    private(set) var prediction: CyclePredictionService.Prediction? = nil
    
    private var allEntries: [CycleEntry] = []
    
    private var cachedMonth: Date = .distantPast
    private var cachedEntryIDs: [PersistentIdentifier] = []

    func refresh(entries: [CycleEntry], month: Date) {
        let ids = entries.map(\.id)
        let sameMonth = Calendar.current.isDate(month, equalTo: cachedMonth, toGranularity: .month)
        guard ids != cachedEntryIDs || !sameMonth else { return }

        cachedEntryIDs = ids
        cachedMonth = month

        Task.detached(priority: .userInitiated) { [entries, month] in
            // Zbuduj słownik raz – O(n) zamiast O(n×35)
            var byDay: [DateComponents: [CycleEntry]] = [:]
            
            let cal = Calendar.current
            for entry in entries {
                let key = cal.dateComponents([.year, .month, .day], from: entry.date)
                byDay[key, default: []].append(entry)
            }
            let days = CalendarHelper.visibleDays(for: month)
            let pred = CyclePredictionService.predict(from: entries)
            
            await MainActor.run {
                self.allEntries = entries
                self.entriesByDay = byDay
                self.visibleDays = days
                self.prediction = pred
            }
        }
    }

    // O(1) lookup zamiast O(n) filter
    func entries(for date: Date) -> [CycleEntry] {
        let key = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return entriesByDay[key] ?? []
    }

    func hasEntry(for date: Date) -> Bool {
        !entries(for: date).isEmpty
    }
    
    func isFertileDay(_ date: Date) -> Bool {
        switch fertileDayKind(for: date) {
        case .confirmed, .estimated: return true
        default: return false
        }
    }
    
    func cycleDay(for date: Date) -> Int? {
        CalendarHelper.cycleDay(for: date, entries: allEntries)
    }
    
    // Przewidywane przyszłe okna płodne i krwawienia
    // Generuje N kolejnych cykli na podstawie średniej długości
    func predictedWindows(cycles ahead: Int = 3) -> [PredictedCycleWindow] {
        guard let pred = prediction,
              let nextPeriod = pred.nextPeriodStart,
              let fertileStart = pred.fertileWindowStart,
              let fertileEnd = pred.fertileWindowEnd else { return [] }

        // Wyznacz średnią długość cyklu z historii
        let cycleStarts = CalendarHelper.cycleStartDates(in: allEntries).sorted()
        guard cycleStarts.count >= 2 else { return [] }
        let lengths = zip(cycleStarts, cycleStarts.dropFirst()).compactMap {
            Calendar.current.dateComponents([.day], from: $0, to: $1).day
        }
        let avgLength = Int(round(Double(lengths.reduce(0, +)) / Double(lengths.count)))

        // Długość okna płodnego (zwykle 7 dni: owulacja-5…owulacja+1)
        let fertileLength = Calendar.current.dateComponents([.day], from: fertileStart, to: fertileEnd).day ?? 6
        // Offset okna płodnego od startu kolejnej miesiączki (ujemny – przed miesiączką)
        guard let ovulation = pred.ovulationDate else { return [] }
        let daysOvToNext = Calendar.current.dateComponents([.day], from: ovulation, to: nextPeriod).day ?? 13
        // fertile start = nextPeriod - daysOvToNext - 5
        let fertileOffsetFromPeriod = -(daysOvToNext + 5)

        var windows: [PredictedCycleWindow] = []
        let cal = Calendar.current

        for i in 0..<ahead {
            guard let periodStart = cal.date(byAdding: .day, value: avgLength * i, to: nextPeriod),
                  let periodEnd   = cal.date(byAdding: .day, value: 4, to: periodStart),
                  let fStart = cal.date(byAdding: .day, value: fertileOffsetFromPeriod + avgLength * i, to: nextPeriod),
                  let fEnd   = cal.date(byAdding: .day, value: fertileLength, to: fStart)
            else { continue }

            windows.append(PredictedCycleWindow(
                periodStart: periodStart,
                periodEnd: periodEnd,
                fertileStart: fStart,
                fertileEnd: fEnd
            ))
        }
        return windows
    }

    func isPredictedPeriodDay(_ date: Date) -> Bool {
        let d = Calendar.current.startOfDay(for: date)
        return predictedWindows().contains {
            let s = Calendar.current.startOfDay(for: $0.periodStart)
            let e = Calendar.current.startOfDay(for: $0.periodEnd)
            return d >= s && d <= e
        }
    }

    func isPredictedFertileDay(_ date: Date) -> Bool {
        fertileDayKind(for: date) == .predicted
    }
    
    // MARK: - Historyczne okna płodne

    /// Dla każdego zakończonego cyklu wyznacza okno płodne na podstawie
    /// Peak Day (priorytet) lub owulacji z BBT (fallback: cykl-13 dni).
    private func historicalFertileWindows() -> [(start: Date, end: Date, estimated: Bool)] {
        let cal = Calendar.current
        let cycleStarts = CalendarHelper.cycleStartDates(in: allEntries).sorted()
        guard cycleStarts.count >= 2 else { return [] }

        return zip(cycleStarts, cycleStarts.dropFirst()).compactMap { cycleStart, nextStart in
            let cycleEntries = allEntries.filter { $0.date >= cycleStart && $0.date < nextStart }

            // 1. Peak Day – najbardziej wiarygodny
            if let peakEntry = cycleEntries.first(where: { $0.isPeakDay }) {
                let ov = cal.startOfDay(for: peakEntry.date)
                guard let s = cal.date(byAdding: .day, value: -5, to: ov),
                      let e = cal.date(byAdding: .day, value: 1, to: ov) else { return nil }
                return (s, e, false)
            }

            // 2. Peak LH
            if let lhPeak = cycleEntries.last(where: { $0.lhTest == .peak }) {
                let ov = cal.startOfDay(for: lhPeak.date)
                guard let s = cal.date(byAdding: .day, value: -5, to: ov),
                      let e = cal.date(byAdding: .day, value: 1, to: ov) else { return nil }
                return (s, e, false)
            }

            // 3. Skok BBT – 3 kolejne wyższe pomiary
            let temps = cycleEntries
                .filter { $0.temperature != nil && !$0.temperatureExcluded }
                .sorted { $0.date < $1.date }

            if temps.count >= 6 {
                for i in 3..<(temps.count - 2) {
                    let baseline = temps[(i-3)..<i].compactMap(\.temperature)
                    guard baseline.count == 3 else { continue }
                    let baseMax = baseline.max() ?? 0
                    let t0 = temps[i].temperature ?? 0
                    let t1 = temps[i+1].temperature ?? 0
                    let t2 = temps[i+2].temperature ?? 0
                    if t0 >= baseMax + 0.2, t1 >= baseMax + 0.2, t2 >= baseMax + 0.2 {
                        let ov = cal.startOfDay(for: temps[i].date)
                        guard let s = cal.date(byAdding: .day, value: -5, to: ov),
                              let e = cal.date(byAdding: .day, value: 1, to: ov) else { continue }
                        return (s, e, false)
                    }
                }
            }

            // 4. Fallback: owulacja = nextStart - 13 dni
            guard let ov = cal.date(byAdding: .day, value: -13, to: nextStart),
                  let s = cal.date(byAdding: .day, value: -5, to: ov),
                  let e = cal.date(byAdding: .day, value: 1, to: ov) else { return nil }
            return (s, e, true)
        }
    }
    
    func fertileDayKind(for date: Date) -> FertileDayKind {
        let d = Calendar.current.startOfDay(for: date)
        let cal = Calendar.current

        // Przewidywane przyszłe okna (predicted)
        for window in predictedWindows() {
            let s = cal.startOfDay(for: window.fertileStart)
            let e = cal.startOfDay(for: window.fertileEnd)
            if d >= s && d <= e { return .predicted }
        }

        // Bieżące okno z predykcji (confirmed jeśli bazuje na Peak/LH/BBT)
        if let start = prediction?.fertileWindowStart,
           let end = prediction?.fertileWindowEnd {
            let s = cal.startOfDay(for: start)
            let e = cal.startOfDay(for: end)
            if d >= s && d <= e {
                return prediction?.basedOnPeakDayHistory == true ? .confirmed : .estimated
            }
        }

        // Historyczne okna
        for window in historicalFertileWindows() {
            let s = cal.startOfDay(for: window.start)
            let e = cal.startOfDay(for: window.end)
            if d >= s && d <= e {
                return window.estimated ? .estimated : .confirmed
            }
        }

        return .none
    }

    enum FertileDayKind {
        case none
        case confirmed // Peak Day / LH / BBT - pewne dane
        case estimated // fallback nextStart-13 - szacunek
        case predicted // przyszłe okno z predykcji
    }
}

struct PredictedCycleWindow {
    let periodStart: Date
    let periodEnd: Date
    let fertileStart: Date
    let fertileEnd: Date
}
