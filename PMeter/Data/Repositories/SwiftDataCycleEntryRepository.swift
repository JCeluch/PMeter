//
//  SwiftDataCycleEntryRepository.swift
//  PMeter
//
//  Created by JCeluch on 12/06/2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataCycleEntryRepository: CycleEntryRepository {
    private let modelContext: ModelContext
    private let calendar: Calendar

    init(
        modelContext: ModelContext,
        calendar: Calendar = .current
    ) {
        self.modelContext = modelContext
        self.calendar = calendar
    }

    func fetchAll() throws -> [CycleEntry] {
        let descriptor = FetchDescriptor<CycleEntry>(
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchEntry(for date: Date) throws -> CycleEntry? {
        let dayStart = calendar.startOfDay(for: date)
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
            return nil
        }

        let predicate = #Predicate<CycleEntry> { entry in
            entry.date >= dayStart && entry.date < nextDay
        }

        var descriptor = FetchDescriptor<CycleEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
    }

    func insert(_ entry: CycleEntry) throws {
        modelContext.insert(entry)
        try save()
    }

    func insert(_ entries: [CycleEntry]) throws {
        for entry in entries {
            modelContext.insert(entry)
        }
        try save()
    }

    func save() throws {
        try modelContext.save()
    }

    func delete(_ entry: CycleEntry) throws {
        modelContext.delete(entry)
        try save()
    }

    func deleteAll() throws {
        let entries = try fetchAll()
        for entry in entries {
            modelContext.delete(entry)
        }
        try save()
    }

    func count() throws -> Int {
        let descriptor = FetchDescriptor<CycleEntry>()
        return try modelContext.fetchCount(descriptor)
    }
}
