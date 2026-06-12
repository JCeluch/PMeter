//
//  StatsView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]

    private var stats: CycleStatistics {
        CycleAnalyticsService.statistics(from: entries)
    }

    var body: some View {
        NavigationStack {
            List {
                if stats.cycleCount == 0 {
                    ContentUnavailableView(
                        "Brak danych do analizy",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Dodaj przynajmniej dwa cykle, aby zobaczyć statystyki i przewidywania.")
                    )
                } else {
                    Section("Cykl") {
                        statRow("Liczba pełnych cykli", value: "\(stats.cycleCount)")
                        statRow("Średnia długość cyklu", value: days(stats.averageCycleLength))
                        statRow("Mediana", value: days(stats.medianCycleLength))
                        statRow("Najkrótszy cykl", value: intDays(stats.shortestCycle))
                        statRow("Najdłuższy cykl", value: intDays(stats.longestCycle))
                        statRow("Zmienność", value: formatted(stats.cycleVariability))
                        statRow("Regularność", value: "\(Int(stats.regularityScore))%")
                    }

                    Section("Przewidywania") {
                        statRow("Następna miesiączka", value: formattedDate(stats.predictedNextPeriodStart))
                        statRow("Szacowana owulacja", value: formattedDate(stats.predictedOvulationDate))
                        statRow("Okno płodne", value: formattedRange(stats.predictedFertileWindowStart, stats.predictedFertileWindowEnd))
                    }

                    Section("Obserwacje") {
                        statRow("Pomiarów temperatury", value: "\(stats.temperatureEntryCount)")
                        statRow("Średnia temperatura", value: temperature(stats.averageTemperature))
                        statRow("LH peak", value: "\(stats.lhPeakCount)")
                    }

                    if !stats.cycleLengths.isEmpty {
                        Section("Długości cykli") {
                            ForEach(Array(stats.cycleLengths.enumerated()), id: \.offset) { index, value in
                                statRow("Cykl \(index + 1)", value: "\(value) dni")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Statystyki")
        }
    }

    private func statRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }

    private func formatted(_ value: Double) -> String {
        guard value > 0 else { return "—" }
        return String(format: "%.1f", value)
    }

    private func days(_ value: Double) -> String {
        guard value > 0 else { return "—" }
        return "\(Int(round(value))) dni"
    }

    private func intDays(_ value: Int?) -> String {
        guard let value else { return "—" }
        return "\(value) dni"
    }

    private func temperature(_ value: Double?) -> String {
        guard let value else { return "—" }
        return String(format: "%.2f °C", value)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "—" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func formattedRange(_ start: Date?, _ end: Date?) -> String {
        guard let start, let end else { return "—" }
        return "\(start.formatted(date: .abbreviated, time: .omitted)) – \(end.formatted(date: .abbreviated, time: .omitted))"
    }
}
