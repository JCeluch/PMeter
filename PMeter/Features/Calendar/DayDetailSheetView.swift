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
                                Text(entry.bleeding.localizationKey)
                                    .font(.headline)
                                    .foregroundStyle(Color.pmTextPrimary)

//                                detailLine(label: L10n.CycleDetail.mucus) {
//                                    Text(entry.mucus.localizationKey)
//                                }
                                
//                                detailLine(label: L10n.CycleDetail.mucusAmount) {
//                                    Text("\(entry.mucusAmount)/5")
//                                }
                                
//                                detailLine(label: L10n.CycleDetail.cervix) {
//                                    Text(entry.cervix.localizationKey)
//                                }
                                
                                if entry.lhTest != .none {
                                    detailLine(label: L10n.CycleDetail.lhTest) {
                                        Text(entry.lhTest.localizationKey)
                                    }
                                }

                                if let temperature = entry.temperature {
                                    detailLine(label: L10n.CycleDetail.temperature) {
                                        Text("\(temperature.formatted(.number.precision(.fractionLength(2))))°C")
                                    }
                                }

//                                if entry.intercourse {
//                                    detailLine(label: L10n.CycleDetail.intercourse) {
//                                        Text(L10n.Common.yes)
//                                    }
//                                }

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
