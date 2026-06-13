//
//  EntryDetailView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    let entry: CycleEntry

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        List {
            Section(L10n.CycleDetail.dateSection) {
                detailRow(
                    title: L10n.CycleDetail.day,
                    value: Text(entry.date.formatted(date: .long, time: .omitted))
                )
            }

            Section(L10n.CycleDetail.observationsSection) {
                detailRow(
                    title: L10n.CycleDetail.bleeding,
                    value: Text(entry.bleeding.localizationKey)
                )

                detailRow(
                    title: L10n.CycleDetail.mucus,
                    value: Text(entry.mucus.localizationKey)
                )

                detailRow(
                    title: L10n.CycleDetail.mucusAmount,
                    value: Text("\(entry.mucusAmount)/5")
                )
                
                detailRow(
                    title: L10n.CycleDetail.cervix,
                    value: Text(entry.cervix.localizationKey)
                )

                detailRow(
                    title: L10n.CycleDetail.breastTenderness,
                    value: Text("\(entry.breastTenderness)/5")
                )
                
                detailRow(
                    title: L10n.CycleDetail.lhTest,
                    value: Text(entry.lhTest.localizationKey)
                )

                detailRow(
                    title: L10n.CycleDetail.intercourse,
                    value: Text(entry.intercourse ? L10n.Common.yes : L10n.Common.no)
                )

                if let temperature = entry.temperature {
                    detailRow(
                        title: L10n.CycleDetail.temperature,
                        value: Text("\(temperature.formatted(.number.precision(.fractionLength(2))))°C")
                    )
                } else {
                    detailRow(
                        title: L10n.CycleDetail.temperature,
                        value: Text(L10n.Common.none)
                    )
                }
            }

            Section(L10n.CycleDetail.notesSection) {
                if entry.notes.isEmpty {
                    Text(L10n.CycleDetail.noNotes)
                        .foregroundStyle(Color.pmTextSecondary)
                } else {
                    Text(entry.notes)
                        .foregroundStyle(Color.pmTextPrimary)
                }
            }

            Section {
                Button(L10n.Common.edit) {
                    showingEditSheet = true
                }
                .foregroundStyle(Color.pmPrimary)

                Button(L10n.CycleDetail.deleteEntry, role: .destructive) {
                    showingDeleteAlert = true
                }
            }
        }
        .navigationTitle(L10n.CycleDetail.title)
        .inlineNavigationTitle()
        .sheet(isPresented: $showingEditSheet) {
            EntryFormView(existingEntry: entry)
        }
        .alert(L10n.CycleDetail.deleteConfirmTitle, isPresented: $showingDeleteAlert) {
            Button(L10n.Common.delete, role: .destructive) {
                deleteEntry()
            }
            Button(L10n.Common.cancel, role: .cancel) { }
        } message: {
            Text(L10n.CycleDetail.deleteConfirmMessage)
        }
    }

    private func detailRow(
        title: LocalizedStringKey,
        value: Text
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.pmTextSecondary)

            Spacer()

            value
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color.pmTextPrimary)
        }
    }

    private func deleteEntry() {
        modelContext.delete(entry)
        dismiss()
    }
}

//#Preview {
//    EntryDetailView(
//        entry: CycleEntry(
//            date: .now,
//            bleeding: "Lekkie",
//            mucus: "Kremowy",
//            temperature: 36.70,
//            intercourse: false,
//            notes: "Przykładowy wpis"
//        )
//    )
//    .modelContainer(for: CycleEntry.self, inMemory: true)
//}
