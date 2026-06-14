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
                // Krwawienie
                detailRow(title: L10n.CycleDetail.bleeding, value: Text(entry.bleeding.localizationKey))
                if entry.bleeding != .none {
                    detailRow(title: "Kolor krwawienia", value: Text(entry.bleedingColor.localizationKey))
                }
                if entry.intermenstrualSpotting {
                    detailRow(title: "Plamienie śródcykliczne", value: Text("Tak"))
                }
                if entry.menstrualPainIntensity > 0 {
                    detailRow(title: "Ból menstruacyjny", value: Text("\(entry.menstrualPainIntensity)/5"))
                }

                // Śluz
                detailRow(title: "Odczucie śluzu", value: Text(entry.mucusSensation.localizationKey))
                detailRow(title: "Wygląd śluzu", value: Text(entry.mucusAppearance.localizationKey))
                detailRow(title: "Rozciągliwość", value: Text(entry.mucusStretch.localizationKey))
                detailRow(title: "Objętość śluzu", value: Text(entry.mucusVolume.localizationKey))
                if entry.isPeakDay {
                    detailRow(title: "Dzień szczytowy", value: Text("✓").foregroundStyle(Color.pmPrimary))
                }

                // Szyjka macicy (SHOW)
                detailRow(title: "Pozycja szyjki", value: Text(entry.cervixPosition.localizationKey))
                detailRow(title: "Twardość szyjki", value: Text(entry.cervixFirmness.localizationKey))
                detailRow(title: "Ujście szyjki", value: Text(entry.cervixOpening.localizationKey))

                // Temperatura
                if let temperature = entry.temperature {
                    detailRow(title: L10n.CycleDetail.temperature,
                              value: Text("\(temperature.formatted(.number.precision(.fractionLength(2))))°C"))
                    if !entry.bbtDisturbances.isEmpty {
                        detailRow(title: "Zakłócenia BBT",
                                  value: Text(entry.bbtDisturbances.map(\.rawValue).joined(separator: ", ")))
                    }
                    if entry.temperatureExcluded {
                        detailRow(title: "Temperatura wykluczona", value: Text("Tak").foregroundStyle(.orange))
                    }
                } else {
                    detailRow(title: L10n.CycleDetail.temperature, value: Text(L10n.Common.none))
                }

                // Testy
                detailRow(title: L10n.CycleDetail.lhTest, value: Text(entry.lhTest.localizationKey))
                if let prog = entry.progesteroneTestPositive {
                    detailRow(title: "Test PdG", value: Text(prog ? "Pozytywny" : "Negatywny"))
                }

                // Dodatkowe objawy
                if entry.ovulationPainIntensity > 0 {
                    detailRow(title: "Ból owulacyjny",
                              value: Text("\(entry.ovulationPainIntensity)/5 (\(entry.ovulationPainSide.rawValue))"))
                }
                detailRow(title: L10n.CycleDetail.breastTenderness, value: Text("\(entry.breastTenderness)/5"))

                // Współżycie
                if entry.intercourse != .none {
                    detailRow(title: "Współżycie", value: Text(entry.intercourse.localizationKey))
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
