//
//  InsightsView.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import SwiftUI
import SwiftData

struct InsightsView: View {
    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]

    private var stats: CycleStatistics {
        CycleAnalyticsService.statistics(from: entries)
    }

    private var insights: [CycleInsight] {
        CycleInsightsService.insights(from: stats)
    }

    var body: some View {
        NavigationStack {
            Group {
                if insights.isEmpty {
                    ContentUnavailableView(
                        "Za mało danych",
                        systemImage: "lightbulb",
                        description: Text("Dodaj przynajmniej dwa cykle, aby zobaczyć wnioski.")
                    )
                } else {
                    List {
                        ForEach(InsightCategory.allDisplayed, id: \.self) { category in
                            let categoryInsights = insights.filter { $0.category == category }
                            if !categoryInsights.isEmpty {
                                Section(category.title) {
                                    ForEach(categoryInsights) { insight in
                                        InsightRow(insight: insight)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Wnioski")
        }
    }
}

// MARK: - InsightRow

private struct InsightRow: View {
    let insight: CycleInsight

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: insight.severity.iconName)
                .foregroundStyle(insight.severity.color)
                .frame(width: 20)
                .padding(.top, 2)
            Text(insight.message)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Extensions

extension InsightSeverity {
    var color: Color {
        switch self {
        case .positive:  return .green
        case .neutral:   return .secondary
        case .warning:   return .orange
        case .attention: return .red
        }
    }

    var iconName: String {
        switch self {
        case .positive:  return "checkmark.circle.fill"
        case .neutral:   return "info.circle.fill"
        case .warning:   return "exclamationmark.triangle.fill"
        case .attention: return "exclamationmark.circle.fill"
        }
    }
}

extension InsightCategory: Hashable {
    var title: String {
        switch self {
        case .cycle:         return "Cykl"
        case .luteal:        return "Faza lutealna"
        case .follicular:    return "Faza folikularna"
        case .bbt:           return "Temperatura BBT"
        case .mucus:         return "Śluz"
        case .cervix:        return "Szyjka macicy"
        case .pain:          return "Ból"
        case .breastfeeding: return "Karmienie piersią"
        case .intercourse:   return "Stosunek"
        case .general:       return "Ogólne"
        }
    }

    static var allDisplayed: [InsightCategory] {
        [.general, .cycle, .luteal, .follicular, .bbt, .mucus, .pain, .breastfeeding]
    }
}
