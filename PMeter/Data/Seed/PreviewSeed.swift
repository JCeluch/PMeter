//
//  PreviewSeed.swift
//  PMeter
//
//  Created by JCeluch on 12/06/2026.
//

import Foundation

enum PreviewSeed {
    static func makeCycleEntries(
        endingAt endDate: Date = .now,
        calendar: Calendar = .current
    ) -> [CycleEntry] {
        let cycleLengths = [28, 30, 27, 29]
        var entries: [CycleEntry] = []

        var cycleEndDate = calendar.startOfDay(for: endDate)

        for cycleLength in cycleLengths.reversed() {
            guard let cycleStart = calendar.date(byAdding: .day, value: -(cycleLength - 1), to: cycleEndDate) else {
                continue
            }

            for dayOffset in 0..<cycleLength {
                guard let date = calendar.date(byAdding: .day, value: dayOffset, to: cycleStart) else {
                    continue
                }

                let cycleDay = dayOffset + 1
                entries.append(
                    makeEntry(
                        date: date,
                        cycleDay: cycleDay,
                        cycleLength: cycleLength
                    )
                )
            }

            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cycleStart) else {
                continue
            }
            cycleEndDate = previousDay
        }

        return entries.sorted { $0.date < $1.date }
    }

    private static func makeEntry(
        date: Date,
        cycleDay: Int,
        cycleLength: Int
    ) -> CycleEntry {
        
        // Krwawienie
        let bleeding: BleedingLevel = switch cycleDay {
        case 1...2: .heavy
        case 3:     .medium
        case 4:     .light
        case 5:     .spotting
        default:    .none
        }

        // Śluz – 4 wymiary
        let mucusSensation: MucusSensation = switch cycleDay {
        case 1...6:     .dry
        case 7...9:     .damp
        case 10...12:   .wet
        case 13...14:   .wet
        case 15...16:   .slippery
        default:        .dry
        }

        let mucusAppearance: MucusAppearance = switch cycleDay {
        case 1...6:     .absent
        case 7...9:     .cloudy
        case 10...12:   .mixed
        case 13...14:   .clear
        case 15...16:   .eggWhite
        default:        .absent
        }
        
        let mucusStretch: MucusStretch = switch cycleDay {
        case 1...9:   .absent
        case 10...12: .slight
        case 13...14: .moderate
        case 15...16: .stretchy
        default:      .absent
        }

        let mucusVolume: MucusVolume = switch cycleDay {
        case 1...6:   .absent
        case 7...9:   .scant
        case 10...12: .scant
        case 13...14: .moderate
        case 15...16: .abundant
        default:      .absent
        }

        let isPeakDay = cycleDay == 16
        
        // Szyjka macicy - 3 wymiary SHOW
        let cervixPosition: CervixPosition = switch cycleDay {
        case 1...9:   .low
        case 10...13: .medium
        case 14...16: .high
        default:      .low
        }

        let cervixFirmness: CervixFirmness = switch cycleDay {
        case 1...9:   .firm
        case 10...13: .medium
        case 14...16: .soft
        default:      .firm
        }

        let cervixOpening: CervixOpening = switch cycleDay {
        case 1...9:   .closed
        case 10...13: .slightlyOpen
        case 14...16: .open
        default:      .closed
        }

        // Testy
        let lhTest: LHTestResult = switch cycleDay {
        case 14: .positive
        case 15: .peak
        default: .none
        }
        
        // Temperatura
        let rawTemp = makeTemperature(cycleDay: cycleDay)
        let finalTemp: Double? = [6, 19].contains(cycleDay) ? nil : rawTemp

        // Objawy
        let breastTenderness = cycleDay >= max(cycleLength - 5, 22) ? 2 : 0
        let ovulationPainIntensity = [14, 15].contains(cycleDay) ? 2 : 0
        let ovulationPainSide: PainSide = cycleDay == 14 ? .right : .none

        // Współżycie
        let intercourse: IntercourseType = [11, 14, 16].contains(cycleDay) ? .unprotected : .none

        // Notatki
        let notes: String = switch cycleDay {
        case 1: "Początek cyklu"
        case 14: "Wyraźny wzrost objawów płodności"
        case 22: "Delikatna tkliwość piersi"
        default: ""
        }

        return CycleEntry(
            date: date,
            bleeding: bleeding,
            mucusSensation: mucusSensation,
            mucusAppearance: mucusAppearance,
            mucusStretch: mucusStretch,
            mucusVolume: mucusVolume,
            isPeakDay: isPeakDay,
            temperature: finalTemp,
            cervixPosition: cervixPosition,
            cervixFirmness: cervixFirmness,
            cervixOpening: cervixOpening,
            lhTest: lhTest,
            ovulationPainIntensity: ovulationPainIntensity,
            ovulationPainSide: ovulationPainSide,
            breastTenderness: breastTenderness,
            intercourse: intercourse,
            notes: notes
        )
    }

    private static func makeTemperature(cycleDay: Int) -> Double {
        let preOvulation: [Double] = [
            36.42, 36.38, 36.44, 36.40, 36.36, 36.41, 36.39,
            36.43, 36.45, 36.37, 36.40, 36.46, 36.48, 36.47
        ]

        let postOvulation: [Double] = [
            36.62, 36.66, 36.70, 36.68, 36.72, 36.69, 36.73,
            36.71, 36.74, 36.76, 36.72, 36.70, 36.68, 36.67
        ]

        if cycleDay <= 14 {
            return preOvulation[min(cycleDay - 1, preOvulation.count - 1)]
        } else {
            return postOvulation[min(cycleDay - 15, postOvulation.count - 1)]
        }
    }
}
