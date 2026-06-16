//
//  GlossaryListView.swift
//  PMeter
//
//  Created by JCeluch on 15/06/2026.
//

import SwiftUI

struct GlossaryListView: View {
    @State private var viewModel = GlossaryListViewModel()

    var body: some View {
        List {
            categoryFilterSection

            ForEach(viewModel.groupedEntries, id: \.category) { section in
                Section {
                    ForEach(section.entries) { entry in
                        NavigationLink {
                            GlossaryDetailView(
                                entry: entry,
                                relatedEntries: relatedEntries(for: entry)
                            )
                        } label: {
                            GlossaryRowView(entry: entry)
                        }
                    }
                } header: {
                    Label {
                        Text(section.category.title)
                    } icon: {
                        Image(systemName: section.category.systemImage)
                    }
                }
            }
        }
        .navigationTitle(L10n.Education.Glossary.title)
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewModel.searchText,
            prompt: L10n.Education.Glossary.searchPlaceholder
        )
        .overlay {
            if viewModel.filteredEntries.isEmpty {
                ContentUnavailableView(
                    L10n.Education.Glossary.emptyTitle,
                    systemImage: "magnifyingglass",
                    description: Text(L10n.Education.Glossary.emptyMessage)
                )
            }
        }
    }

    private var categoryFilterSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryChip(
                        title: L10n.Education.Glossary.allCategories,
                        isSelected: viewModel.selectedCategory == nil
                    ) {
                        viewModel.selectedCategory = nil
                    }

                    ForEach(GlossaryCategory.allCases) { category in
                        categoryChip(
                            title: category.title,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }

    private func relatedEntries(for entry: GlossaryEntry) -> [GlossaryEntry] {
        entry.relatedEntryIDs.compactMap(viewModel.entry(for:))
    }

    private func categoryChip(
        title: LocalizedStringKey,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.footnote.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor.opacity(0.16) : Color.secondary.opacity(0.12))
                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct GlossaryRowView: View {
    let entry: GlossaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.title)
                .font(.headline)

            Text(entry.shortDefinition)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(entry.tags) { tag in
                            Text(tag.title)
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.secondary.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
