//
//  CycleAnalyticsService.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation

enum CycleAnalyticsService {
    static func statistics(from entries: [CycleEntry]) -> CycleStatistics {
        let sortedEntries = entries.sorted { $0.date < $1.date }
        let cycleStarts = CalendarHelper.cycleStartDates(in: sortedEntries).sorted()
        let cycleLengths = calculateCycleLengths(from: cycleStarts)

        let average = average(of: cycleLengths)
        let median = median(of: cycleLengths)
        let shortest = cycleLengths.min()
        let longest = cycleLengths.max()
        let variability = standardDeviation(of: cycleLengths)
        let regularity = regularityScore(for: cycleLengths)

        let predictedNextPeriodStart: Date? = {
            guard !cycleLengths.isEmpty, let lastStart = cycleStarts.last else { return nil }
            return Calendar.current.date(byAdding: .day, value: Int(round(average)), to: lastStart)
        }()

        let estimatedLutealLength = estimatedLutealPhaseLength(from: sortedEntries, cycleStarts: cycleStarts)

        let predictedOvulationDate = predictedNextPeriodStart.flatMap {
            Calendar.current.date(byAdding: .day, value: -estimatedLutealLength, to: $0)
        }

        let fertileWindowStart = predictedOvulationDate.flatMap {
            Calendar.current.date(byAdding: .day, value: -5, to: $0)
        }

        let fertileWindowEnd = predictedOvulationDate.flatMap {
            Calendar.current.date(byAdding: .day, value: 1, to: $0)
        }

        let temperatureValues = sortedEntries.compactMap(\.temperature)
        let averageTemperature = temperatureValues.isEmpty
            ? nil
            : temperatureValues.reduce(0, +) / Double(temperatureValues.count)

        let lhPeakCount = sortedEntries.filter { $0.lhTest == .peak }.count

        let cycleInfos: [CycleInfo] = zip(cycleStarts, cycleStarts.dropFirst()).map { start, next in
            let length = Calendar.current.dateComponents([.day], from: start, to: next).day ?? 0
            let end = Calendar.current.date(byAdding: .day, value: -1, to: next)
            return CycleInfo(length: length, startDate: start, endDate: end)
        }
        
        // MARK: Krwawienie
        let bleedingDaysPerCycle = bleedingDaysLengths(from: sortedEntries, cycleStarts: cycleStarts)
        let avgBleeding = bleedingDaysPerCycle.isEmpty ? 0.0 : Double(bleedingDaysPerCycle.reduce(0, +)) / Double(bleedingDaysPerCycle.count)
        let minBleeding = bleedingDaysPerCycle.min()
        let maxBleeding = bleedingDaysPerCycle.max()
        
        // MARK: Faza lutealna
        let lutealLengths = calculatedLutealLengths(from: sortedEntries, cycleStarts: cycleStarts)
        let avgLuteal = lutealLengths.isEmpty ? 0.0 : Double(lutealLengths.reduce(0, +)) / Double(lutealLengths.count)
        let minLuteal = lutealLengths.min()
        let maxLuteal = lutealLengths.max()

        // MARK: Owulacja
        let ovulationDates = detectOvulationDates(from: sortedEntries, cycleStarts: cycleStarts)
        let cyclesWithOvulation = ovulationDates.count
        let completeCyclesCount = max(cycleStarts.count - 1, 0)
        let cyclesWithoutOvulation = max(completeCyclesCount - cyclesWithOvulation, 0)

        // MARK: Trend BBT
        let bbtTrend = calculateBBTTrend(from: sortedEntries)

        // MARK: Dominujący śluz
        let dominantAppearance = dominantMucusAppearance(from: sortedEntries)
        let dominantSensation = dominantMucusSensation(from: sortedEntries)

        // MARK: Stosunek
        let allIntercourse = sortedEntries.filter { $0.intercourse != .none }
        let intercourseCount = allIntercourse.count
        let unprotectedCount = allIntercourse.filter { $0.intercourse == .unprotected }.count
        let protectedCount = allIntercourse.filter { $0.intercourse == .protected }.count
        
        // MARK: Faza folikularna
        let follicularLengths = calculatedFollicularLengths(
            from: sortedEntries, cycleStarts: cycleStarts
        )
        let avgFollicular = follicularLengths.isEmpty ? 0.0
            : Double(follicularLengths.reduce(0, +)) / Double(follicularLengths.count)
        let minFollicular = follicularLengths.min()
        let maxFollicular = follicularLengths.max()

        // MARK: Konsekwencja BBT
        let bbtConsistency = calculateBBTConsistency(
            from: sortedEntries, cycleStarts: cycleStarts
        )

        // MARK: Ból menstruacyjny
        let painValues = sortedEntries.map(\.menstrualPainIntensity).filter { $0 > 0 }
        let avgPain = painValues.isEmpty ? 0.0
            : Double(painValues.reduce(0, +)) / Double(painValues.count)
        let maxPain = painValues.max()

        // MARK: Nastrój per faza
        let moodByPhase = calculateMoodByPhase(
            from: sortedEntries, cycleStarts: cycleStarts
        )
        
        return CycleStatistics(
            cycleCount: cycleLengths.count,
            cycleLengths: cycleLengths,
            cycleInfos: cycleInfos,
            averageCycleLength: average,
            medianCycleLength: median,
            shortestCycle: shortest,
            longestCycle: longest,
            cycleVariability: variability,
            regularityScore: regularity,
            averageBleedingDays: avgBleeding,
            minBleedingDays: minBleeding,
            maxBleedingDays: maxBleeding,
            averageLutealLength: avgLuteal,
            minLutealLength: minLuteal,
            maxLutealLength: maxLuteal,
            cyclesWithOvulation: cyclesWithOvulation,
            cyclesWithoutOvulation: cyclesWithoutOvulation,
            bbtTrend: bbtTrend,
            dominantMucusAppearance: dominantAppearance,
            dominantMucusSensation: dominantSensation,
            intercourseCount: intercourseCount,
            intercourseUnprotectedCount: unprotectedCount,
            intercourseProtectedCount: protectedCount,
            predictedNextPeriodStart: predictedNextPeriodStart,
            predictedOvulationDate: predictedOvulationDate,
            predictedFertileWindowStart: fertileWindowStart,
            predictedFertileWindowEnd: fertileWindowEnd,
            averageTemperature: averageTemperature,
            temperatureEntryCount: temperatureValues.count,
            lhPeakCount: lhPeakCount,
            averageFollicularLength: avgFollicular,
            minFollicularLength: minFollicular,
            maxFollicularLength: maxFollicular,
            bbtConsistency: bbtConsistency,
            averageMenstrualPain: avgPain,
            maxMenstrualPain: maxPain,
            averageMoodFollicular: moodByPhase.follicular,
            averageMoodOvulatory: moodByPhase.ovulatory,
            averageMoodLuteal: moodByPhase.luteal,
            averageMoodMenstrual: moodByPhase.menstrual,
        )
    }

    private static func calculateCycleLengths(from starts: [Date]) -> [Int] {
        guard starts.count >= 2 else { return [] }

        return zip(starts, starts.dropFirst()).compactMap { start, next in
            let days = Calendar.current.dateComponents([.day], from: start, to: next).day
            return days
        }
    }

    private static func average(of values: [Int]) -> Double {
        guard !values.isEmpty else { return 0 }
        return Double(values.reduce(0, +)) / Double(values.count)
    }

    private static func median(of values: [Int]) -> Double {
        guard !values.isEmpty else { return 0 }

        let sorted = values.sorted()
        let middle = sorted.count / 2

        if sorted.count.isMultiple(of: 2) {
            return Double(sorted[middle - 1] + sorted[middle]) / 2.0
        } else {
            return Double(sorted[middle])
        }
    }

    private static func standardDeviation(of values: [Int]) -> Double {
        guard values.count >= 2 else { return 0 }

        let mean = average(of: values)
        let variance = values
            .map { pow(Double($0) - mean, 2) }
            .reduce(0, +) / Double(values.count)

        return sqrt(variance)
    }

    private static func regularityScore(for values: [Int]) -> Double {
        guard values.count >= 2 else { return 0 }

        let stdDev = standardDeviation(of: values)
        let score = max(0, 100 - (stdDev * 12))
        return min(score, 100)
    }

    private static func estimatedLutealPhaseLength(from entries: [CycleEntry], cycleStarts: [Date]) -> Int {
        let estimatedOvulationDates = detectOvulationDates(from: entries, cycleStarts: cycleStarts)

        let lutealLengths: [Int] = zip(estimatedOvulationDates, cycleStarts.dropFirst()).compactMap { ovulation, nextCycleStart in
            Calendar.current.dateComponents([.day], from: ovulation, to: nextCycleStart).day
        }
        .filter { $0 >= 9 && $0 <= 17 }

        guard !lutealLengths.isEmpty else { return 13 }
        return Int(round(Double(lutealLengths.reduce(0, +)) / Double(lutealLengths.count)))
    }

    private static func detectOvulationDates(from entries: [CycleEntry], cycleStarts: [Date]) -> [Date] {
        guard cycleStarts.count >= 2 else { return [] }

        return zip(cycleStarts, cycleStarts.dropFirst()).compactMap { cycleStart, nextCycleStart in
            let cycleEntries = entries
                .filter { $0.date >= cycleStart && $0.date < nextCycleStart }
                .sorted { $0.date < $1.date }

            if let peakLHDate = cycleEntries.last(where: { $0.lhTest == .peak })?.date {
                return Calendar.current.startOfDay(for: peakLHDate)
            }

            let tempEntries = cycleEntries.filter { $0.temperature != nil }

            guard tempEntries.count >= 6 else { return nil }

            for index in 3..<(tempEntries.count - 2) {
                let baseline = tempEntries[(index - 3)..<index].compactMap(\.temperature)
                guard baseline.count == 3 else { continue }

                let baselineMax = baseline.max() ?? 0
                let current = tempEntries[index].temperature ?? 0
                let next1 = tempEntries[index + 1].temperature ?? 0
                let next2 = tempEntries[index + 2].temperature ?? 0

                if current >= baselineMax + 0.2,
                   next1 >= baselineMax + 0.2,
                   next2 >= baselineMax + 0.2 {
                    return Calendar.current.startOfDay(for: tempEntries[index].date)
                }
            }

            return nil
        }
    }
    
    // MARK: - Krwawienie
    
    private static func bleedingDaysLengths(from entries: [CycleEntry], cycleStarts: [Date]) -> [Int] {
        guard cycleStarts.count >= 2 else { return [] }
        return zip(cycleStarts, cycleStarts.dropFirst()).map { start, next in
            entries.filter {
                $0.date >= start && $0.date < next &&
                $0.bleeding != .none && $0.bleeding != .spotting
            }.count
        }.filter { $0 > 0 }
    }
    
    // MARK: - Faza lutealna
    
    private static func calculatedLutealLengths(from entries: [CycleEntry], cycleStarts: [Date]) -> [Int] {
        guard cycleStarts.count >= 2 else { return [] }
        let ovulationDates = detectOvulationDates(from: entries, cycleStarts: cycleStarts)
        return zip(ovulationDates, cycleStarts.dropFirst()).compactMap { ovulation, nextStart in
            let days = Calendar.current.dateComponents([.day], from: ovulation, to: nextStart).day
            guard let d = days, d >= 8, d <= 18 else { return nil }
            return d
        }
    }
    
    // MARK: - Trend BBT

    private static func calculateBBTTrend(from entries: [CycleEntry]) -> BBTTrend {
        let temps = entries
            .filter { $0.temperature != nil && $0.bbtDisturbances.isEmpty }
            .sorted { $0.date < $1.date }
            .compactMap(\.temperature)

        guard temps.count >= 6 else { return .insufficient }

        let recentCount = min(10, temps.count)
        let recent = Array(temps.suffix(recentCount))
        let half = recentCount / 2
        let firstHalfAvg = recent.prefix(half).reduce(0, +) / Double(half)
        let secondHalfAvg = recent.suffix(half).reduce(0, +) / Double(half)
        let diff = secondHalfAvg - firstHalfAvg

        if diff > 0.15 { return .rising }
        if diff < -0.15 { return .falling }
        return .stable
    }

    // MARK: - Dominujący śluz

    private static func dominantMucusAppearance(from entries: [CycleEntry]) -> MucusAppearance? {
        let values = entries.compactMap(\.mucusAppearance).filter { $0 != .none && $0 != .absent }
        guard !values.isEmpty else { return nil }
        return values.max(by: { a, b in
            values.filter { $0 == a }.count < values.filter { $0 == b }.count
        })
    }

    private static func dominantMucusSensation(from entries: [CycleEntry]) -> MucusSensation? {
        let values = entries.compactMap(\.mucusSensation).filter { $0 != .none && $0 != .dry }
        guard !values.isEmpty else { return nil }
        return values.max(by: { a, b in
            values.filter { $0 == a }.count < values.filter { $0 == b }.count
        })
    }

    // MARK: - Faza folikularna

    private static func calculatedFollicularLengths(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> [Int] {
        guard cycleStarts.count >= 2 else { return [] }
        let ovulations = detectOvulationDates(from: entries, cycleStarts: cycleStarts)
        return zip(cycleStarts, ovulations).compactMap { start, ovulation in
            let days = Calendar.current.dateComponents([.day], from: start, to: ovulation).day
            guard let d = days, d >= 5, d <= 25 else { return nil }
            return d
        }
    }

    // MARK: - Konsekwencja pomiaru BBT

    private static func calculateBBTConsistency(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> Double {
        guard cycleStarts.count >= 2,
              let firstStart = cycleStarts.first,
              let lastStart = cycleStarts.last else { return 0 }

        let totalDays = Calendar.current.dateComponents(
            [.day], from: firstStart, to: lastStart
        ).day ?? 0

        guard totalDays > 0 else { return 0 }

        let daysWithTemp = entries.filter {
            $0.date >= firstStart && $0.date <= lastStart &&
            $0.temperature != nil && !$0.temperatureExcluded
        }.count

        return min(Double(daysWithTemp) / Double(totalDays), 1.0)
    }

    // MARK: - Nastrój per faza

    private struct MoodByPhase {
        let follicular: Double?
        let ovulatory: Double?
        let luteal: Double?
        let menstrual: Double?
    }

    private static func calculateMoodByPhase(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> MoodByPhase {
        guard cycleStarts.count >= 2 else {
            return MoodByPhase(follicular: nil, ovulatory: nil, luteal: nil, menstrual: nil)
        }

        var follicularMoods: [Int] = []
        var ovulatoryMoods: [Int] = []
        var lutealMoods: [Int] = []
        var menstrualMoods: [Int] = []

        let ovulations = detectOvulationDates(from: entries, cycleStarts: cycleStarts)

        for (i, cycleStart) in cycleStarts.dropLast().enumerated() {
            let nextStart = cycleStarts[i + 1]
            let cycleEntries = entries
                .filter { $0.date >= cycleStart && $0.date < nextStart && $0.mood > 0 }
                .sorted { $0.date < $1.date }

            let ovulationDate: Date? = i < ovulations.count ? ovulations[i] : nil

            for entry in cycleEntries {
                let dayOfCycle = Calendar.current.dateComponents(
                    [.day], from: cycleStart, to: entry.date
                ).day ?? 0

                // Faza menstruacyjna: dni 1–5 (lub do końca krwawienia)
                if entry.bleeding != .none && entry.bleeding != .spotting {
                    menstrualMoods.append(entry.mood)
                } else if let ov = ovulationDate {
                    let daysToOv = Calendar.current.dateComponents(
                        [.day], from: entry.date, to: ov
                    ).day ?? 99
                    let daysFromOv = Calendar.current.dateComponents(
                        [.day], from: ov, to: entry.date
                    ).day ?? -1

                    if daysFromOv >= 0 && daysFromOv <= 2 {
                        ovulatoryMoods.append(entry.mood)
                    } else if daysFromOv > 2 {
                        lutealMoods.append(entry.mood)
                    } else if daysToOv >= 0 {
                        follicularMoods.append(entry.mood)
                    }
                } else {
                    // Brak owulacji — szacuj przez połowę cyklu
                    let cycleLen = Calendar.current.dateComponents(
                        [.day], from: cycleStart, to: nextStart
                    ).day ?? 28
                    if dayOfCycle < cycleLen / 2 {
                        follicularMoods.append(entry.mood)
                    } else {
                        lutealMoods.append(entry.mood)
                    }
                }
            }
        }

        func avg(_ arr: [Int]) -> Double? {
            guard !arr.isEmpty else { return nil }
            return Double(arr.reduce(0, +)) / Double(arr.count)
        }

        return MoodByPhase(
            follicular: avg(follicularMoods),
            ovulatory: avg(ovulatoryMoods),
            luteal: avg(lutealMoods),
            menstrual: avg(menstrualMoods)
        )
    }
}
