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
        let bleeding: BleedingLevel = switch cycleDay {
        case 1...2: .heavy
        case 3: .medium
        case 4: .light
        case 5: .spotting
        default: .none
        }

        let mucus: MucusObservation = switch cycleDay {
        case 1...6: .dry
        case 7...9: .sticky
        case 10...12: .creamy
        case 13...14: .watery
        case 15...16: .eggWhite
        default: .dry
        }

        let mucusAmount: Int = switch cycleDay {
        case 10...12: 1
        case 13...14: 2
        case 15...16: 3
        default: 0
        }

        let lhTest: LHTestResult = switch cycleDay {
        case 14: .positive
        case 15: .peak
        default: .none
        }

        let cervix: CervixObservation = switch cycleDay {
        case 1...9: .lowFirmClosed
        case 10...13: .medium
        case 14...16: .highSoftOpen
        default: .lowFirmClosed
        }

        let temperature = makeTemperature(cycleDay: cycleDay)
        let finalTemperature = [6, 19].contains(cycleDay) ? nil : temperature

        let intercourse = [11, 14, 16].contains(cycleDay)
        let breastTenderness = cycleDay >= max(cycleLength - 5, 22) ? 2 : 0

        let notes: String = switch cycleDay {
        case 1: "Początek cyklu"
        case 14: "Wyraźny wzrost objawów płodności"
        case 22: "Delikatna tkliwość piersi"
        default: ""
        }

        return CycleEntry(
            date: date,
            bleeding: bleeding,
            mucus: mucus,
            lhTest: lhTest,
            cervix: cervix,
            mucusAmount: mucusAmount,
            breastTenderness: breastTenderness,
            temperature: finalTemperature,
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
