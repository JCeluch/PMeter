//
//  StatsView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]
    @State private var vm = StatsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
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
                            if stats.cycleLengthTrend != .insufficient {
                                statRow("Trend długości", value: cycleTrendLabel(stats.cycleLengthTrend, slope: stats.cycleLengthTrendSlope))
                            }
                            if let current = stats.currentCycleDayCount {
                                HStack {
                                    Text("Aktualny cykl")
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Text("dzień \(current)")
                                            .foregroundStyle(stats.currentCycleIsLate ? .orange : .secondary)
                                        if stats.currentCycleIsLate {
                                            Image(systemName: "clock.badge.exclamationmark")
                                                .foregroundStyle(.orange)
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                        }

                        Section {
                            predictionRow(
                                "Następna miesiączka",
                                date: stats.predictedNextPeriodStart,
                                glossaryID: "menstruation"
                            )
                            // Przedział ufności
                            if let earliest = stats.predictedNextPeriodEarliest,
                               let latest = stats.predictedNextPeriodLatest,
                               stats.cycleVariability > 1 {
                                HStack {
                                    Text("Zakres (±\(Int(round(stats.cycleVariability))) dni)")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(earliest.formatted(.dateTime.day().month())) – \(latest.formatted(.dateTime.day().month(.wide).year()))")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                }
                            }
                            predictionRow(
                                "Szacowana owulacja",
                                date: stats.predictedOvulationDate,
                                glossaryID: "menstruation"
                            )
                            statRow("Okno płodne", value: formattedRange(
                                stats.predictedFertileWindowStart,
                                stats.predictedFertileWindowEnd
                            ))
                        } header: {
                            Text("Przewidywania")
                                .glossaryInfo("fertile-window")
                        }

                        Section {
    //                        statRow("Pomiarów temperatury", value: "\(stats.temperatureEntryCount)")
    //                        statRow("Średnia temperatura", value: temperature(stats.averageTemperature))
                            statRow("LH peak", value: "\(stats.lhPeakCount)")
                            if let lhDay = stats.averageLHPeakDayOfCycle {
                                statRow("Średni dzień LH peak", value: "dzień \(Int(round(lhDay)))")
                            }
                            if let mucusDay = stats.averageFirstFertileMucusDayOfCycle {
                                statRow("Śluz płodny od dnia", value: "dzień \(Int(round(mucusDay)))")
                            }
                            if let color = stats.dominantBleedingColor {
                                statRow("Najczęstszy kolor krwawienia", value: bleedingColorLabel(color))
                            }
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
                        
                        // Konsekwencja pomiaru
                        if stats.temperatureEntryCount > 0 {
                            Section {
                                let pct = Int(round(stats.bbtConsistency * 100))
                                HStack {
                                    Text("Regularność pomiarów")
                                    Spacer()
                                    Text("\(pct)%")
                                        .foregroundStyle(bbtConsistencyColor(stats.bbtConsistency))
                                        .fontWeight(.medium)
                                }
                                if stats.averageFollicularLength > 0 {
                                    statRow(
                                        "Średnia faza folikularna",
                                        value: rangeRow(avg: stats.averageFollicularLength,
                                                        min: stats.minFollicularLength,
                                                        max: stats.maxFollicularLength)
                                    )
                                }
                            } header: {
                                Text("BBT i fazy")
                                    .glossaryInfo("bbt")
                            }
                        }
                        
                        // Energia per faza
                        if stats.averageEnergyFollicular != nil || stats.averageEnergyLuteal != nil {
                            Section("Energia wg fazy") {
                                moodPhaseRow("Menstruacyjna", value: stats.averageEnergyMenstrual)
                                moodPhaseRow("Folikularna", value: stats.averageEnergyFollicular)
                                moodPhaseRow("Lutealna", value: stats.averageEnergyLuteal)
                            }
                        }

                        // Sen per faza
                        if stats.averageSleepQualityFollicular != nil || stats.averageSleepQualityLuteal != nil {
                            Section("Jakość snu wg fazy") {
                                moodPhaseRow("Folikularna", value: stats.averageSleepQualityFollicular)
                                moodPhaseRow("Lutealna", value: stats.averageSleepQualityLuteal)
                            }
                        }

                        // Ból głowy
                        if stats.headacheDaysCount > 0 {
                            Section("Ból głowy") {
                                statRow("Dni z bólem głowy", value: "\(stats.headacheDaysCount)")
                                if stats.averageHeadacheIntensity > 0 {
                                    statRow("Średnia intensywność", value: painLabel(stats.averageHeadacheIntensity))
                                }
                            }
                        }

                        // Skóra
                        if let skin = stats.dominantSkinConditionLuteal {
                            Section("Skóra (faza lutealna)") {
                                statRow("Najczęstszy stan", value: skinConditionLabel(skin))
                            }
                        }

                        // Waga
                        if stats.weightEntryCount > 0 {
                            Section("Waga") {
                                if let avg = stats.averageWeight {
                                    statRow("Średnia", value: String(format: "%.1f kg", avg))
                                }
                                if let min = stats.minWeight, let max = stats.maxWeight, min != max {
                                    statRow("Zakres", value: String(format: "%.1f – %.1f kg", min, max))
                                }
                                statRow("Liczba pomiarów", value: "\(stats.weightEntryCount)")
                            }
                        }

                        // Ból menstruacyjny
                        if stats.averageMenstrualPain > 0 {
                            Section("Ból menstruacyjny") {
                                statRow("Średnia intensywność", value: painLabel(stats.averageMenstrualPain))
                                if let max = stats.maxMenstrualPain {
                                    statRow("Maksimum", value: painLabel(Double(max)))
                                }
                            }
                        }

                        // Nastrój per faza
                        if stats.averageMoodFollicular != nil || stats.averageMoodLuteal != nil {
                            Section("Nastrój wg fazy") {
                                moodPhaseRow("Menstruacyjna", value: stats.averageMoodMenstrual)
                                moodPhaseRow("Folikularna", value: stats.averageMoodFollicular)
                                moodPhaseRow("Owulacyjna", value: stats.averageMoodOvulatory)
                                moodPhaseRow("Lutealna", value: stats.averageMoodLuteal)
                            }
                        }
                        
                        // Ból owulacyjny
                        if stats.averageOvulationPain > 0 {
                            Section("Ból owulacyjny") {
                                statRow("Średnia intensywność", value: painLabel(stats.averageOvulationPain))
                                if let max = stats.maxOvulationPain {
                                    statRow("Maksimum", value: painLabel(Double(max)))
                                }
                                if let side = stats.dominantOvulationPainSide {
                                    statRow("Najczęstsza strona", value: painSideLabel(side))
                                }
                            }
                        }

                        // Czułość piersi
                        if stats.averageBreastTendernessFollicular != nil || stats.averageBreastTendernessLuteal != nil {
                            Section("Czułość piersi") {
                                if let f = stats.averageBreastTendernessFollicular {
                                    statRow("Faza folikularna", value: painLabel(f))
                                }
                                if let l = stats.averageBreastTendernessLuteal {
                                    statRow("Faza lutealna", value: painLabel(l))
                                }
                            }
                        }

                        // Plamienie
                        if stats.cyclesWithSpotting > 0 {
                            Section("Plamienie międzymiesiączkowe") {
                                statRow("Cykle z plamieniem", value: "\(stats.cyclesWithSpotting) / \(stats.cycleCount)")
                                statRow("Łącznie dni", value: "\(stats.spotting)")
                            }
                        }

                        // Test progesteron
                        if stats.cyclesWithProgesteroneTest > 0 {
                            Section {
                                statRow("Cykle z testem", value: "\(stats.cyclesWithProgesteroneTest)")
                                statRow("Potwierdzony wyrzut", value: "\(stats.cyclesWithConfirmedProgesterone) / \(stats.cyclesWithProgesteroneTest)")
                                let pct = Int(round(Double(stats.cyclesWithConfirmedProgesterone) / Double(stats.cyclesWithProgesteroneTest) * 100))
                                statRow("Skuteczność", value: "\(pct)%")
                            } header: {
                                Text("Progesteron (Proov/PdG)")
                                    .glossaryInfo("luteal-phase")
                            }
                        }

                        // Peak Day
                        if let peakDay = stats.averagePeakDayOfCycle {
                            Section {
                                statRow("Średni dzień szczytowy", value: "dzień \(Int(round(peakDay)))")
                            } header: {
                                Text("Peak Day")
                                    .glossaryInfo("fertile-window")
                            }
                        }

                        // Szyjka SHOW
                        if stats.showDaysCount > 0 {
                            Section {
                                statRow("Dni z pełnym SHOW", value: "\(stats.showDaysCount)")
                                let pct = Int(round(stats.showPercentage * 100))
                                statRow("% dni z obserwacją", value: "\(pct)%")
                            } header: {
                                Text("Szyjka macicy")
                                    .glossaryInfo("cervix")
                            }
                        }

                        // Streak BBT
                        if stats.longestBBTStreak > 0 {
                            Section {
                                statRow("Najdłuższa seria pomiarów", value: "\(stats.longestBBTStreak) dni")
                            } header: {
                                Text("Konsekwencja BBT")
                                    .glossaryInfo("bbt")
                            }
                        }

                        // Karmienie piersią
                        if stats.breastfeedingDaysCount > 0 {
                            Section("Karmienie piersią") {
                                statRow("Dni z karmieniem", value: "\(stats.breastfeedingDaysCount)")
                            }
                        }

                        if stats.intercourseCount > 0 {
                            Section("Stosunek") {
                                statRow("Łącznie odnotowanych", value: "\(stats.intercourseCount)")
                                statRow("Bez zabezpieczenia", value: "\(stats.intercourseUnprotectedCount)")
                                statRow("Z zabezpieczeniem", value: "\(stats.intercourseProtectedCount)")
                            }
                        }

                        if !stats.cycleInfos.isEmpty {
                            Section {
                                CycleBarChartView(
                                    cycleInfos: stats.cycleInfos,
                                    average: stats.averageCycleLength
                                )
                                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            } header: {
                                Text("Długość cykli")
                            }

                            Section {
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
                                            .foregroundStyle(lengthColor(info.length, average: stats.averageCycleLength))
                                    }
                                }
                            } header: {
                                Text("Historia cykli")
                            }
                        }
                }
            }
            .navigationTitle("Statystyki")
        }
        .task(id: entries.count) {
            await vm.update(entries: entries)
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
    
    private func bbtConsistencyColor(_ value: Double) -> Color {
        switch value {
        case 0.8...: return .green
        case 0.5..<0.8: return .orange
        default: return .red
        }
    }

    private func painLabel(_ value: Double) -> String {
        guard value > 0 else { return "—" }
        let stars = String(repeating: "●", count: Int(round(value))) +
                    String(repeating: "○", count: 5 - Int(round(value)))
        return "\(stars) (\(String(format: "%.1f", value))/5)"
    }

    private func moodPhaseRow(_ phase: String, value: Double?) -> some View {
        HStack {
            Text(phase)
            Spacer()
            if let v = value {
                HStack(spacing: 2) {
                    Text(moodEmoji(v))
                    Text(String(format: "%.1f", v))
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            } else {
                Text("—").foregroundStyle(.secondary)
            }
        }
    }

    private func moodEmoji(_ value: Double) -> String {
        switch value {
        case 4.5...: return "😄"
        case 3.5..<4.5: return "🙂"
        case 2.5..<3.5: return "😐"
        case 1.5..<2.5: return "😕"
        default: return "😔"
        }
    }
    
    private func lengthColor(_ length: Int, average: Double) -> Color {
        let diff = abs(Double(length) - average)
        if diff <= 2 { return .secondary }
        if diff <= 5 { return .orange }
        return .red
    }
    
    private func painSideLabel(_ side: PainSide) -> String {
        switch side {
        case .none: return "—"
        case .left: return "Lewa"
        case .right: return "Prawa"
        case .both: return "Obie strony"
        }
    }
    
    private func cycleTrendLabel(_ trend: CycleLengthTrend, slope: Double) -> String {
        let slopeStr = String(format: "%.1f", abs(slope))
        switch trend {
        case .increasing: return "↗ Wydłużają się (+\(slopeStr) dni/cykl)"
        case .decreasing: return "↘ Skracają się (-\(slopeStr) dni/cykl)"
        case .stable:     return "→ Stabilne"
        case .insufficient: return "—"
        }
    }

    private func bleedingColorLabel(_ color: BleedingColor) -> String {
        switch color {
        case .none:        return "—"
        case .red:   return "Czerwony"
        case .brown:       return "Brązowy"
        case .pink:        return "Różowy"
        case .black:       return "Czarny"
        }
    }
    
    private func skinConditionLabel(_ value: Int) -> String {
        switch value {
        case 1: return "Czysta"
        case 2: return "Lekkie przetłuszczenie"
        case 3: return "Pryszcze / trądzik"
        default: return "—"
        }
    }
}
