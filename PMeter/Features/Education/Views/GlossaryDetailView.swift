//
//  GlossaryDetailView.swift
//  PMeter
//
//  Created by JCeluch on 15/06/2026.
//

import SwiftUI

struct GlossaryDetailView: View {
    let entry: GlossaryEntry
    let relatedEntries: [GlossaryEntry]

    var body: some View {
        List {
            summarySection

            if !entry.measurementTips.isEmpty {
                tipsSection
            }

            if !relatedEntries.isEmpty {
                relatedSection
            }
        }
        .navigationTitle(Text(entry.title))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                Label {
                    Text(entry.category.title)
                } icon: {
                    Image(systemName: entry.category.systemImage)
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.accent)

                Text(entry.definition)
                    .font(.body)

                if !entry.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.Education.Glossary.tags)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        tagWrap
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var tipsSection: some View {
        Section {
            ForEach(entry.measurementTips) { tip in
                Label {
                    Text(tip.text)
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                }
            }
        } header: {
            Text(L10n.Education.Glossary.tips)
        }
    }

    private var relatedSection: some View {
        Section {
            ForEach(relatedEntries) { relatedEntry in
                VStack(alignment: .leading, spacing: 4) {
                    Text(relatedEntry.title)
                        .font(.headline)

                    Text(relatedEntry.shortDefinition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        } header: {
            Text(L10n.Education.Glossary.related)
        }
    }

    private var tagWrap: some View {
        let rows = chunked(entry.tags, size: 3)

        return VStack(alignment: .leading, spacing: 8) {
            ForEach(rows.indices, id: \.self) { index in
                let row = rows[index]

                HStack {
                    ForEach(row) { tag in
                        Text(tag.title)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    private func chunked(_ array: [GlossaryTag], size: Int) -> [[GlossaryTag]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0 ..< min($0 + size, array.count)])
        }
    }
}
