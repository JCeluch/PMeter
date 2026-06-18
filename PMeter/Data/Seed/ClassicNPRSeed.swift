//
//  ClassicNPRSeed.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//
//  Seed demonstracyjny pokazujący „podręcznikowy" wzorzec NPR/FAM:
//  – 10 cykli, ok. 12 miesięcy wstecz
//  – wyraźny wzrost temperatury po owulacji (shift ≥ 0.20°C)
//  – klasyczny wzorzec śluzu: sucho → kleisto → mokro → szczytowy → powrót
//  – kilka cykli z plamieniem owulacyjnym (Mittelschmerz)
//  – jeden cykl bez owulacji (anovulatoryjny, brak skoku temperatury)
//  – jeden cykl z późną owulacją (dzień 20–21, długi cykl 35 dni)
//  – regularny rytm współżycia wokół okna płodnego (NPR abstynencja)
//  – testy LH + progesteronowe w wybranych cyklach
//

import SwiftUI

enum ClassicNPRSeed {

    // MARK: - Public API

    static func makeCycleEntries(
        endingAt endDate: Date = .now,
        calendar: Calendar = .current
    ) -> [CycleEntry] {

        // Scenariusze cykli: (długość, dzień owulacji, typ)
        let cycleScenarios: [(length: Int, ovulationDay: Int, scenario: CycleScenario)] = [
            (28, 14, .classic),          // najnowszy – podręcznikowy
            (26, 13, .classicWithSpot),  // plamienie owulacyjne
            (30, 16, .classic),
            (27, 14, .strongLH),         // wyraźny test LH
            (35, 21, .lateOvulation),    // późna owulacja
            (29, 15, .classicWithSpot),
            (28, 14, .anovulatory),      // brak owulacji – brak skoku
            (27, 13, .classic),
            (30, 15, .strongLH),
            (28, 14, .classic),          // najstarszy
        ]

        var entries: [CycleEntry] = []
        var cycleEndDate = calendar.startOfDay(for: endDate)

        for (index, scenario) in cycleScenarios.enumerated() {
            guard let cycleStart = calendar.date(
                byAdding: .day, value: -(scenario.length - 1), to: cycleEndDate
            ) else { continue }

            let isAnov = scenario.scenario == .anovulatory
            let hasSpot = scenario.scenario == .classicWithSpot
            let hasLH   = scenario.scenario == .strongLH || scenario.scenario == .classic
            let ovDay   = scenario.ovulationDay
            let peakDay = ovDay + 1

            for dayOffset in 0 ..< scenario.length {
                guard let date = calendar.date(
                    byAdding: .day, value: dayOffset, to: cycleStart
                ) else { continue }

                let entry = makeEntry(
                    date: date,
                    cycleDay: dayOffset + 1,
                    cycleLength: scenario.length,
                    ovulationDay: ovDay,
                    peakDay: peakDay,
                    isAnovulatory: isAnov,
                    hasOvulationSpot: hasSpot,
                    hasLHTest: hasLH,
                    cycleIndex: index
                )
                entries.append(entry)
            }

            guard let prev = calendar.date(byAdding: .day, value: -1, to: cycleStart) else { continue }
            cycleEndDate = prev
        }

        return entries.sorted { $0.date < $1.date }
    }

    // MARK: - Scenario enum

    private enum CycleScenario {
        case classic
        case classicWithSpot
        case strongLH
        case lateOvulation
        case anovulatory
    }

    // MARK: - Entry factory

    // swiftlint:disable:next function_body_length
    private static func makeEntry(
        date: Date,
        cycleDay: Int,
        cycleLength: Int,
        ovulationDay: Int,
        peakDay: Int,
        isAnovulatory: Bool,
        hasOvulationSpot: Bool,
        hasLHTest: Bool,
        cycleIndex: Int
    ) -> CycleEntry {

        // MARK: Krwawienie
        let bleedingDays = cycleLength >= 33 ? 6 : 5

        let bleeding: BleedingLevel = switch cycleDay {
        case 1:        .heavy
        case 2:        .heavy
        case 3:        .medium
        case 4:        .light
        case 5 where bleedingDays >= 5: .spotting
        case 6 where bleedingDays >= 6: .spotting
        default:       .none
        }

        let bleedingColor: BleedingColor = switch cycleDay {
        case 1 ... 3:                         .red
        case 4 where bleeding != .none:       .pink
        case 5 ... 6 where bleeding != .none: .brown
        default:                              .none
        }

        let menstrualPain: Int = switch cycleDay {
        case 1: [3, 4, 4, 5].randomElement()!
        case 2: [2, 3, 3].randomElement()!
        case 3: [1, 1, 2].randomElement()!
        default: 0
        }

        let intermenstrualSpotting = hasOvulationSpot && (cycleDay == ovulationDay + 1)

        // MARK: Śluz (wzorzec NPR podręcznikowy)
        let stickyStart  = bleedingDays + 2
        let fertileStart = ovulationDay - 5
        let creamy       = ovulationDay - 3

        let mucusSensation: MucusSensation
        let mucusAppearance: MucusAppearance
        let mucusStretch: MucusStretch
        let mucusVolume: MucusVolume

        switch cycleDay {
        case 1 ... (bleedingDays + 1):
            mucusSensation  = .dry; mucusAppearance = .absent
            mucusStretch    = .absent; mucusVolume = .absent
        case (bleedingDays + 2) ..< stickyStart:
            mucusSensation  = .dry; mucusAppearance = .absent
            mucusStretch    = .absent; mucusVolume = .absent
        case stickyStart ..< fertileStart:
            mucusSensation  = [.dry, .damp].randomElement()!
            mucusAppearance = [.cloudy, .cloudy, .absent].randomElement()!
            mucusStretch    = .absent; mucusVolume = [.scant, .absent].randomElement()!
        case fertileStart ..< creamy:
            mucusSensation  = .damp; mucusAppearance = .cloudy
            mucusStretch    = [.absent, .slight].randomElement()!; mucusVolume = .scant
        case creamy ..< (ovulationDay - 1):
            mucusSensation  = .wet; mucusAppearance = .mixed
            mucusStretch    = .moderate; mucusVolume = .moderate
        case (ovulationDay - 1) ... peakDay:
            mucusSensation  = .slippery; mucusAppearance = .eggWhite
            mucusStretch    = .stretchy; mucusVolume = .abundant
        case (peakDay + 1) ... (peakDay + 3):
            mucusSensation  = [.damp, .wet].randomElement()!
            mucusAppearance = [.cloudy, .mixed].randomElement()!
            mucusStretch    = [.absent, .slight].randomElement()!
            mucusVolume     = [.scant, .moderate].randomElement()!
        default:
            mucusSensation  = [.dry, .dry, .damp].randomElement()!
            mucusAppearance = [.absent, .cloudy].randomElement()!
            mucusStretch    = .absent; mucusVolume = [.absent, .scant].randomElement()!
        }

        let isPeakDay = !isAnovulatory && (cycleDay == peakDay)

        // MARK: Temperatura BBT
        let skipTemp = cycleDay % 9 == 0 && Bool.random()
        let temp: Double? = skipTemp ? nil : (
            isAnovulatory
                ? makeAnovTemp(cycleDay: cycleDay, cycleLength: cycleLength)
                : makeNPRTemp(cycleDay: cycleDay, ovulationDay: ovulationDay)
        )

        var disturbances: [BBTDisturbance] = []
        if temp != nil && Int.random(in: 0 ..< 8) == 0 {
            disturbances = [[.shortSleep], [.alcohol], [.stress]].randomElement()!
        }
        let tempExcluded = !disturbances.isEmpty && Bool.random()
        let measurementOffset = [-4, -2, 0, 0, 0, 3, 6].randomElement()!
        let measurementTime: Date? = temp != nil
            ? Calendar.current.date(bySettingHour: 6, minute: 30 + measurementOffset, second: 0, of: date)
            : nil

        // MARK: Szyjka macicy
        let cervixPosition: CervixPosition
        let cervixFirmness: CervixFirmness
        let cervixOpening: CervixOpening

        switch cycleDay {
        case 1 ..< fertileStart:
            cervixPosition = .low; cervixFirmness = .firm; cervixOpening = .closed
        case fertileStart ..< ovulationDay:
            cervixPosition = [.low, .medium].randomElement()!
            cervixFirmness = [.firm, .medium].randomElement()!
            cervixOpening  = [.closed, .slightlyOpen].randomElement()!
        case ovulationDay ... peakDay:
            cervixPosition = .high; cervixFirmness = .soft; cervixOpening = .open
        case (peakDay + 1) ... (peakDay + 2):
            cervixPosition = .medium; cervixFirmness = [.medium, .soft].randomElement()!
            cervixOpening  = .slightlyOpen
        default:
            cervixPosition = .low; cervixFirmness = .firm; cervixOpening = .closed
        }

        // MARK: Testy LH
        let lhTest: LHTestResult
        if hasLHTest && !isAnovulatory {
            lhTest = switch cycleDay {
            case (ovulationDay - 3): .negative
            case (ovulationDay - 2): .negative
            case (ovulationDay - 1): .positive
            case ovulationDay:       .peak
            default:                 .none
            }
        } else {
            lhTest = .none
        }

        let progDay = peakDay + 7
        let progesteroneTest: Bool? = (!isAnovulatory && cycleDay == progDay) ? true : nil

        // MARK: Ból owulacyjny
        let ovulationPainIntensity: Int = (!isAnovulatory && cycleDay == ovulationDay)
            ? [1, 2, 2, 3, 3].randomElement()! : 0
        let ovulationPainSide: PainSide = ovulationPainIntensity > 0
            ? [.left, .right, .right, .left].randomElement()! : .none

        // MARK: Tkliwość piersi + nastrój
        let breastStart = max(peakDay + 4, cycleLength - 8)
        let breastTenderness: Int = switch cycleDay {
        case breastStart ..< (cycleLength - 2): [1, 1, 2].randomElement()!
        case (cycleLength - 2) ... cycleLength: [2, 2, 3].randomElement()!
        default: 0
        }
        let mood: Int = switch cycleDay {
        case 1 ... 3:                     [2, 3].randomElement()!
        case 6 ... (ovulationDay + 2):    [4, 5, 4].randomElement()!
        case breastStart ... cycleLength: [2, 2, 3].randomElement()!
        default:                          [3, 4].randomElement()!
        }

        // MARK: Współżycie (NPR – abstynencja w oknie płodnym)
        let intercourse: IntercourseType
        if (ovulationDay - 1) ... (ovulationDay + 1) ~= cycleDay && !isAnovulatory {
            intercourse = [.protected, .none, .none].randomElement()!
        } else if (peakDay + 4) ... cycleLength ~= cycleDay {
            intercourse = [.unprotected, .unprotected, .none].randomElement()!
        } else if cycleDay % 5 == 0 && bleeding == .none {
            intercourse = [.unprotected, .none].randomElement()!
        } else {
            intercourse = .none
        }

        // MARK: Notatki
        var notes = ""
        if cycleDay == 1 { notes = "Początek cyklu" }
        else if isAnovulatory && cycleDay == cycleLength / 2 {
            notes = "Brak objawów płodności – cykl anovulatoryjny?"
        } else if cycleDay == ovulationDay && !isAnovulatory {
            notes = hasOvulationSpot ? "Plamienie śródcykliczne + ból owulacyjny" : "Wyraźny śluz jajowaty"
        } else if cycleDay == peakDay && !isAnovulatory { notes = "Dzień szczytowy" }
        else if cycleDay == progDay && !isAnovulatory   { notes = "Test PdG – pozytywny" }
        else if cycleDay == breastStart && breastTenderness > 0 { notes = "Tkliwość piersi – początek PMS" }

        return CycleEntry(
            date: date,
            bleeding: bleeding,
            bleedingColor: bleedingColor,
            intermenstrualSpotting: intermenstrualSpotting,
            mucusSensation: mucusSensation,
            mucusAppearance: mucusAppearance,
            mucusStretch: mucusStretch,
            mucusVolume: mucusVolume,
            isPeakDay: isPeakDay,
            temperature: temp,
            temperatureMeasurementTime: measurementTime,
            temperatureSite: .oral,
            bbtDisturbances: disturbances,
            temperatureExcluded: tempExcluded,
            cervixPosition: cervixPosition,
            cervixFirmness: cervixFirmness,
            cervixOpening: cervixOpening,
            lhTest: lhTest,
            progesteroneTestPositive: progesteroneTest,
            ovulationPainIntensity: ovulationPainIntensity,
            ovulationPainSide: ovulationPainSide,
            breastTenderness: breastTenderness,
            menstrualPainIntensity: menstrualPain,
            intercourse: intercourse,
            mood: mood,
            notes: notes
        )
    }

    // MARK: - Temperatury

    /// Klasyczny NPR: wyraźny skok ≥ 0.20°C po owulacji, nadir w dniu O.
    private static func makeNPRTemp(cycleDay: Int, ovulationDay: Int) -> Double {
        let noise: Double = [-0.04, -0.03, -0.02, 0.00, 0.00, 0.01, 0.02, 0.03, 0.04].randomElement()!
        if cycleDay <= ovulationDay {
            let nadir: Double = cycleDay == ovulationDay ? -0.06 : 0
            return (36.40 + nadir + noise).rounded(toPlaces: 2)
        } else {
            let dayAfter  = Double(cycleDay - ovulationDay)
            let risePhase = min(dayAfter * 0.04, 0.22)
            return (36.62 + risePhase + noise * 0.5).rounded(toPlaces: 2)
        }
    }

    /// Cykl anovulatoryjny: temperatura dryfuje bez wyraźnego wzorca.
    private static func makeAnovTemp(cycleDay: Int, cycleLength: Int) -> Double {
        let noise: Double = [-0.06, -0.04, -0.02, 0.00, 0.02, 0.04, 0.06].randomElement()!
        let drift = sin(Double(cycleDay) / Double(cycleLength) * .pi) * 0.05
        return (36.42 + drift + noise).rounded(toPlaces: 2)
    }
}

// MARK: - Double helper
private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
