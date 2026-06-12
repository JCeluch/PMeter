//
//  CycleEntry.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import SwiftData

@Model
final class CycleEntry {
    var date: Date
    var bleedingRawValue: String = BleedingLevel.none.rawValue
    var mucusRawValue: String = MucusObservation.none.rawValue
    var lhTestRawValue: String = LHTestResult.none.rawValue
    var cervixRawValue: String = CervixObservation.none.rawValue

    var mucusAmount: Int = 0
    var breastTenderness: Int = 0

    var temperature: Double?
    var intercourse: Bool = false
    var notes: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init(
        date: Date = .now,
        bleeding: BleedingLevel,
        mucus: MucusObservation,
        lhTest: LHTestResult = .none,
        cervix: CervixObservation = .none,
        mucusAmount: Int = 0,
        breastTenderness: Int = 0,
        temperature: Double? = nil,
        intercourse: Bool = false,
        notes: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.date = date
        self.bleedingRawValue = bleeding.rawValue
        self.mucusRawValue = mucus.rawValue
        self.lhTestRawValue = lhTest.rawValue
        self.cervixRawValue = cervix.rawValue
        self.mucusAmount = mucusAmount
        self.breastTenderness = breastTenderness
        self.temperature = temperature
        self.intercourse = intercourse
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var bleeding: BleedingLevel {
        get { BleedingLevel(rawValue: bleedingRawValue) ?? .none }
        set { bleedingRawValue = newValue.rawValue }
    }

    var mucus: MucusObservation {
        get { MucusObservation(rawValue: mucusRawValue) ?? .none }
        set { mucusRawValue = newValue.rawValue }
    }

    var lhTest: LHTestResult {
        get { LHTestResult(rawValue: lhTestRawValue) ?? .none }
        set { lhTestRawValue = newValue.rawValue }
    }

    var cervix: CervixObservation {
        get { CervixObservation(rawValue: cervixRawValue) ?? .none }
        set { cervixRawValue = newValue.rawValue }
    }

    func touch() {
        updatedAt = .now
    }
}
