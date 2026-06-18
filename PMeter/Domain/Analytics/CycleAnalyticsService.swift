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
        
        let ovulationDates = detectOvulationDates(from: sortedEntries, cycleStarts: cycleStarts)

        let predictedNextPeriodStart: Date? = {
            guard !cycleLengths.isEmpty, let lastStart = cycleStarts.last else { return nil }
            return Calendar.current.date(byAdding: .day, value: Int(round(average)), to: lastStart)
        }()

        let estimatedLutealLength = estimatedLutealPhaseLength(from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates)

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
        let lutealLengths = calculatedLutealLengths(from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates)
        let avgLuteal = lutealLengths.isEmpty ? 0.0 : Double(lutealLengths.reduce(0, +)) / Double(lutealLengths.count)
        let minLuteal = lutealLengths.min()
        let maxLuteal = lutealLengths.max()

        // MARK: Owulacja
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
            from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates
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
            from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates
        )
        
        // MARK: Ból owulacyjny
        let ovPainValues = sortedEntries.map(\.ovulationPainIntensity).filter { $0 > 0 }
        let avgOvPain = ovPainValues.isEmpty ? 0.0
            : Double(ovPainValues.reduce(0, +)) / Double(ovPainValues.count)
        let maxOvPain = ovPainValues.max()
        let dominantPainSide = dominantOvulationPainSide(from: sortedEntries)

        // MARK: Czułość piersi per faza
        let breastTenderness = calculateBreastTendernessPerPhase(
            from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates
        )

        // MARK: Plamienie
        let spottingDays = sortedEntries.filter { $0.intermenstrualSpotting }.count
        let spottingCycles = cyclesWithSpottingCount(from: sortedEntries, cycleStarts: cycleStarts)

        // MARK: Test progesteron
        let progCycles = cyclesWithProgesteroneTestCount(from: sortedEntries, cycleStarts: cycleStarts)

        // MARK: Peak Day
        let avgPeakDay = averagePeakDayOfCycle(from: sortedEntries, cycleStarts: cycleStarts)

        // MARK: Szyjka SHOW
        let showStats = calculateSHOWStats(from: sortedEntries)

        // MARK: Streak BBT
        let bbtStreak = longestBBTStreak(from: sortedEntries)

        // MARK: Karmienie
        let breastfeedingDays = sortedEntries.filter { $0.isBreastfeeding }.count
        
        // MARK: Trend cykli
        let trendResult = calculateCycleLengthTrend(from: cycleLengths)

        // MARK: Przedział ufności
        let stdDev = variability  // już obliczone
        let nextPeriodEarliest = predictedNextPeriodStart.flatMap {
            Calendar.current.date(byAdding: .day, value: -Int(ceil(stdDev)), to: $0)
        }
        let nextPeriodLatest = predictedNextPeriodStart.flatMap {
            Calendar.current.date(byAdding: .day, value: Int(ceil(stdDev)), to: $0)
        }

        // MARK: LH peak średni dzień cyklu
        let avgLHPeakDay = averageLHPeakDayOfCycle(from: sortedEntries, cycleStarts: cycleStarts)

        // MARK: Pierwszy dzień śluzu płodnego
        let avgFirstFertileMucusDay = averageFirstFertileMucusDayOfCycle(from: sortedEntries, cycleStarts: cycleStarts)

        // MARK: Dominujący kolor krwawienia
        let dominantColor = dominantBleedingColor(from: sortedEntries)

        // MARK: Aktywny cykl
        let activeCycleInfo = calculateActiveCycleInfo(
            from: sortedEntries,
            cycleStarts: cycleStarts,
            average: average,
            stdDev: stdDev
        )
        
        // MARK: Samopoczucie per faza
        let wellbeing = calculateWellbeingByPhase(from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates)

        // MARK: Ból głowy
        let headacheEntries = sortedEntries.filter { $0.headacheIntensity > 0 }
        let avgHeadache = headacheEntries.isEmpty ? 0.0
            : Double(headacheEntries.map(\.headacheIntensity).reduce(0, +)) / Double(headacheEntries.count)

        // MARK: Skóra
        let dominantSkin = dominantSkinConditionInLuteal(from: sortedEntries, cycleStarts: cycleStarts, ovulationDates: ovulationDates)

        // MARK: Waga
        let weightValues = sortedEntries.compactMap(\.weight)
        let avgWeight = weightValues.isEmpty ? nil
            : weightValues.reduce(0, +) / Double(weightValues.count)
        
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
            averageOvulationPain: avgOvPain,
            maxOvulationPain: maxOvPain,
            dominantOvulationPainSide: dominantPainSide,
            averageBreastTendernessFollicular: breastTenderness.follicular,
            averageBreastTendernessLuteal: breastTenderness.luteal,
            cyclesWithSpotting: spottingCycles,
            spotting: spottingDays,
            cyclesWithProgesteroneTest: progCycles.tested,
            cyclesWithConfirmedProgesterone: progCycles.confirmed,
            averagePeakDayOfCycle: avgPeakDay,
            showDaysCount: showStats.days,
            showPercentage: showStats.percentage,
            longestBBTStreak: bbtStreak,
            breastfeedingDaysCount: breastfeedingDays,
            cycleLengthTrend: trendResult.trend,
            cycleLengthTrendSlope: trendResult.slope,
            predictedNextPeriodEarliest: nextPeriodEarliest,
            predictedNextPeriodLatest: nextPeriodLatest,
            averageLHPeakDayOfCycle: avgLHPeakDay,
            averageFirstFertileMucusDayOfCycle: avgFirstFertileMucusDay,
            dominantBleedingColor: dominantColor,
            currentCycleDayCount: activeCycleInfo.dayCount,
            currentCycleIsLate: activeCycleInfo.isLate,
            averageEnergyFollicular: wellbeing.energyFollicular,
            averageEnergyLuteal: wellbeing.energyLuteal,
            averageEnergyMenstrual: wellbeing.energyMenstrual,
            averageSleepQualityFollicular: wellbeing.sleepFollicular,
            averageSleepQualityLuteal: wellbeing.sleepLuteal,
            headacheDaysCount: headacheEntries.count,
            averageHeadacheIntensity: avgHeadache,
            dominantSkinConditionLuteal: dominantSkin,
            averageWeight: avgWeight,
            minWeight: weightValues.min(),
            maxWeight: weightValues.max(),
            weightEntryCount: weightValues.count,
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

    private static func estimatedLutealPhaseLength(from entries: [CycleEntry], cycleStarts: [Date], ovulationDates: [Date]) -> Int {
        let lutealLengths: [Int] = zip(ovulationDates, cycleStarts.dropFirst()).compactMap { ovulation, nextCycleStart in
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
    
    private static func calculatedLutealLengths(from entries: [CycleEntry], cycleStarts: [Date], ovulationDates: [Date]) -> [Int] {
        guard cycleStarts.count >= 2 else { return [] }
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
        cycleStarts: [Date],
        ovulationDates: [Date]
    ) -> [Int] {
        guard cycleStarts.count >= 2 else { return [] }
        return zip(cycleStarts, ovulationDates).compactMap { start, ovulation in
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
        cycleStarts: [Date],
        ovulationDates: [Date]
    ) -> MoodByPhase {
        guard cycleStarts.count >= 2 else {
            return MoodByPhase(follicular: nil, ovulatory: nil, luteal: nil, menstrual: nil)
        }

        var follicularMoods: [Int] = []
        var ovulatoryMoods: [Int] = []
        var lutealMoods: [Int] = []
        var menstrualMoods: [Int] = []

        for (i, cycleStart) in cycleStarts.dropLast().enumerated() {
            let nextStart = cycleStarts[i + 1]
            let cycleEntries = entries
                .filter { $0.date >= cycleStart && $0.date < nextStart && $0.mood > 0 }
                .sorted { $0.date < $1.date }

            let ovulationDate: Date? = i < ovulationDates.count ? ovulationDates[i] : nil

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
    
    // MARK: - Ból owulacyjny

    private static func dominantOvulationPainSide(from entries: [CycleEntry]) -> PainSide? {
        let sides = entries
            .filter { $0.ovulationPainIntensity > 0 && $0.ovulationPainSide != .none }
            .map(\.ovulationPainSide)
        guard !sides.isEmpty else { return nil }
        return sides.max(by: { a, b in
            sides.filter { $0 == a }.count < sides.filter { $0 == b }.count
        })
    }

    // MARK: - Czułość piersi

    private struct BreastTendernessPerPhase {
        let follicular: Double?
        let luteal: Double?
    }

    private static func calculateBreastTendernessPerPhase(
        from entries: [CycleEntry],
        cycleStarts: [Date],
        ovulationDates: [Date]
    ) -> BreastTendernessPerPhase {
        guard cycleStarts.count >= 2 else {
            return BreastTendernessPerPhase(follicular: nil, luteal: nil)
        }
        var follicular: [Int] = []
        var luteal: [Int] = []

        for (i, cycleStart) in cycleStarts.dropLast().enumerated() {
            let nextStart = cycleStarts[i + 1]
            let cycleEntries = entries
                .filter { $0.date >= cycleStart && $0.date < nextStart && $0.breastTenderness > 0 }
            let ovDate: Date? = i < ovulationDates.count ? ovulationDates[i] : nil

            for entry in cycleEntries {
                if let ov = ovDate {
                    let daysFromOv = Calendar.current.dateComponents([.day], from: ov, to: entry.date).day ?? -1
                    if daysFromOv >= 0 {
                        luteal.append(entry.breastTenderness)
                    } else {
                        follicular.append(entry.breastTenderness)
                    }
                } else {
                    let cycleLen = Calendar.current.dateComponents([.day], from: cycleStart, to: nextStart).day ?? 28
                    let dayOfCycle = Calendar.current.dateComponents([.day], from: cycleStart, to: entry.date).day ?? 0
                    if dayOfCycle < cycleLen / 2 {
                        follicular.append(entry.breastTenderness)
                    } else {
                        luteal.append(entry.breastTenderness)
                    }
                }
            }
        }

        func avg(_ arr: [Int]) -> Double? {
            guard !arr.isEmpty else { return nil }
            return Double(arr.reduce(0, +)) / Double(arr.count)
        }
        return BreastTendernessPerPhase(follicular: avg(follicular), luteal: avg(luteal))
    }

    // MARK: - Plamienie

    private static func cyclesWithSpottingCount(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> Int {
        guard cycleStarts.count >= 2 else { return 0 }
        return zip(cycleStarts, cycleStarts.dropFirst()).filter { start, next in
            entries.contains { $0.date >= start && $0.date < next && $0.intermenstrualSpotting }
        }.count
    }

    // MARK: - Test progesteron

    private struct ProgesteroneStats {
        let tested: Int
        let confirmed: Int
    }

    private static func cyclesWithProgesteroneTestCount(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> ProgesteroneStats {
        guard cycleStarts.count >= 2 else { return ProgesteroneStats(tested: 0, confirmed: 0) }
        var tested = 0
        var confirmed = 0
        for (start, next) in zip(cycleStarts, cycleStarts.dropFirst()) {
            let cycleEntries = entries.filter {
                $0.date >= start && $0.date < next && $0.progesteroneTestPositive != nil
            }
            if !cycleEntries.isEmpty {
                tested += 1
                if cycleEntries.contains(where: { $0.progesteroneTestPositive == true }) {
                    confirmed += 1
                }
            }
        }
        return ProgesteroneStats(tested: tested, confirmed: confirmed)
    }

    // MARK: - Peak Day

    private static func averagePeakDayOfCycle(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> Double? {
        guard cycleStarts.count >= 2 else { return nil }
        let peakDays: [Int] = zip(cycleStarts, cycleStarts.dropFirst()).compactMap { start, next in
            guard let peakEntry = entries.first(where: {
                $0.date >= start && $0.date < next && $0.isPeakDay
            }) else { return nil }
            return (Calendar.current.dateComponents([.day], from: start, to: peakEntry.date).day ?? 0) + 1
        }
        guard !peakDays.isEmpty else { return nil }
        return Double(peakDays.reduce(0, +)) / Double(peakDays.count)
    }

    // MARK: - Szyjka SHOW

    private struct SHOWStats {
        let days: Int
        let percentage: Double
    }

    private static func calculateSHOWStats(from entries: [CycleEntry]) -> SHOWStats {
        let withCervix = entries.filter { $0.cervixPosition != .none }
        guard !withCervix.isEmpty else { return SHOWStats(days: 0, percentage: 0) }
        let showDays = withCervix.filter {
            $0.cervixPosition == .high &&
            $0.cervixFirmness == .soft &&
            $0.cervixOpening == .open
        }.count
        let pct = Double(showDays) / Double(withCervix.count)
        return SHOWStats(days: showDays, percentage: pct)
    }

    // MARK: - Streak BBT

    private static func longestBBTStreak(from entries: [CycleEntry]) -> Int {
        let datesWithTemp = Set(
            entries
                .filter { $0.temperature != nil && !$0.temperatureExcluded }
                .map { Calendar.current.startOfDay(for: $0.date) }
        ).sorted()

        guard !datesWithTemp.isEmpty else { return 0 }
        var longest = 1
        var current = 1
        for i in 1..<datesWithTemp.count {
            let diff = Calendar.current.dateComponents(
                [.day], from: datesWithTemp[i - 1], to: datesWithTemp[i]
            ).day ?? 99
            if diff == 1 {
                current += 1
                longest = max(longest, current)
            } else {
                current = 1
            }
        }
        return longest
    }
    
    // MARK: - Trend długości cykli (regresja liniowa)

    private struct TrendResult {
        let trend: CycleLengthTrend
        let slope: Double
    }

    private static func calculateCycleLengthTrend(from lengths: [Int]) -> TrendResult {
        guard lengths.count >= 4 else {
            return TrendResult(trend: .insufficient, slope: 0)
        }
        let n = Double(lengths.count)
        let xMean = (n - 1) / 2
        let yMean = lengths.map { Double($0) }.reduce(0, +) / n

        var num = 0.0
        var den = 0.0
        for (i, len) in lengths.enumerated() {
            let x = Double(i) - xMean
            num += x * (Double(len) - yMean)
            den += x * x
        }
        let slope = den == 0 ? 0 : num / den

        let trend: CycleLengthTrend
        if slope > 0.3 {
            trend = .increasing
        } else if slope < -0.3 {
            trend = .decreasing
        } else {
            trend = .stable
        }
        return TrendResult(trend: trend, slope: slope)
    }

    // MARK: - LH peak dzień cyklu

    private static func averageLHPeakDayOfCycle(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> Double? {
        guard cycleStarts.count >= 2 else { return nil }
        let days: [Int] = zip(cycleStarts, cycleStarts.dropFirst()).compactMap { start, next in
            guard let peak = entries.first(where: {
                $0.date >= start && $0.date < next && $0.lhTest == .peak
            }) else { return nil }
            return (Calendar.current.dateComponents([.day], from: start, to: peak.date).day ?? 0) + 1
        }
        guard !days.isEmpty else { return nil }
        return Double(days.reduce(0, +)) / Double(days.count)
    }

    // MARK: - Pierwszy dzień śluzu płodnego

    private static func averageFirstFertileMucusDayOfCycle(
        from entries: [CycleEntry],
        cycleStarts: [Date]
    ) -> Double? {
        guard cycleStarts.count >= 2 else { return nil }
        let days: [Int] = zip(cycleStarts, cycleStarts.dropFirst()).compactMap { start, next in
            guard let first = entries
                .filter({ $0.date >= start && $0.date < next &&
                         ($0.mucusAppearance == .eggWhite || $0.mucusAppearance == .clear) })
                .min(by: { $0.date < $1.date })
            else { return nil }
            return (Calendar.current.dateComponents([.day], from: start, to: first.date).day ?? 0) + 1
        }
        guard !days.isEmpty else { return nil }
        return Double(days.reduce(0, +)) / Double(days.count)
    }

    // MARK: - Dominujący kolor krwawienia

    private static func dominantBleedingColor(from entries: [CycleEntry]) -> BleedingColor? {
        let colors = entries.compactMap(\.bleedingColor).filter { $0 != .none }
        guard !colors.isEmpty else { return nil }
        return colors.max(by: { a, b in
            colors.filter { $0 == a }.count < colors.filter { $0 == b }.count
        })
    }

    // MARK: - Aktywny cykl

    private struct ActiveCycleInfo {
        let dayCount: Int?
        let isLate: Bool
    }

    private static func calculateActiveCycleInfo(
        from entries: [CycleEntry],
        cycleStarts: [Date],
        average: Double,
        stdDev: Double
    ) -> ActiveCycleInfo {
        guard let lastStart = cycleStarts.last else {
            return ActiveCycleInfo(dayCount: nil, isLate: false)
        }
        let today = Calendar.current.startOfDay(for: Date())
        let dayCount = (Calendar.current.dateComponents([.day], from: lastStart, to: today).day ?? 0) + 1
        let threshold = average + max(stdDev, 2)
        return ActiveCycleInfo(dayCount: dayCount, isLate: Double(dayCount) > threshold)
    }
    
    // MARK: - Samopoczucie per faza

    private struct WellbeingByPhase {
        let energyFollicular: Double?
        let energyLuteal: Double?
        let energyMenstrual: Double?
        let sleepFollicular: Double?
        let sleepLuteal: Double?
    }

    private static func calculateWellbeingByPhase(
        from entries: [CycleEntry],
        cycleStarts: [Date],
        ovulationDates: [Date]
    ) -> WellbeingByPhase {
        guard cycleStarts.count >= 2 else {
            return WellbeingByPhase(energyFollicular: nil, energyLuteal: nil,
                                    energyMenstrual: nil, sleepFollicular: nil, sleepLuteal: nil)
        }

        var eFollicular: [Int] = [], eLuteal: [Int] = [], eMenstrual: [Int] = []
        var sFollicular: [Int] = [], sLuteal: [Int] = []

        for (i, cycleStart) in cycleStarts.dropLast().enumerated() {
            let nextStart = cycleStarts[i + 1]
            let cycleEntries = entries.filter { $0.date >= cycleStart && $0.date < nextStart }
            let ovDate: Date? = i < ovulationDates.count ? ovulationDates[i] : nil
            let cycleLen = Calendar.current.dateComponents([.day], from: cycleStart, to: nextStart).day ?? 28

            for entry in cycleEntries {
                let isLuteal: Bool
                if let ov = ovDate {
                    let daysFromOv = Calendar.current.dateComponents([.day], from: ov, to: entry.date).day ?? -1
                    isLuteal = daysFromOv >= 0
                } else {
                    let day = Calendar.current.dateComponents([.day], from: cycleStart, to: entry.date).day ?? 0
                    isLuteal = day >= cycleLen / 2
                }

                let isMenstrual = entry.bleeding != .none && entry.bleeding != .spotting

                if entry.energyLevel > 0 {
                    if isMenstrual { eMenstrual.append(entry.energyLevel) }
                    else if isLuteal { eLuteal.append(entry.energyLevel) }
                    else { eFollicular.append(entry.energyLevel) }
                }
                if entry.sleepQuality > 0 {
                    if isLuteal { sLuteal.append(entry.sleepQuality) }
                    else { sFollicular.append(entry.sleepQuality) }
                }
            }
        }

        func avg(_ arr: [Int]) -> Double? {
            guard !arr.isEmpty else { return nil }
            return Double(arr.reduce(0, +)) / Double(arr.count)
        }

        return WellbeingByPhase(
            energyFollicular: avg(eFollicular),
            energyLuteal: avg(eLuteal),
            energyMenstrual: avg(eMenstrual),
            sleepFollicular: avg(sFollicular),
            sleepLuteal: avg(sLuteal)
        )
    }

    // MARK: - Skóra w fazie lutealnej

    private static func dominantSkinConditionInLuteal(
        from entries: [CycleEntry],
        cycleStarts: [Date],
        ovulationDates: [Date]
    ) -> Int? {
        guard cycleStarts.count >= 2 else { return nil }

        var lutealSkin: [Int] = []
        for (i, cycleStart) in cycleStarts.dropLast().enumerated() {
            let nextStart = cycleStarts[i + 1]
            let ovDate: Date? = i < ovulationDates.count ? ovulationDates[i] : nil
            let cycleLen = Calendar.current.dateComponents([.day], from: cycleStart, to: nextStart).day ?? 28

            let lutealEntries = entries.filter { entry in
                guard entry.date >= cycleStart && entry.date < nextStart && entry.skinCondition > 0 else { return false }
                if let ov = ovDate {
                    return (Calendar.current.dateComponents([.day], from: ov, to: entry.date).day ?? -1) >= 0
                }
                let day = Calendar.current.dateComponents([.day], from: cycleStart, to: entry.date).day ?? 0
                return day >= cycleLen / 2
            }
            lutealSkin.append(contentsOf: lutealEntries.map(\.skinCondition))
        }

        guard !lutealSkin.isEmpty else { return nil }
        return lutealSkin.max(by: { a, b in
            lutealSkin.filter { $0 == a }.count < lutealSkin.filter { $0 == b }.count
        })
    }
}
