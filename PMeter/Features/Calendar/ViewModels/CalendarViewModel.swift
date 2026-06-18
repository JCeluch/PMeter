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

            await MainActor.run {
                self.entriesByDay = byDay
                self.visibleDays = days
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
}
