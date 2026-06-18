//
//  StatsView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]
    @Environment(CycleStore.self) private var store
    @State private var vm = StatsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.stats == nil {
                    StatsSkeletonView()
                } else if let stats = vm.stats {
                    StatsContentView(stats: stats)
                }
            }
            .navigationTitle("Statystyki")
        }
        .task(id: entries.map(\.id).hashValue) {
            vm.update(entries: entries)
        }
    }
}
