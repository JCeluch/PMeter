//
//  StatsViewModel.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class StatsViewModel {
    private(set) var stats: CycleStatistics?

    func update(entries: [CycleEntry]) {
        // Task.detached – przeliczenie na tle, nie blokuje main thread
        Task.detached(priority: .userInitiated) { [entries] in
            let computed = CycleAnalyticsService.statistics(from: entries)
            await MainActor.run { self.stats = computed }
        }
    }
}
