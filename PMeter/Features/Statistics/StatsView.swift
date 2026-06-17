//
//  StatsView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]

    private var stats: CycleStatistics {
        CycleAnalyticsService.statistics(from: entries)
    }

    var body: some View {
        NavigationStack {
            List {
                if stats.cycleCount == 0 {
                    ContentUnavailableView(
                        "Brak danych do analizy",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Dodaj przynajmniej dwa cykle, aby zobaczyć statystyki i przewidywania.")
                    )
                } else {
                    Section("Cykl") {
                        statRow("Liczba pełnych cykli", value: "\(stats.cycleCount)")
                        statRow("Średnia długość cyklu", value: days(stats.averageCycleLength))
                        statRow("Mediana", value: days(stats.medianCycleLength))
                        statRow("Najkrótszy cykl", value: intDays(stats.shortestCycle))
                        statRow("Najdłuższy cykl", value: intDays(stats.longestCycle))
                        statRow("Zmienność", value: formatted(stats.cycleVariability))
                        statRow("Regularność cykli", value: regularityLabel(stats.regularityScore))
                    }

                    Section {
                        predictionRow(
                            "Następna miesiączka",
                            date: stats.predictedNextPeriodStart,
                            glossaryID: "menstruation"
                        )
                        predictionRow(
                            "Szacowana owulacja",
                            date: stats.predictedOvulationDate,
                            glossaryID: "menstruation"
                        )
                        statRow("Okno płodne", value: formattedRange(stats.predictedFertileWindowStart, stats.predictedFertileWindowEnd))
                    } header: {
                        Text("Przewidywania")
                            .glossaryInfo("fertile-window")
                    }

                    Section {
//                        statRow("Pomiarów temperatury", value: "\(stats.temperatureEntryCount)")
//                        statRow("Średnia temperatura", value: temperature(stats.averageTemperature))
                        statRow("LH peak", value: "\(stats.lhPeakCount)")
                    } header: {
                        Text("Obserwacje")
                            .glossaryInfo("lh")
                    }
                    
                    if stats.averageBleedingDays > 0 || stats.averageLutealLength > 0 {
                        Section {
                            if stats.averageBleedingDays > 0 {
                                statRow(
                                    "Średnia długość krwawienia",
                                    value: rangeRow(avg: stats.averageBleedingDays,
                                                    min: stats.minBleedingDays,
                                                    max: stats.maxBleedingDays)
                                )
                            }
                            if stats.averageLutealLength > 0 {
                                statRow(
                                    "Średnia faza lutealna",
                                    value: rangeRow(avg: stats.averageLutealLength,
                                                    min: stats.minLutealLength,
                                                    max: stats.maxLutealLength)
                                )
                            }
                        } header: {
                            Text("Fazy cyklu")
                                .glossaryInfo("luteal-phase")
                        }
                    }

                    Section("Owulacja") {
                        let total = stats.cyclesWithOvulation + stats.cyclesWithoutOvulation
                        if total > 0 {
                            statRow("Z wykrytą owulacją", value: "\(stats.cyclesWithOvulation) / \(total)")
                            if stats.cyclesWithOvulation > 0 {
                                let pct = Int(round(Double(stats.cyclesWithOvulation) / Double(total) * 100))
                                statRow("Skuteczność detekcji", value: "\(pct)%")
                            }
                        } else {
                            statRow("Z wykrytą owulacją", value: "—")
                        }
                    }

                    if stats.bbtTrend != .insufficient {
                        Section {
                            statRow("Trend temperatury bazowej", value: bbtTrendLabel(stats.bbtTrend))
                            statRow("Pomiarów temperatury", value: "\(stats.temperatureEntryCount)")
                            statRow("Średnia temperatura", value: temperature(stats.averageTemperature))
                        } header: {
                            Text("BBT")
                                .glossaryInfo("bbt")
                        }
                    } else {
                        Section {
                            statRow("Pomiarów temperatury", value: "\(stats.temperatureEntryCount)")
                            statRow("Średnia temperatura", value: temperature(stats.averageTemperature))
                        } header: {
                            Text("BBT")
                                .glossaryInfo("bbt")
                        }
                    }

                    if stats.dominantMucusAppearance != nil || stats.dominantMucusSensation != nil {
                        Section {
                            if let appearance = stats.dominantMucusAppearance {
                                statRow("Najczęstszy wygląd śluzu", value: mucusAppearanceLabel(appearance))
                            }
                            if let sensation = stats.dominantMucusSensation {
                                statRow("Najczęstsza konsystencja", value: mucusSensationLabel(sensation))
                            }
                        } header: {
                            Text("Śluz")
                                .glossaryInfo("cervical-mucus")
                        }
                    }

                    if stats.intercourseCount > 0 {
                        Section("Stosunek") {
                            statRow("Łącznie odnotowanych", value: "\(stats.intercourseCount)")
                            statRow("Bez zabezpieczenia", value: "\(stats.intercourseUnprotectedCount)")
                            statRow("Z zabezpieczeniem", value: "\(stats.intercourseProtectedCount)")
                        }
                    }


                    if !stats.cycleLengths.isEmpty {
                        Section("Długości cykli") {
                            ForEach(stats.cycleInfos.reversed(), id: \.startDate) { info in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(cycleRangeLabel(info))
                                            .font(.subheadline)
                                        Text(cycleShortDateRange(info))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(info.length) dni")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Statystyki")
        }
    }

    private func statRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }

    private func formatted(_ value: Double) -> String {
        guard value > 0 else { return "—" }
        return String(format: "%.1f", value)
    }

    private func days(_ value: Double) -> String {
        guard value > 0 else { return "—" }
        return "\(Int(round(value))) dni"
    }

    private func intDays(_ value: Int?) -> String {
        guard let value else { return "—" }
        return "\(value) dni"
    }

    private func temperature(_ value: Double?) -> String {
        guard let value else { return "—" }
        return String(format: "%.2f °C", value)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "—" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func formattedRange(_ start: Date?, _ end: Date?) -> String {
        guard let start, let end else { return "—" }
        return "\(start.formatted(date: .abbreviated, time: .omitted)) – \(end.formatted(date: .abbreviated, time: .omitted))"
    }
    
    private func cycleRangeLabel(_ info: CycleInfo) -> String {
        // numer cyklu liczony od początku – znajdź indeks w oryginalnej kolejności
        if let idx = stats.cycleInfos.firstIndex(where: { $0.startDate == info.startDate }) {
            return "Cykl \(idx + 1)"
        }
        return "Cykl"
    }
    
    private func cycleShortDateRange(_ info: CycleInfo) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let start = formatter.string(from: info.startDate)
        if let end = info.endDate {
            return "\(start) - \(formatter.string(from: end))"
        }
        return start
    }
    
    private func predictionRow(_ title: String, date: Date?, glossaryID: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(formattedDate(date))
                    .foregroundStyle(.secondary)
                if let d = daysFromNow(date) {
                    Text(d)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
    
    private func daysFromNow(_ date: Date?) -> String? {
        guard let date else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: .now), to: date).day ?? 0
        switch days {
        case 0: return "dziś"
        case 1: return "jutro"
        case -1: return "wczoraj"
        case ..<0: return "\(abs(days)) dni temu"
        default: return "za \(days) dni"
        }
    }
    
    private func rangeRow(avg: Double, min: Int?, max: Int?) -> String {
        guard avg > 0 else { return "—" }
        let avgStr = "\(Int(round(avg))) dni"
        if let mn = min, let mx = max, mn != mx {
            return "\(avgStr) (\(mn)–\(mx))"
        }
        return avgStr
    }

    private func regularityLabel(_ score: Double) -> String {
        switch score {
        case 85...: return "Bardzo regularne (\(Int(score))%)"
        case 65..<85: return "Regularne (\(Int(score))%)"
        case 40..<65: return "Umiarkowane (\(Int(score))%)"
        default: return "Nieregularne (\(Int(score))%)"
        }
    }

    private func bbtTrendLabel(_ trend: BBTTrend) -> String {
        switch trend {
        case .rising: return "↗ Rosnący"
        case .falling: return "↘ Malejący"
        case .stable: return "→ Stabilny"
        case .insufficient: return "—"
        }
    }

    private func mucusAppearanceLabel(_ appearance: MucusAppearance) -> String {
        switch appearance {
        case .none, .absent: return "Sucho"
        case .cloudy: return "Mętny"
        case .yellow: return "Żółtawy"
        case .mixed: return "Mieszany"
        case .clear: return "Przezroczysty"
        case .eggWhite: return "Jak białko jaja"
        }
    }

    private func mucusSensationLabel(_ sensation: MucusSensation) -> String {
        switch sensation {
        case .none: return "—"
        case .dry: return "Sucho"
        case .damp: return "Wilgotno"
        case .wet: return "Mokro"
        case .slippery: return "Ślisko"
        }
    }
}
