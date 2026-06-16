//
//  SeedService.swift
//  PMeter
//
//  Created by JCeluch on 13/06/2026.
//

import Foundation

enum SeedPreset {
    /// Losowe dane testowe (obecny PreviewSeed)
    case random
    /// Dane historyczne z eksportu aplikacji partnerki
    case historicalPartner
}

@MainActor
final class SeedService {
    private let repository: CycleEntryRepository

    init(repository: CycleEntryRepository) {
        self.repository = repository
    }

    /// Ładuje wybrany preset, usuwając wszystkie istniejące dane.
    func reseed(preset: SeedPreset) throws {
        try repository.deleteAll()
        let entries: [CycleEntry]
        switch preset {
        case .random:
            entries = PreviewSeed.makeCycleEntries()
        case .historicalPartner:
            entries = HistoricalPartnerSeed.makeCycleEntries()
        }
        try repository.insert(entries)
    }
}
