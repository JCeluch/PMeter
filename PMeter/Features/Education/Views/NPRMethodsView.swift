//
//  NPRMethodsView.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import SwiftUI

struct NPRMethodsView: View {
    var body: some View {
        List {
            Section {
                Text(L10n.Education.NPRMethods.intro)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }

            Section(header: Text(L10n.Education.NPRMethods.Section.sympto)) {
                ForEach(NPRMethod.symptoThermal) { method in
                    NPRMethodRow(method: method)
                }
            }

            Section(header: Text(L10n.Education.NPRMethods.Section.mucusBased)) {
                ForEach(NPRMethod.mucusBased) { method in
                    NPRMethodRow(method: method)
                }
            }

            Section(header: Text(L10n.Education.NPRMethods.Section.other)) {
                ForEach(NPRMethod.other) { method in
                    NPRMethodRow(method: method)
                }
            }
        }
        .navigationTitle(L10n.Education.NPRMethods.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Row

private struct NPRMethodRow: View {
    let method: NPRMethod

    var body: some View {
        NavigationLink {
            NPRMethodDetailView(method: method)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: method.systemImage)
                    .font(.title2)
                    .foregroundStyle(.accent)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(method.name)
                        .font(.headline)
                    Text(method.tagline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Detail

struct NPRMethodDetailView: View {
    let method: NPRMethod

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        Image(systemName: method.systemImage)
                            .font(.largeTitle)
                            .foregroundStyle(.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(method.name)
                                .font(.title2.bold())
                            Text(method.tagline)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Badges
                    HStack(spacing: 8) {
                        NPRBadge(label: method.signsUsedBadge, color: .blue)
                        NPRBadge(label: method.difficultyBadge, color: method.difficultyColor)
                        if method.hasScientificBacking {
                            NPRBadge(label: L10n.Education.NPRMethods.Detail.Badge.evidenceBased, color: .green)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Divider().padding(.horizontal)

                // Opis
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(method.descriptionParagraphs.enumerated()), id: \.offset) { _, para in
                        Text(para)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)

                // Znaki obserwacji
                NPRDetailBlock(
                    title: L10n.Education.NPRMethods.Detail.signsTitle,
                    items: method.signs,
                    icon: "eye",
                    color: .blue
                )
                .padding(.horizontal)

                // Reguły
                NPRDetailBlock(
                    title: L10n.Education.NPRMethods.Detail.rulesTitle,
                    items: method.keyRules,
                    icon: "list.bullet.clipboard",
                    color: .orange
                )
                .padding(.horizontal)

                // Dla kogo
                VStack(alignment: .leading, spacing: 10) {
                    Text(L10n.Education.NPRMethods.Detail.suitableFor)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Text(method.suitableFor)
                        .font(.subheadline)
                }
                .padding(14)
                .background(Color.accentColor.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // Źródła/certyfikacja
                if let source = method.certificationInfo {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "graduationcap.fill")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .padding(.top, 1)
                        Text(source)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }

                Spacer(minLength: 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Shared components

private struct NPRBadge: View {
    let label: LocalizedStringKey
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

private struct NPRDetailBlock: View {
    let title: LocalizedStringKey
    let items: [LocalizedStringKey]
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                        .font(.caption)
                        .padding(.top, 2)
                    Text(item)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(14)
        .background(color.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
