//
//  SeedService.swift
//  PMeter
//
//  Created by JCeluch on 13/06/2026.
//

import Foundation

@MainActor
final class SeedService {
    private let repository: CycleEntryRepository

    init(repository: CycleEntryRepository) {
        self.repository = repository
    }

    func seedIfNeeded() throws {
        guard try repository.count() == 0 else { return }
        let entries = PreviewSeed.makeCycleEntries()
        try repository.insert(entries)
    }

    func reseed() throws {
        try repository.deleteAll()
        let entries = PreviewSeed.makeCycleEntries()
        try repository.insert(entries)
    }
}
