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
//    let entries: [CycleEntry]

    @State private var selectedFilter: InsightSeverity? = nil

    private var stats: CycleStatistics {
        CycleAnalyticsService.statistics(from: entries)
    }

    private var allInsights: [CycleInsight] {
        CycleInsightsService.insights(from: stats)
    }

    private var filteredInsights: [CycleInsight] {
        guard let filter = selectedFilter else { return allInsights }
        return allInsights.filter { $0.severity == filter }
    }

    private var groupedInsights: [(String, [CycleInsight])] {
        let order: [InsightSeverity] = [.attention, .warning, .positive, .neutral]
        return order.compactMap { severity in
            let group = filteredInsights.filter { $0.severity == severity }
            guard !group.isEmpty else { return nil }
            return (severityGroupTitle(severity), group)
        }
    }

    var body: some View {
        Group {
            if allInsights.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        filterBar
                        if filteredInsights.isEmpty {
                            noResultsState
                        } else {
                            insightsList
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Wnioski")
        .inlineNavigationTitle()
    }

    // MARK: - Filter bar

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(label: "Wszystkie", severity: nil)
                filterChip(label: "⚠️ Uwaga", severity: .attention)
                filterChip(label: "🟡 Obserwuj", severity: .warning)
                filterChip(label: "✅ OK", severity: .positive)
                filterChip(label: "ℹ️ Info", severity: .neutral)
            }
        }
    }

    private func filterChip(label: String, severity: InsightSeverity?) -> some View {
        let isActive = selectedFilter == severity
        return Button {
            withAnimation(.easeInOut(duration: 0.18)) {
                selectedFilter = severity
            }
        } label: {
            Text(label)
                .font(.subheadline.weight(isActive ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isActive ? Color.pmPrimary : Color.pmSurface)
                )
                .foregroundStyle(isActive ? Color.white : Color.pmTextPrimary)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Insights list

    private var insightsList: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(groupedInsights, id: \.0) { groupTitle, insights in
                VStack(alignment: .leading, spacing: 10) {
                    Text(groupTitle)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Color.pmTextSecondary)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    ForEach(insights) { insight in
                        InsightCard(insight: insight)
                    }
                }
            }

            dataQualityFooter
        }
    }

    // MARK: - Data quality footer

    private var dataQualityFooter: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.caption)
                .foregroundStyle(Color.pmTextSecondary)
            Text("Wnioski oparte na \(stats.cycleCount) \(cycleCountLabel(stats.cycleCount)). Im więcej danych, tym trafniejsze obserwacje.")
                .font(.caption)
                .foregroundStyle(Color.pmTextSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.pmSurface)
        )
    }

    // MARK: - Empty states

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(Color.pmTextSecondary.opacity(0.4))
            Text("Za mało danych")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.pmTextPrimary)
            Text("Wnioski pojawią się po zebraniu danych z co najmniej 2 cykli.")
                .font(.subheadline)
                .foregroundStyle(Color.pmTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
    }

    private var noResultsState: some View {
        VStack(spacing: 10) {
            Text("Brak wniosków w tej kategorii")
                .font(.subheadline)
                .foregroundStyle(Color.pmTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    // MARK: - Helpers

    private func severityGroupTitle(_ severity: InsightSeverity) -> String {
        switch severity {
        case .attention: return "Warto skonsultować"
        case .warning:   return "Warto obserwować"
        case .positive:  return "Dobrze rokuje"
        case .neutral:   return "Informacje"
        }
    }

    private func cycleCountLabel(_ count: Int) -> String {
        switch count {
        case 1: return "cyklu"
        case 2...4: return "cyklach"
        default: return "cyklach"
        }
    }
}


//import SwiftUI
//import SwiftData
//
//struct InsightsView: View {
//    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]
//
//    private var stats: CycleStatistics {
//        CycleAnalyticsService.statistics(from: entries)
//    }
//
//    private var insights: [CycleInsight] {
//        CycleInsightsService.insights(from: stats)
//    }
//
//    var body: some View {
//        NavigationStack {
//            Group {
//                if insights.isEmpty {
//                    ContentUnavailableView(
//                        "Za mało danych",
//                        systemImage: "lightbulb",
//                        description: Text("Dodaj przynajmniej dwa cykle, aby zobaczyć wnioski.")
//                    )
//                } else {
//                    List {
//                        ForEach(InsightCategory.allDisplayed, id: \.self) { category in
//                            let categoryInsights = insights.filter { $0.category == category }
//                            if !categoryInsights.isEmpty {
//                                Section(category.title) {
//                                    ForEach(categoryInsights) { insight in
//                                        InsightRow(insight: insight)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Wnioski")
//        }
//    }
//}
//
//// MARK: - InsightRow
//
//private struct InsightRow: View {
//    let insight: CycleInsight
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 12) {
//            Image(systemName: insight.severity.iconName)
//                .foregroundStyle(insight.severity.color)
//                .frame(width: 20)
//                .padding(.top, 2)
//            Text(insight.message)
//                .font(.subheadline)
//                .fixedSize(horizontal: false, vertical: true)
//        }
//        .padding(.vertical, 4)
//    }
//}
//
//// MARK: - Extensions
//
//extension InsightSeverity {
//    var color: Color {
//        switch self {
//        case .positive:  return .green
//        case .neutral:   return .secondary
//        case .warning:   return .orange
//        case .attention: return .red
//        }
//    }
//
//    var iconName: String {
//        switch self {
//        case .positive:  return "checkmark.circle.fill"
//        case .neutral:   return "info.circle.fill"
//        case .warning:   return "exclamationmark.triangle.fill"
//        case .attention: return "exclamationmark.circle.fill"
//        }
//    }
//}
//
//extension InsightCategory: Hashable {
//    var title: String {
//        switch self {
//        case .cycle:         return "Cykl"
//        case .luteal:        return "Faza lutealna"
//        case .follicular:    return "Faza folikularna"
//        case .bbt:           return "Temperatura BBT"
//        case .mucus:         return "Śluz"
//        case .cervix:        return "Szyjka macicy"
//        case .pain:          return "Ból"
//        case .breastfeeding: return "Karmienie piersią"
//        case .intercourse:   return "Stosunek"
//        case .general:       return "Ogólne"
//        }
//    }
//
//    static var allDisplayed: [InsightCategory] {
//        [.general, .cycle, .luteal, .follicular, .bbt, .mucus, .pain, .breastfeeding]
//    }
//}
