//
//  CyclePredictionService.swift
//  PMeter
//
//  Created by JCeluch on 12/06/2026.
//

import Foundation

/// Ulepszone predykcje uwzględniające historię Peak Day i LH.
enum CyclePredictionService {

    struct Prediction {
        /// Przewidywana data następnej miesiączki (środek przedziału)
        let nextPeriodStart: Date?
        /// Przedział ufności — ±1 odchylenie std
        let nextPeriodEarliest: Date?
        let nextPeriodLatest: Date?
        /// Przewidywana owulacja
        let ovulationDate: Date?
        /// Okno płodne
        let fertileWindowStart: Date?
        let fertileWindowEnd: Date?
        /// Czy predykcja oparta na historii Peak Day (lepsza jakość)
        let basedOnPeakDayHistory: Bool
        /// Ile danych użyto do predykcji
        let dataQuality: DataQuality
    }

    enum DataQuality {
        case insufficient       // < 2 cykle
        case low                // 2–3 cykle, brak Peak Day
        case medium             // 4+ cykli lub Peak Day history
        case high               // 4+ cykli + Peak Day history
    }

    static func predict(from entries: [CycleEntry]) -> Prediction {
        let sorted = entries.sorted { $0.date < $1.date }
        let cycleStarts = CalendarHelper.cycleStartDates(in: sorted).sorted()
        guard cycleStarts.count >= 2 else {
            return Prediction(
                nextPeriodStart: nil, nextPeriodEarliest: nil, nextPeriodLatest: nil,
                ovulationDate: nil, fertileWindowStart: nil, fertileWindowEnd: nil,
                basedOnPeakDayHistory: false, dataQuality: .insufficient
            )
        }

        let cycleLengths = zip(cycleStarts, cycleStarts.dropFirst()).compactMap {
            Calendar.current.dateComponents([.day], from: $0, to: $1).day
        }
        let avgCycleLength = Double(cycleLengths.reduce(0, +)) / Double(cycleLengths.count)
        let stdDev = standardDeviation(of: cycleLengths)
        guard let lastStart = cycleStarts.last else {
            return Prediction(
                nextPeriodStart: nil, nextPeriodEarliest: nil, nextPeriodLatest: nil,
                ovulationDate: nil, fertileWindowStart: nil, fertileWindowEnd: nil,
                basedOnPeakDayHistory: false, dataQuality: .low
            )
        }

        // --- Peak Day history ---
        let peakDays = historicalPeakDays(from: sorted, cycleStarts: cycleStarts)
        let avgPeakDay: Double?
        let basedOnPeak: Bool

        if peakDays.count >= 2 {
            avgPeakDay = Double(peakDays.reduce(0, +)) / Double(peakDays.count)
            basedOnPeak = true
        } else {
            // Fallback: owulacja = długość cyklu - średnia faza lutealna (13)
            avgPeakDay = avgCycleLength - 13
            basedOnPeak = false
        }

        // --- Przewidywana owulacja ---
        let ovulationDate: Date? = avgPeakDay.flatMap {
            Calendar.current.date(byAdding: .day, value: Int(round($0)) - 1, to: lastStart)
        }

        // --- Długość fazy lutealnej ---
        let lutealLength = historicalLutealLength(
            from: sorted, cycleStarts: cycleStarts, peakDays: peakDays
        ) ?? 13

        // --- Następna miesiączka ---
        let nextPeriod: Date? = ovulationDate.flatMap {
            Calendar.current.date(byAdding: .day, value: lutealLength, to: $0)
        }

        let earliest = nextPeriod.flatMap {
            Calendar.current.date(byAdding: .day, value: -Int(ceil(stdDev)), to: $0)
        }
        let latest = nextPeriod.flatMap {
            Calendar.current.date(byAdding: .day, value: Int(ceil(stdDev)), to: $0)
        }

        // --- Okno płodne: Peak Day -5 … Peak Day +1 ---
        let fertileStart = ovulationDate.flatMap {
            Calendar.current.date(byAdding: .day, value: -5, to: $0)
        }
        let fertileEnd = ovulationDate.flatMap {
            Calendar.current.date(byAdding: .day, value: 1, to: $0)
        }

        let quality: DataQuality = {
            if cycleLengths.count >= 4 && basedOnPeak { return .high }
            if cycleLengths.count >= 4 || basedOnPeak  { return .medium }
            return .low
        }()

        return Prediction(
            nextPeriodStart: nextPeriod,
            nextPeriodEarliest: earliest,
            nextPeriodLatest: latest,
            ovulationDate: ovulationDate,
            fertileWindowStart: fertileStart,
            fertileWindowEnd: fertileEnd,
            basedOnPeakDayHistory: basedOnPeak,
            dataQuality: quality
        )
    }

    // MARK: - Stosunek w oknie płodnym

    struct IntercourseInFertileWindow {
        let total: Int
        let unprotected: Int
        /// Dni okna w których był stosunek (1-based od początku okna)
        let daysWithIntercourse: [Int]
    }

    static func intercourseInFertileWindow(
        from entries: [CycleEntry],
        fertileStart: Date,
        fertileEnd: Date
    ) -> IntercourseInFertileWindow {
        let window = entries.filter {
            let d = Calendar.current.startOfDay(for: $0.date)
            return d >= fertileStart && d <= fertileEnd && $0.intercourse != .none
        }
        let days = window.compactMap {
            Calendar.current.dateComponents([.day], from: fertileStart, to: $0.date).day.map { $0 + 1 }
        }.sorted()
        return IntercourseInFertileWindow(
            total: window.count,
            unprotected: window.filter { $0.intercourse == .unprotected }.count,
            daysWithIntercourse: days
        )
    }

    // MARK: - Helpers

    private static func historicalPeakDays(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> [Int] {
        zip(cycleStarts, cycleStarts.dropFirst()).compactMap { start, next in
            guard let peak = entries.first(where: {
                $0.date >= start && $0.date < next && $0.isPeakDay
            }) else { return nil }
            return (Calendar.current.dateComponents([.day], from: start, to: peak.date).day ?? 0) + 1
        }
    }

    private static func historicalLutealLength(
        from entries: [CycleEntry],
        cycleStarts: [Date],
        peakDays: [Int]
    ) -> Int? {
        guard !peakDays.isEmpty, cycleStarts.count >= 2 else { return nil }
        let lengths: [Int] = zip(
            zip(cycleStarts, cycleStarts.dropFirst()),
            peakDays
        ).compactMap { (startNext, peakDay) in
            let (start, next) = startNext
            guard let peakDate = Calendar.current.date(
                byAdding: .day, value: peakDay - 1, to: start
            ) else { return nil }
            let days = Calendar.current.dateComponents([.day], from: peakDate, to: next).day ?? 0
            return (days >= 8 && days <= 18) ? days : nil
        }
        guard !lengths.isEmpty else { return nil }
        return lengths.reduce(0, +) / lengths.count
    }

    private static func standardDeviation(of values: [Int]) -> Double {
        guard values.count >= 2 else { return 2 }
        let mean = Double(values.reduce(0, +)) / Double(values.count)
        let variance = values.map { pow(Double($0) - mean, 2) }.reduce(0, +) / Double(values.count)
        return max(sqrt(variance), 1)
    }
}
