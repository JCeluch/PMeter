//
//  DayDetailSheetView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI

struct DayDetailSheetView: View {
    let date: Date
    let entries: [CycleEntry]

    var entriesForDay: [CycleEntry] {
        entries
            .filter { CalendarHelper.isSameDay($0.date, date) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.Calendar.daySection) {
                    row(
                        L10n.Calendar.dayLabel,
                        Text(date.formatted(date: .long, time: .omitted))
                    )

                    if let cycleDay = CalendarHelper.cycleDay(for: date, entries: entries) {
                        row(
                            L10n.Calendar.cycleDay,
                            Text("\(cycleDay)")
                        )
                    } else {
                        row(
                            L10n.Calendar.cycleDay,
                            Text(L10n.Calendar.noData)
                        )
                    }
                }

                Section(L10n.Calendar.entries) {
                    if entriesForDay.isEmpty {
                        Text(L10n.Calendar.noEntriesForDay)
                            .foregroundStyle(Color.pmTextSecondary)
                    } else {
                        ForEach(entriesForDay) { entry in
                            VStack(alignment: .leading, spacing: 8) {
                                // Krwawienie jako nagłówek kafelka
                                HStack {
                                    Text(entry.bleeding.localizationKey)
                                        .font(.headline)
                                        .foregroundStyle(entry.bleeding != .none ? Color.red : Color.pmTextPrimary)
                                    if entry.intermenstrualSpotting {
                                        Text("· plamienie")
                                            .font(.caption)
                                            .foregroundStyle(Color.orange)
                                    }
                                    if entry.isPeakDay {
                                        Text("· PEAK")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(Color.pmPrimary)
                                    }
                                }

                                // Śluz
                                if entry.mucusSensation != .none {
                                    detailLine(label: "Śluz") {
                                        Text("\(entry.mucusSensation.localizationKey) · \(entry.mucusAppearance.localizationKey)")
                                    }
                                }

                                // Szyjka
                                if entry.cervixPosition != .none {
                                    detailLine(label: "Szyjka") {
                                        Text("\(entry.cervixPosition.localizationKey) · \(entry.cervixFirmness.localizationKey) · \(entry.cervixOpening.localizationKey)")
                                    }
                                }

                                // Temperatura
                                if let temperature = entry.temperature {
                                    detailLine(label: L10n.CycleDetail.temperature) {
                                        HStack(spacing: 4) {
                                            Text("\(temperature.formatted(.number.precision(.fractionLength(2))))°C")
                                            if entry.temperatureExcluded {
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundStyle(.orange)
                                                    .font(.caption2)
                                            }
                                        }
                                    }
                                }

                                // Testy
                                if entry.lhTest != .none {
                                    detailLine(label: L10n.CycleDetail.lhTest) {
                                        Text(entry.lhTest.localizationKey)
                                    }
                                }
                                if let prog = entry.progesteroneTestPositive {
                                    detailLine(label: "PdG") {
                                        Text(prog ? "✓" : "✗")
                                    }
                                }

                                // Współżycie
                                if entry.intercourse != .none {
                                    detailLine(label: "Współżycie") {
                                        Text(entry.intercourse.localizationKey)
                                    }
                                }

                                // Notatki
                                if !entry.notes.isEmpty {
                                    Text(entry.notes)
                                        .font(.footnote)
                                        .foregroundStyle(Color.pmTextSecondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle(L10n.Calendar.detailsTitle)
        }
    }

    private func row(
        _ title: LocalizedStringKey,
        _ value: Text
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
    
    private func detailLine<Value: View>(
        label: LocalizedStringKey,
        @ViewBuilder value: () -> Value
    ) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .foregroundStyle(Color.pmTextSecondary)

            value()
                .foregroundStyle(Color.pmTextSecondary)
        }
        .font(.subheadline)
    }
}

//#Preview {
//    DayDetailSheetView(date: .now, entries: [])
//}
