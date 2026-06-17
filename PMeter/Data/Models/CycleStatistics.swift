//
//  CycleStatistics.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation

struct CycleStatistics {
    let cycleCount: Int
    let cycleLengths: [Int]
    let cycleInfos: [CycleInfo]
    let averageCycleLength: Double
    let medianCycleLength: Double
    let shortestCycle: Int?
    let longestCycle: Int?
    let cycleVariability: Double
    let regularityScore: Double
    
    let averageBleedingDays: Double
    let minBleedingDays: Int?
    let maxBleedingDays: Int?
    
    let averageLutealLength: Double
    let minLutealLength: Int?
    let maxLutealLength: Int?
    
    let cyclesWithOvulation: Int
    let cyclesWithoutOvulation: Int
    
    let bbtTrend: BBTTrend
    
    let dominantMucusAppearance: MucusAppearance?
    let dominantMucusSensation: MucusSensation?
    
    let intercourseCount: Int
    let intercourseUnprotectedCount: Int
    let intercourseProtectedCount: Int
    
    let predictedNextPeriodStart: Date?
    let predictedOvulationDate: Date?
    let predictedFertileWindowStart: Date?
    let predictedFertileWindowEnd: Date?

    let averageTemperature: Double?
    let temperatureEntryCount: Int
    let lhPeakCount: Int
    
    // MARK: - Zaawansowane

    // Faza folikularna
    let averageFollicularLength: Double
    let minFollicularLength: Int?
    let maxFollicularLength: Int?

    // Konsekwencja pomiaru
    let bbtConsistency: Double          // 0.0–1.0, % dni z temperaturą

    // Ból menstruacyjny
    let averageMenstrualPain: Double    // 0–5, 0 = brak danych
    let maxMenstrualPain: Int?

    // Nastrój per faza
    let averageMoodFollicular: Double?  // nil = za mało danych
    let averageMoodOvulatory: Double?
    let averageMoodLuteal: Double?
    let averageMoodMenstrual: Double?
}

struct CycleInfo {
    let length: Int
    let startDate: Date
    let endDate: Date?
}

enum BBTTrend {
    case rising
    case stable
    case falling
    case insufficient
}
