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
