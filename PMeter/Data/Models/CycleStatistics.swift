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
//    let cycleInfos: [CycleInfo]
    let averageCycleLength: Double
    let medianCycleLength: Double
    let shortestCycle: Int?
    let longestCycle: Int?
    let cycleVariability: Double
    let regularityScore: Double

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
