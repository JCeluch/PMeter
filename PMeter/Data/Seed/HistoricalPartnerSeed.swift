//
//  HistoricalPartnerSeed.swift
//  PMeter
//
//  Created by JCeluch on 16/06/2026.
//
//  Dane historyczne oparte na eksporcie z aplikacji "Mój Kalendarzyk".
//  Zakres: 28.08.2025 – 16.06.2026 (bieżący dzień), 12 cykli.
//  Temperatury dostępne tylko w nowszych cyklach (od ok. marca 2026).
//  Obserwacje śluzu i objawów odtworzone z wykresów siatki PDF.
//

import Foundation

enum HistoricalPartnerSeed {

    static func makeCycleEntries(
        calendar: Calendar = .current
    ) -> [CycleEntry] {

        var entries: [CycleEntry] = []

        for cycle in cycleDefinitions {
            guard let cycleStart = Self.date(cycle.startISO) else { continue }

            for dayOffset in 0 ..< cycle.length {
                guard dayOffset < cycle.length else { break }
                guard let date = calendar.date(byAdding: .day, value: dayOffset, to: cycleStart) else { continue }
                let cycleDay = dayOffset + 1

                // Nie generuj wpisów po dzisiejszej dacie
                guard date <= Date.now else { break }

                let obs = cycle.observations[cycleDay] ?? DayObservation()
                let entry = makeEntry(date: date, cycleDay: cycleDay, obs: obs, bleedingDays: cycle.bleedingDays)
                entries.append(entry)
            }
        }

        return entries.sorted { $0.date < $1.date }
    }

    // MARK: - Entry factory

    private static func makeEntry(
        date: Date,
        cycleDay: Int,
        obs: DayObservation,
        bleedingDays: Int
    ) -> CycleEntry {

        let bleeding: BleedingLevel = switch cycleDay {
        case 1:                           .heavy
        case 2:                           .medium
        case 3 where bleedingDays >= 3:   .light
        case 4 where bleedingDays >= 4:   .light
        case 5 where bleedingDays >= 5:   .spotting
        default:                          .none
        }

        let bleedingColor: BleedingColor = switch cycleDay {
        case 1...2:                            .red
        case 3 where bleeding != .none:        .pink
        case 4... where bleeding != .none:     .brown
        default:                               .none
        }

        return CycleEntry(
            date: date,
            bleeding: bleeding,
            bleedingColor: bleedingColor,
            intermenstrualSpotting: obs.intermenstrualSpotting,
            mucusSensation: obs.mucusSensation,
            mucusAppearance: obs.mucusAppearance,
            mucusStretch: obs.mucusStretch,
            mucusVolume: obs.mucusVolume,
            isPeakDay: obs.isPeakDay,
            temperature: obs.temperature,
            temperatureMeasurementTime: obs.temperature != nil
                ? Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: date)
                : nil,
            temperatureSite: .oral,
            breastTenderness: obs.breastTenderness,
            menstrualPainIntensity: cycleDay <= 2 ? 2 : (cycleDay == 3 ? 1 : 0),
            notes: obs.notes
        )
    }

    // MARK: - Date helper

    private static func date(_ iso: String) -> Date? {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "Europe/Warsaw")
        return f.date(from: iso)
    }

    // MARK: - Observation model

    struct DayObservation {
        var mucusSensation: MucusSensation = .none
        var mucusAppearance: MucusAppearance = .none
        var mucusStretch: MucusStretch = .none
        var mucusVolume: MucusVolume = .none
        var isPeakDay: Bool = false
        var temperature: Double? = nil
        var breastTenderness: Int = 0
        var intermenstrualSpotting: Bool = false
        var notes: String = ""
    }

    // MARK: - Cycle definition

    struct CycleDefinition {
        let startISO: String
        let length: Int
        let bleedingDays: Int
        /// Słownik: klucz = dzień cyklu (1-based), wartość = obserwacje tego dnia
        let observations: [Int: DayObservation]
    }

    // MARK: - Historical data
    // Źródło: eksport PDF "Mój Kalendarzyk", ania029a, wyeksportowany ~16.06.2026
    // Cykle: 28.08.2025 – dzisiaj

    static let cycleDefinitions: [CycleDefinition] = [

        // Cykl 1: 28.08.2025 – 23.09.2025 (27 dni)
        CycleDefinition(startISO: "2025-08-28", length: 27, bleedingDays: 3, observations: [:]),

        // Cykl 2: 24.09.2025 – 19.10.2025 (26 dni)
        CycleDefinition(startISO: "2025-09-24", length: 26, bleedingDays: 3, observations: [:]),

        // Cykl 3: 20.10.2025 – 12.11.2025 (24 dni)
        // Obserwacje z siatki: plamienie dnia 7 i 9, zmęczenie dnia 9
        CycleDefinition(startISO: "2025-10-20", length: 24, bleedingDays: 3, observations: [
            7: DayObservation(intermenstrualSpotting: true),
            9: DayObservation(intermenstrualSpotting: true),
        ]),

        // Cykl 4: 13.11.2025 – 07.12.2025 (25 dni)
        CycleDefinition(startISO: "2025-11-13", length: 25, bleedingDays: 3, observations: [:]),

        // Cykl 5: 08.12.2025 – 04.01.2026 (28 dni)
        CycleDefinition(startISO: "2025-12-08", length: 28, bleedingDays: 3, observations: [:]),

        // Cykl 6: 05.01.2026 – 29.01.2026 (25 dni)
        // Krwawienie "dużo" w dniu 1 (widoczne na siatce)
        CycleDefinition(startISO: "2026-01-05", length: 25, bleedingDays: 3, observations: [:]),

        // Cykl 7: 30.01.2026 – 26.02.2026 (28 dni) — 4 dni krwawienia
        // Obserwacja: nadwrażliwość piersi dnia 19
        CycleDefinition(startISO: "2026-01-30", length: 28, bleedingDays: 4, observations: [
            19: DayObservation(breastTenderness: 2),
        ]),

        // Cykl 8: 27.02.2026 – 26.03.2026 (28 dni)
        // Obserwacja: nadwrażliwość piersi dnia 19
        CycleDefinition(startISO: "2026-02-27", length: 28, bleedingDays: 3, observations: [
            19: DayObservation(breastTenderness: 2),
        ]),

        // Cykl 9: 27.03.2026 – 21.04.2026 (26 dni)
        // Temperatury z wykresu. Owulacja ok. dnia 10 (nadir + skok widoczny)
        // Śluz: białko jajka dnia 10, lepki dnia 26
        // Objawy: jak białko jajka dnia 10, nadwrażliwość piersi dni 15,16,17,21
        CycleDefinition(startISO: "2026-03-27", length: 26, bleedingDays: 3, observations: [
            4:  DayObservation(temperature: 36.52),
            5:  DayObservation(temperature: 36.38),
            6:  DayObservation(temperature: 36.42),
            7:  DayObservation(temperature: 36.40),
            8:  DayObservation(temperature: 36.58),
            9:  DayObservation(temperature: 36.20),
            10: DayObservation(
                    mucusSensation: .slippery,
                    mucusAppearance: .eggWhite,
                    mucusStretch: .stretchy,
                    mucusVolume: .abundant,
                    isPeakDay: true,
                    temperature: 36.00,
                    notes: "Białko jajka, dzień szczytowy"
                ),
            11: DayObservation(temperature: 36.58),
            12: DayObservation(temperature: 36.50),
            13: DayObservation(temperature: 36.60),
            14: DayObservation(temperature: 36.68),
            15: DayObservation(temperature: 36.72, breastTenderness: 1),
            16: DayObservation(temperature: 36.70, breastTenderness: 2),
            17: DayObservation(temperature: 36.96, breastTenderness: 2),
            18: DayObservation(temperature: 37.06),
            19: DayObservation(temperature: 37.00),
            20: DayObservation(temperature: 36.96),
            21: DayObservation(temperature: 36.62, breastTenderness: 1),
            22: DayObservation(temperature: 37.00),
            23: DayObservation(temperature: 36.85),
            24: DayObservation(temperature: 37.02),
            26: DayObservation(mucusSensation: .damp, mucusAppearance: .cloudy),
        ]),

        // Cykl 10: 22.04.2026 – 17.05.2026 (26 dni)
        // Temperatury z wykresu. Owulacja ok. dnia 10 (nadir ok. 9)
        // Śluz: lepki dnia 26
        // Objawy: z krwią dnia 10 (plamienie śródcykliczne), lepki dnia 26
        CycleDefinition(startISO: "2026-04-22", length: 26, bleedingDays: 3, observations: [
            1:  DayObservation(temperature: 36.52),
            4:  DayObservation(temperature: 36.38),
            5:  DayObservation(temperature: 36.42),
            6:  DayObservation(temperature: 36.44),
            7:  DayObservation(temperature: 36.30),
            8:  DayObservation(temperature: 36.58),
            9:  DayObservation(temperature: 36.12),
            10: DayObservation(
                    mucusSensation: .wet,
                    mucusAppearance: .clear,
                    temperature: 36.52,
                    intermenstrualSpotting: true,
                    notes: "Plamienie z krwią"
                ),
            11: DayObservation(temperature: 36.58),
            13: DayObservation(temperature: 36.48),
            14: DayObservation(temperature: 36.60),
            15: DayObservation(temperature: 36.72),
            16: DayObservation(temperature: 36.80),
            17: DayObservation(temperature: 36.88),
            18: DayObservation(temperature: 36.84),
            19: DayObservation(temperature: 36.95),
            20: DayObservation(temperature: 36.82),
            21: DayObservation(temperature: 36.92),
            22: DayObservation(temperature: 36.90),
            23: DayObservation(temperature: 36.88),
            24: DayObservation(temperature: 36.95),
            25: DayObservation(temperature: 36.92),
            26: DayObservation(
                    mucusSensation: .damp,
                    mucusAppearance: .cloudy,
                    temperature: 36.88
                ),
        ]),

        // Cykl 11: 18.05.2026 – 12.06.2026 (26 dni)
        // Temperatury z wykresu widoczne od dnia 1.
        // Owulacja widoczna ok. dnia 8-9 (nadir + skok).
        // Śluz: lepki dnia 26, nadwrażliwość piersi dni 18,21
        CycleDefinition(startISO: "2026-05-18", length: 26, bleedingDays: 3, observations: [
            1:  DayObservation(temperature: 36.05),
            2:  DayObservation(temperature: 36.15),
            4:  DayObservation(temperature: 36.52),
            5:  DayObservation(temperature: 36.60),
            6:  DayObservation(temperature: 36.52),
            7:  DayObservation(temperature: 36.45),
            8:  DayObservation(temperature: 36.32, notes: "Nadir"),
            9:  DayObservation(
                    mucusSensation: .slippery,
                    mucusAppearance: .eggWhite,
                    temperature: 36.55,
                    notes: "Białko jajka"
                ),
            10: DayObservation(temperature: 36.42),
            12: DayObservation(temperature: 36.45),
            13: DayObservation(temperature: 36.50),
            14: DayObservation(temperature: 36.68),
            15: DayObservation(temperature: 36.72),
            16: DayObservation(temperature: 36.72),
            17: DayObservation(temperature: 36.75),
            18: DayObservation(temperature: 36.62, breastTenderness: 1),
            19: DayObservation(temperature: 36.52),
            20: DayObservation(temperature: 36.72),
            21: DayObservation(temperature: 36.70, breastTenderness: 1),
            22: DayObservation(temperature: 36.88),
            23: DayObservation(temperature: 36.80),
            24: DayObservation(temperature: 36.88),
            25: DayObservation(temperature: 36.88),
            26: DayObservation(mucusSensation: .damp, mucusAppearance: .cloudy, temperature: 36.85),
        ]),

        // Cykl 12 (bieżący): 13.06.2026 – dziś (~dzień 4)
        // 5 dni krwawienia wg PDF (aktualny stan na dzień eksportu)
        // Temperatura tylko dnia 1 widoczna na wykresie
        CycleDefinition(startISO: "2026-06-13", length: 27, bleedingDays: 5, observations: [
            1: DayObservation(temperature: 36.48),
        ]),
    ]
}
