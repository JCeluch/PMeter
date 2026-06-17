//
//  InsightCard.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import SwiftUI

struct InsightCard: View {
    let insight: CycleInsight

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(severityColor.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: categoryIcon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(severityColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(categoryLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(severityColor)
                    .textCase(.uppercase)
                    .tracking(0.4)

                Text(insight.message)
                    .font(.subheadline)
                    .foregroundStyle(Color.pmTextPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pmSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(severityColor.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Helpers

    private var severityColor: Color {
        switch insight.severity {
        case .positive:   return .green
        case .neutral:    return Color.pmTextSecondary
        case .warning:    return .orange
        case .attention:  return .red
        }
    }

    private var categoryIcon: String {
        switch insight.category {
        case .cycle:         return "arrow.triangle.2.circlepath"
        case .luteal:        return "moon.fill"
        case .follicular:    return "sun.max.fill"
        case .bbt:           return "thermometer.medium"
        case .mucus:         return "drop.fill"
        case .cervix:        return "circle.dotted"
        case .pain:          return "bolt.fill"
        case .breastfeeding: return "heart.fill"
        case .intercourse:   return "person.2.fill"
        case .general:       return "lightbulb.fill"
        }
    }

    private var categoryLabel: String {
        switch insight.category {
        case .cycle:         return "Cykl"
        case .luteal:        return "Faza lutealna"
        case .follicular:    return "Faza folikularna"
        case .bbt:           return "Temperatura"
        case .mucus:         return "Śluz"
        case .cervix:        return "Szyjka macicy"
        case .pain:          return "Ból"
        case .breastfeeding: return "Karmienie"
        case .intercourse:   return "Stosunek"
        case .general:       return "Samopoczucie"
        }
    }
}
