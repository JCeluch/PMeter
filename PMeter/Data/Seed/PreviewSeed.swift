//
//  PreviewSeed.swift
//  PMeter
//
//  Created by JCeluch on 12/06/2026.
//

import Foundation

// MARK: - PreviewSeed

enum PreviewSeed {

    // MARK: - Public API

    static func makeCycleEntries(
        endingAt endDate: Date = .now,
        calendar: Calendar = .current
    ) -> [CycleEntry] {

        // 8 cykli z lekkimi wahaniami (+/- 2 dni) wokół bazowych długości
        // Trend: cykl nieco skracał się od lewa (9 mies. temu) do prawej
        let baseLengths: [Int] = [31, 29, 32, 28, 30, 27, 29, 28]

        var entries: [CycleEntry] = []
        var cycleEndDate = calendar.startOfDay(for: endDate)

        for (index, baseLength) in baseLengths.reversed().enumerated() {
            // lekki jitter ±1
            let jitter = [-1, 0, 0, 1].randomElement()!
            let cycleLength = max(24, min(35, baseLength + jitter))

            // owulacja ok. dnia 14–16, lekki jitter ±1 per cykl
            let ovulationDay = 15 + [-1, 0, 0, 1].randomElement()!

            guard let cycleStart = calendar.date(byAdding: .day, value: -(cycleLength - 1), to: cycleEndDate) else {
                continue
            }

            // Losowa strona bólu owulacyjnego (zmienna między cyklami)
            let ovulationSide: PainSide = [.left, .right, .right, .left, .none].randomElement()!

            // Losowy dzień plamienia śródcyklicznego (lub brak)
            let spotDay: Int? = Bool.random() ? nil : ovulationDay + [1, 2].randomElement()!

            for dayOffset in 0 ..< cycleLength {
                guard let date = calendar.date(byAdding: .day, value: dayOffset, to: cycleStart) else {
                    continue
                }
                let cycleDay = dayOffset + 1
                let entry = makeEntry(
                    date: date,
                    cycleDay: cycleDay,
                    cycleLength: cycleLength,
                    ovulationDay: ovulationDay,
                    ovulationSide: ovulationSide,
                    spotDay: spotDay,
                    cycleIndex: index   // starsze cykle → index wyższy
                )
                entries.append(entry)
            }

            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cycleStart) else {
                continue
            }
            cycleEndDate = previousDay
        }

        return entries.sorted { $0.date < $1.date }
    }

    // MARK: - Entry factory

    private static func makeEntry(
        date: Date,
        cycleDay: Int,
        cycleLength: Int,
        ovulationDay: Int,
        ovulationSide: PainSide,
        spotDay: Int?,
        cycleIndex: Int             // 0 = najnowszy cykl
    ) -> CycleEntry {

        let bleedingEnd = 4 + (cycleIndex % 2)   // 4 lub 5 dni krwawienia

        // MARK: Krwawienie
        let bleeding: BleedingLevel = switch cycleDay {
        case 1:              .heavy
        case 2:              .heavy
        case 3:              .medium
        case 4:              .light
        case 5 where bleedingEnd >= 5: .spotting
        default:             .none
        }

        // Kolor krwawienia – pierwsze dni czerwone, ostatni brązowawy
        let bleedingColor: BleedingColor = switch cycleDay {
        case 1 ... 3:               .red
        case 4 where bleeding != .none: .pink
        case 5 where bleeding != .none: .brown
        default:                    .none
        }

        // Ból menstruacyjny silniejszy w 1. dniu, stopniowo słabnie
        let menstrualPain: Int = switch cycleDay {
        case 1: [3, 4, 3, 4, 5].randomElement()!
        case 2: [2, 3, 2].randomElement()!
        case 3: [1, 1, 2].randomElement()!
        default: 0
        }

        // Plamienie śródcykliczne
        let intermenstrualSpotting = (cycleDay == spotDay)

        // MARK: Śluz
        // Okno płodne zaczyna się ok. owulationDay - 5
        let fertileWindowStart = ovulationDay - 5
        let peakDay = ovulationDay + 1

        let mucusSensation: MucusSensation
        let mucusAppearance: MucusAppearance
        let mucusStretch: MucusStretch
        let mucusVolume: MucusVolume

        switch cycleDay {
        case 1 ... bleedingEnd:
            mucusSensation = .dry
            mucusAppearance = .absent
            mucusStretch    = .absent
            mucusVolume     = .absent

        case (bleedingEnd + 1) ..< fertileWindowStart:
            mucusSensation = [.dry, .dry, .damp].randomElement()!
            mucusAppearance = [.absent, .cloudy].randomElement()!
            mucusStretch    = .absent
            mucusVolume     = [.absent, .scant].randomElement()!

        case fertileWindowStart ... (ovulationDay - 2):
            mucusSensation = [.damp, .wet].randomElement()!
            mucusAppearance = [.cloudy, .mixed].randomElement()!
            mucusStretch    = [.slight, .moderate].randomElement()!
            mucusVolume     = [.scant, .moderate].randomElement()!

        case (ovulationDay - 1) ... ovulationDay:
            mucusSensation = [.wet, .slippery].randomElement()!
            mucusAppearance = [.clear, .eggWhite].randomElement()!
            mucusStretch    = [.moderate, .stretchy].randomElement()!
            mucusVolume     = [.moderate, .abundant].randomElement()!

        case peakDay:
            mucusSensation = .slippery
            mucusAppearance = .eggWhite
            mucusStretch    = .stretchy
            mucusVolume     = .abundant

        case (peakDay + 1) ... (peakDay + 3):
            // gwałtowny powrót po szczycie
            mucusSensation = [.damp, .wet].randomElement()!
            mucusAppearance = [.mixed, .clear].randomElement()!
            mucusStretch    = [.absent, .slight].randomElement()!
            mucusVolume     = [.scant, .moderate].randomElement()!

        default:
            // faza lutealna
            mucusSensation = [.dry, .dry, .damp].randomElement()!
            mucusAppearance = [.absent, .cloudy].randomElement()!
            mucusStretch    = .absent
            mucusVolume     = [.absent, .scant].randomElement()!
        }

        let isPeakDay = (cycleDay == peakDay)

        // MARK: Szyjka macicy (SHOW)
        let cervixPosition: CervixPosition
        let cervixFirmness: CervixFirmness
        let cervixOpening: CervixOpening

        switch cycleDay {
        case 1 ... (fertileWindowStart - 1):
            cervixPosition = .low
            cervixFirmness = .firm
            cervixOpening  = .closed

        case fertileWindowStart ... (ovulationDay - 1):
            cervixPosition = [.low, .medium].randomElement()!
            cervixFirmness = [.firm, .medium].randomElement()!
            cervixOpening  = [.closed, .slightlyOpen].randomElement()!

        case ovulationDay ... peakDay:
            cervixPosition = .high
            cervixFirmness = .soft
            cervixOpening  = .open

        case (peakDay + 1) ... (peakDay + 2):
            cervixPosition = .medium
            cervixFirmness = [.medium, .soft].randomElement()!
            cervixOpening  = .slightlyOpen

        default:
            cervixPosition = .low
            cervixFirmness = .firm
            cervixOpening  = .closed
        }

        // MARK: Temperatura BBT
        let rawTemp = makeTemperature(cycleDay: cycleDay, ovulationDay: ovulationDay, cycleIndex: cycleIndex)

        // ~10% dni bez pomiaru, losowe
        let skipTemp = (cycleDay % 7 == 3 && cycleIndex % 3 == 0) || (cycleDay % 11 == 0)
        let finalTemp: Double? = skipTemp ? nil : rawTemp

        // Zakłócenia – losowo ~15% dni z pomiarem
        var disturbances: [BBTDisturbance] = []
        if finalTemp != nil && !disturbances.isEmpty { disturbances = [] }
        if finalTemp != nil {
            let roll = Int.random(in: 0 ..< 7)
            if roll == 0 { disturbances = [.shortSleep] }
            else if roll == 1 { disturbances = [.alcohol] }
            else if roll == 2 { disturbances = [.stress] }
        }
        let tempExcluded = !disturbances.isEmpty && Bool.random()

        // Stały czas pomiaru z drobnymi wahaniami ± kilka minut
        let measurementMinuteOffset = [-5, -3, 0, 0, 0, 2, 5].randomElement()!
        let measurementTime: Date? = finalTemp != nil
            ? Calendar.current.date(bySettingHour: 6, minute: 30 + measurementMinuteOffset, second: 0, of: date)
            : nil

        // MARK: Testy LH
        let lhTest: LHTestResult = switch cycleDay {
        case (ovulationDay - 2):         .negative
        case (ovulationDay - 1):         .positive
        case ovulationDay:               .peak
        default:                         .none
        }

        // Test progesteronowy w połowie fazy lutealnej
        let progesteroneDay = peakDay + 7
        let progesteroneTest: Bool? = (cycleDay == progesteroneDay) ? true : nil

        // MARK: Ból owulacyjny
        let ovulationPainIntensity: Int = switch cycleDay {
        case ovulationDay:       [1, 2, 2, 3].randomElement()!
        case (ovulationDay - 1): [0, 1, 1].randomElement()!
        default:                 0
        }
        let ovulationPainSide: PainSide = ovulationPainIntensity > 0 ? ovulationSide : .none

        // MARK: Tkliwość piersi (faza lutealna)
        let breastStart = max(peakDay + 4, cycleLength - 7)
        let breastTenderness: Int = switch cycleDay {
        case breastStart ..< (cycleLength - 2): [1, 1, 2].randomElement()!
        case (cycleLength - 2) ... cycleLength:  [2, 2, 3].randomElement()!
        default:                                 0
        }

        // MARK: Nastrój (faza lutealna → PMS)
        let mood: Int = switch cycleDay {
        case 1 ... 3:                         [2, 3].randomElement()!  // ból → gorszy nastrój
        case 8 ... (ovulationDay + 2):        [4, 5, 4].randomElement()! // dobry nastrój perifoll.
        case breastStart ... cycleLength:     [2, 2, 3].randomElement()! // PMS
        default:                              [3, 4].randomElement()!
        }

        // MARK: Współżycie
        let intercourse: IntercourseType
        if (ovulationDay - 1) ... (ovulationDay + 1) ~= cycleDay {
            intercourse = [.unprotected, .unprotected, .none].randomElement()!
        } else if [cycleDay % 4 == 0, cycleDay % 5 == 0].contains(true) && bleeding == .none {
            intercourse = [.unprotected, .protected, .none].randomElement()!
        } else {
            intercourse = .none
        }

        // MARK: Notatki
        var notes = ""
        if cycleDay == 1 { notes = "Początek cyklu" }
        else if cycleDay == ovulationDay { notes = "Wyraźne objawy płodności" }
        else if cycleDay == peakDay { notes = "Dzień szczytowy" }
        else if cycleDay == progesteroneDay { notes = "Test PdG – pozytywny" }
        else if cycleDay == breastStart && breastTenderness > 0 { notes = "Początek tkliwości piersi" }

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
            temperature: finalTemp,
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
            notes: notes
        )
    }

    // MARK: - Temperatura BBT

    /// Generuje temperaturę z naturalnym szumem ±0.05 i skokiem po owulacji.
    /// Starsze cykle (wyższy index) mają bazę lekko wyższą – symuluje trend.
    private static func makeTemperature(
        cycleDay: Int,
        ovulationDay: Int,
        cycleIndex: Int
    ) -> Double {
        // Starsze cykle → lekko wyższa baza (symuluje długoterminowy trend)
        let trendOffset = Double(cycleIndex) * 0.004

        let preBase  = 36.42 - trendOffset
        let postBase = 36.65 - trendOffset

        // Drobny szum per dzień
        let noise: Double = [
            -0.04, -0.03, -0.02, -0.01, 0.00, 0.01, 0.02, 0.03, 0.04,
            -0.05,  0.05
        ].randomElement()!

        if cycleDay <= ovulationDay {
            // delikatny spadek tuż przed owulacją (nadir)
            let nadir: Double = cycleDay == ovulationDay ? -0.05 : 0
            return (preBase + nadir + noise * 0.8).rounded(toPlaces: 2)
        } else {
            // post-owulacyjny plateau z minimalnym trendem
            let dayAfter = Double(cycleDay - ovulationDay)
            let plateau = min(dayAfter * 0.01, 0.08)  // rośnie przez 1. tydzień
            return (postBase + plateau + noise * 0.6).rounded(toPlaces: 2)
        }
    }
}

// MARK: - Double helpers

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
