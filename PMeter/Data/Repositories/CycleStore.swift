//
//  CycleStore.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class CycleStore {
    private(set) var stats: CycleStatistics?
    private(set) var entries: [CycleEntry] = []

    func refreshIfNeeded(entries newEntries: [CycleEntry]) {
        guard newEntries.count != entries.count else { return }
        entries = newEntries
        Task.detached(priority: .userInitiated) { [newEntries] in
            let s = CycleAnalyticsService.statistics(from: newEntries)
            await MainActor.run { self.stats = s }
        }
    }
}
