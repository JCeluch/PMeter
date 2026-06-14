//
//  CalendarHelper.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation

struct CalendarDay: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
}

struct CycleChartDay: Identifiable, Hashable {
    let date: Date
    let cycleDay: Int
    let entry: CycleEntry?

    var id: Date { date }
    
    // MARK: - Temperatura
    var temperature: Double?       { entry?.temperature }
    var temperatureExcluded: Bool  { entry?.temperatureExcluded ?? false }

    // MARK: - Krwawienie
    var bleeding: BleedingLevel         { entry?.bleeding ?? .none }
    var bleedingColor: BleedingColor    { entry?.bleedingColor ?? .none }
    var intermenstrualSpotting: Bool    { entry?.intermenstrualSpotting ?? false }

    // MARK: - Śluz
    var mucusSensation:  MucusSensation  { entry?.mucusSensation  ?? .none }
    var mucusAppearance: MucusAppearance { entry?.mucusAppearance ?? .none }
    var mucusStretch:    MucusStretch    { entry?.mucusStretch    ?? .none }
    var mucusVolume:     MucusVolume     { entry?.mucusVolume     ?? .none }
    var isPeakDay: Bool                  { entry?.isPeakDay ?? false }

    // MARK: - Szyjka macicy
    var cervixPosition: CervixPosition { entry?.cervixPosition ?? .none }
    var cervixFirmness: CervixFirmness { entry?.cervixFirmness ?? .none }
    var cervixOpening:  CervixOpening  { entry?.cervixOpening  ?? .none }
    /// Łączny wynik płodności szyjki (0–6); 0 gdy brak wpisu
    var cervixFertilityScore: Int      { entry?.fertilityScore ?? 0 }

    // MARK: - Testy
    var lhTest: LHTestResult              { entry?.lhTest ?? .none }
    var progesteroneTestPositive: Bool?   { entry?.progesteroneTestPositive ?? nil }

    // MARK: - Inne
    var intercourse: IntercourseType       { entry?.intercourse ?? .none }
    var ovulationPainIntensity: Int        { entry?.ovulationPainIntensity ?? 0 }
    var breastTenderness: Int              { entry?.breastTenderness ?? 0 }
    var notes: String                      { entry?.notes ?? "" }
}

enum CalendarHelper {
    static let calendar = Calendar.current

    static func startOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }

    static func monthTitle(for date: Date) -> String {
        date.formatted(.dateTime.month(.wide).year())
    }

    static func weekDaySymbols() -> [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        return Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
    }

    static func visibleDays(for month: Date) -> [CalendarDay] {
        let start = startOfMonth(for: month)

        guard let monthInterval = calendar.dateInterval(of: .month, for: start),
              let monthDays = calendar.range(of: .day, in: .month, for: start) else {
            return []
        }

        let firstDayWeekday = calendar.component(.weekday, from: monthInterval.start)
        let shift = (firstDayWeekday - calendar.firstWeekday + 7) % 7

        var days: [CalendarDay] = []

        for offset in 0..<shift {
            if let date = calendar.date(byAdding: .day, value: -(shift - offset), to: monthInterval.start) {
                days.append(CalendarDay(date: date, isCurrentMonth: false))
            }
        }

        for day in monthDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                days.append(CalendarDay(date: date, isCurrentMonth: true))
            }
        }

        while days.count % 7 != 0 {
            if let lastDate = days.last?.date,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) {
                days.append(CalendarDay(date: nextDate, isCurrentMonth: false))
            }
        }

        while days.count < 42 {
            if let lastDate = days.last?.date,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) {
                days.append(CalendarDay(date: nextDate, isCurrentMonth: false))
            }
        }

        return days
    }

    static func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }

    static func dayNumber(_ date: Date) -> Int {
        calendar.component(.day, from: date)
    }

    static func cycleDay(for date: Date, entries: [CycleEntry]) -> Int? {
        let target = calendar.startOfDay(for: date)

        guard let start = cycleStartDate(for: target, entries: entries),
              let diff = calendar.dateComponents([.day], from: start, to: target).day,
              diff >= 0 else {
            return nil
        }

        return diff + 1
    }

    static func cycleStartDate(for date: Date, entries: [CycleEntry]) -> Date? {
        let target = calendar.startOfDay(for: date)
        return cycleStartDates(in: entries).last(where: { $0 <= target })
    }

    static func cycleStartDates(in entries: [CycleEntry]) -> [Date] {
        let bleedingDays = entries
            .filter { $0.bleeding.indicatesCycleStart }
            .map { calendar.startOfDay(for: $0.date) }
            .sorted()

        guard !bleedingDays.isEmpty else { return [] }

        var starts: [Date] = []
        var currentClusterStart = bleedingDays[0]
        var previousDay = bleedingDays[0]

        starts.append(currentClusterStart)

        for day in bleedingDays.dropFirst() {
            let diff = calendar.dateComponents([.day], from: previousDay, to: day).day ?? 999

            if diff <= 2 {
                previousDay = day
            } else {
                currentClusterStart = day
                previousDay = day
                starts.append(currentClusterStart)
            }
        }

        return starts
    }

    static func cycleDays(containing date: Date, entries: [CycleEntry]) -> [CycleChartDay] {
        guard let startDate = cycleStartDate(for: date, entries: entries) else {
            return []
        }

        let sortedEntries = entries.sorted { $0.date < $1.date }
        let start = calendar.startOfDay(for: startDate)
        let cycleStarts = cycleStartDates(in: entries)

        let nextCycleStart = cycleStarts.first(where: { $0 > start })

        let endDate: Date
        if let nextCycleStart {
            endDate = calendar.date(byAdding: .day, value: -1, to: nextCycleStart) ?? start
        } else {
            endDate = max(calendar.startOfDay(for: date), start)
        }

        guard let dayCount = calendar.dateComponents([.day], from: start, to: endDate).day else {
            return []
        }

        return (0...dayCount).compactMap { offset -> CycleChartDay? in
            guard let currentDate = calendar.date(byAdding: .day, value: offset, to: start) else {
                return nil
            }

            let entry = sortedEntries.last(where: { isSameDay($0.date, currentDate) })

            return CycleChartDay(
                date: currentDate,
                cycleDay: offset + 1,
                entry: entry
            )
        }
    }
}
