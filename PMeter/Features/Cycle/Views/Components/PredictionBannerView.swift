//
//  PredictionBannerView.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import SwiftUI

struct PredictionBannerView: View {
    let prediction: CyclePredictionService.Prediction
    let currentCycleDay: Int?

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Główny wiersz — zawsze widoczny
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    cyclePhaseIcon
                    mainContent
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(Color.pmTextSecondary)
                }
                .padding(14)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .padding(.horizontal, 14)

                VStack(alignment: .leading, spacing: 10) {
                    if let ov = prediction.ovulationDate {
                        predictionRow(
                            icon: "sun.max.fill",
                            color: .orange,
                            label: "Owulacja",
                            value: ov.formatted(date: .abbreviated, time: .omitted)
                        )
                    }

                    if let fs = prediction.fertileWindowStart, let fe = prediction.fertileWindowEnd {
                        predictionRow(
                            icon: "drop.fill",
                            color: .pmPrimary,
                            label: "Okno płodne",
                            value: "\(fs.formatted(date: .abbreviated, time: .omitted)) – \(fe.formatted(date: .abbreviated, time: .omitted))"
                        )
                    }

                    if let earliest = prediction.nextPeriodEarliest,
                       let latest = prediction.nextPeriodLatest,
                       earliest != latest {
                        predictionRow(
                            icon: "calendar",
                            color: .pmPeriod,
                            label: "Przedział ufności",
                            value: "\(earliest.formatted(date: .abbreviated, time: .omitted)) – \(latest.formatted(date: .abbreviated, time: .omitted))"
                        )
                    }

                    dataQualityBadge
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.pmSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(phaseColor.opacity(0.25), lineWidth: 1)
                )
        )
    }

    // MARK: - Subviews

    private var cyclePhaseIcon: some View {
        Circle()
            .fill(phaseColor.opacity(0.12))
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: phaseIconName)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(phaseColor)
            )
    }

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let day = currentCycleDay {
                Text("Dzień \(day) cyklu")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.pmTextPrimary)
            }

            if let next = prediction.nextPeriodStart {
                let daysLeft = Calendar.current.dateComponents([.day], from: .now, to: next).day ?? 0
                Group {
                    if daysLeft < 0 {
                        Text("Miesiączka spodziewana \(abs(daysLeft)) dni temu")
                            .foregroundStyle(Color.pmPeriod)
                    } else if daysLeft == 0 {
                        Text("Miesiączka spodziewana dzisiaj")
                            .foregroundStyle(Color.pmPeriod)
                    } else {
                        Text("Kolejna miesiączka za \(daysLeft) \(dniLabel(daysLeft))")
                            .foregroundStyle(Color.pmTextSecondary)
                    }
                }
                .font(.caption)
            }

            if isFertileWindowActive {
                Text("📍 W oknie płodnym")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Color.pmPrimary)
            }
        }
    }

    private func predictionRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 16)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.pmTextSecondary)
            Spacer()
            Text(value)
                .font(.caption.weight(.medium))
                .foregroundStyle(Color.pmTextPrimary)
        }
    }

    private var dataQualityBadge: some View {
        let (label, color) = qualityLabelAndColor
        return HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .font(.caption2)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color.pmTextSecondary)
        }
        .padding(.top, 4)
    }

    // MARK: - Helpers

    private var isFertileWindowActive: Bool {
        guard let fs = prediction.fertileWindowStart, let fe = prediction.fertileWindowEnd else { return false }
        let today = Calendar.current.startOfDay(for: .now)
        return today >= fs && today <= fe
    }

    private var phaseIconName: String {
        if isFertileWindowActive { return "drop.fill" }
        if let next = prediction.nextPeriodStart {
            let days = Calendar.current.dateComponents([.day], from: .now, to: next).day ?? 99
            if days <= 5 { return "moon.fill" }
        }
        return "sun.max.fill"
    }

    private var phaseColor: Color {
        if isFertileWindowActive { return .pmPrimary }
        if let next = prediction.nextPeriodStart {
            let days = Calendar.current.dateComponents([.day], from: .now, to: next).day ?? 99
            if days <= 5 { return .pmPeriod }
        }
        return .orange
    }

    private var qualityLabelAndColor: (String, Color) {
        switch prediction.dataQuality {
        case .insufficient: return ("Za mało danych dla predykcji", .pmTextSecondary)
        case .low:          return ("Predykcja przybliżona (2–3 cykle)", .orange)
        case .medium:       return ("Predykcja umiarkowana (4+ cykli)", .pmTextSecondary)
        case .high:         return ("Predykcja oparta na historii Peak Day", .green)
        }
    }

    private func dniLabel(_ count: Int) -> String {
        switch count {
        case 1: return "dzień"
        case 2...4: return "dni"
        default: return "dni"
        }
    }
}
