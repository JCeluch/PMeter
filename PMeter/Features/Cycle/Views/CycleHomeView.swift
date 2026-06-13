//
//  CycleHomeView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct CycleHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CycleEntry.date, order: .reverse) private var entries: [CycleEntry]

    @State private var showingAddEntry = false

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    emptyState
                } else {
                    entriesList
                }
            }
            .background(Color.pmBackground.ignoresSafeArea())
            .navigationTitle(L10n.CycleList.title)
            .inlineNavigationTitle()
            .toolbarTrailingItem {
                Button {
                    showingAddEntry = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(Text(L10n.CycleList.add))
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "drop.circle")
                .font(.system(size: 42))
                .foregroundStyle(Color.pmPrimary)

            Text(L10n.CycleList.emptyTitle)
                .font(.title2.bold())
                .foregroundStyle(Color.pmTextPrimary)

            Text(L10n.CycleList.emptySubtitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.pmTextSecondary)
                .padding(.horizontal, 24)

            Button(L10n.CycleList.add) {
                showingAddEntry = true
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.pmPrimary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pmBackground)
    }

    private var entriesList: some View {
        List {
            Section(L10n.CycleList.recentEntries) {
                ForEach(entries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                            .inlineNavigationTitle()
                    } label: {
                        entryRow(entry)
                    }
                    .listRowBackground(Color.pmSurface)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            delete(entry)
                        } label: {
                            Label {
                                Text(L10n.Common.delete)
                            } icon: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
        }
        .platformFormListStyle()
        .scrollContentBackground(.hidden)
        .background(Color.pmBackground)
    }

    private func entryRow(_ entry: CycleEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
                .foregroundStyle(Color.pmTextPrimary)

            HStack(spacing: 12) {
                Label {
                    Text(entry.bleeding.localizationKey)
                } icon: {
                    Image(systemName: "drop.fill")
                }
                .foregroundStyle(Color.pmPeriod)

                Label {
                    Text(entry.mucus.localizationKey)
                } icon: {
                    Image(systemName: "circle.lefthalf.filled")
                }
                .foregroundStyle(Color.pmPrimary)
            }
            .font(.subheadline)
            
            if entry.lhTest != .none {
                HStack(spacing: 4) {
                    Text(L10n.CycleList.lhTestPrefix)
                    Text(entry.lhTest.localizationKey)
                }
                .font(.subheadline)
                .foregroundStyle(Color.pmTextSecondary)
            }

            if let temperature = entry.temperature {
                HStack(spacing: 4) {
                    Text(L10n.CycleDetail.temperature)
                    Text("\(temperature.formatted(.number.precision(.fractionLength(2))))°C")
                }
                .font(.subheadline)
                .foregroundStyle(Color.pmTextSecondary)
            }

            if entry.intercourse {
                Text(L10n.CycleList.intercourseSaved)
                    .font(.footnote)
                    .foregroundStyle(Color.pmTextSecondary)
            }

            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.footnote)
                    .foregroundStyle(Color.pmTextSecondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 6)
    }

    private func delete(_ entry: CycleEntry) {
        modelContext.delete(entry)
    }
}

//#Preview {
//    CycleHomeView()
//        .modelContainer(for: CycleEntry.self, inMemory: true)
//}
