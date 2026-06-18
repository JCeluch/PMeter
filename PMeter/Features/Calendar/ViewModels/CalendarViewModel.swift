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
        guard let start = prediction?.fertileWindowStart,
              let end   = prediction?.fertileWindowEnd else { return false }
        let d = Calendar.current.startOfDay(for: date)
        return d >= Calendar.current.startOfDay(for: start)
            && d <= Calendar.current.startOfDay(for: end)
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
        // Nie podświetlaj jeśli to już potwierdzone okno płodne
        guard !isFertileDay(date) else { return false }
        let d = Calendar.current.startOfDay(for: date)
        return predictedWindows().contains {
            let s = Calendar.current.startOfDay(for: $0.fertileStart)
            let e = Calendar.current.startOfDay(for: $0.fertileEnd)
            return d >= s && d <= e
        }
    }
}

struct PredictedCycleWindow {
    let periodStart: Date
    let periodEnd: Date
    let fertileStart: Date
    let fertileEnd: Date
}
