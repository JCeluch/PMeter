//
//  CycleEntryRepository.swift
//  PMeter
//
//  Created by JCeluch on 12/06/2026.
//

import Foundation

@MainActor
protocol CycleEntryRepository {
    func fetchAll() throws -> [CycleEntry]
    func fetchEntry(for date: Date) throws -> CycleEntry?
    func insert(_ entry: CycleEntry) throws
    func insert(_ entries: [CycleEntry]) throws
    func save() throws
    func delete(_ entry: CycleEntry) throws
    func deleteAll() throws
    func count() throws -> Int
}
