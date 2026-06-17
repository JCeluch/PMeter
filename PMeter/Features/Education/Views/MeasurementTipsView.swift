//
//  MeasurementTipsView.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import SwiftUI

struct MeasurementTipsView: View {
    var body: some View {
        List {
            Section {
                Text(L10n.Education.MeasurementTips.intro)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }

            Section(header: Text(L10n.Education.MeasurementTips.Section.temperature)) {
                ForEach(MeasurementTip.temperature) { tip in
                    NavigationLink {
                        MeasurementTipDetailView(tip: tip)
                    } label: {
                        MeasurementTipRowView(tip: tip)
                    }
                }
            }

            Section(header: Text(L10n.Education.MeasurementTips.Section.mucus)) {
                ForEach(MeasurementTip.mucus) { tip in
                    NavigationLink {
                        MeasurementTipDetailView(tip: tip)
                    } label: {
                        MeasurementTipRowView(tip: tip)
                    }
                }
            }

            Section(header: Text(L10n.Education.MeasurementTips.Section.cervix)) {
                ForEach(MeasurementTip.cervix) { tip in
                    NavigationLink {
                        MeasurementTipDetailView(tip: tip)
                    } label: {
                        MeasurementTipRowView(tip: tip)
                    }
                }
            }
        }
        .navigationTitle(L10n.Education.MeasurementTips.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Row

private struct MeasurementTipRowView: View {
    let tip: MeasurementTip

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: tip.systemImage)
                .font(.title2)
                .foregroundStyle(.accent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.headline)
                Text(tip.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Detail

struct MeasurementTipDetailView: View {
    let tip: MeasurementTip

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: tip.systemImage)
                        .font(.largeTitle)
                        .foregroundStyle(.accent)
                    Text(tip.title)
                        .font(.title2.bold())
                    Text(tip.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Divider()
                    .padding(.horizontal)

                // Treść
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(tip.bodyParagraphs.enumerated()), id: \.offset) { _, paragraph in
                        Text(paragraph)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)

                // ✅ Dobre praktyki
                if !tip.dos.isEmpty {
                    TipListBlock(
                        label: L10n.Education.MeasurementTips.dos,
                        items: tip.dos,
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    .padding(.horizontal)
                }

                // ❌ Czego unikać
                if !tip.donts.isEmpty {
                    TipListBlock(
                        label: L10n.Education.MeasurementTips.donts,
                        items: tip.donts,
                        icon: "xmark.circle.fill",
                        color: .red
                    )
                    .padding(.horizontal)
                }

                // ⚠️ Uwaga
                if let warning = tip.warning {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.subheadline)
                            .padding(.top, 1)
                        Text(warning)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .background(Color.orange.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                Spacer(minLength: 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Shared block

private struct TipListBlock: View {
    let label: LocalizedStringKey
    let items: [LocalizedStringKey]
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                        .font(.subheadline)
                        .padding(.top, 1)
                    Text(item)
                        .font(.subheadline)
                }
            }
        }
        .padding(14)
        .background(color.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
