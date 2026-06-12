//
//  CycleEnums.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import SwiftUI

enum BleedingLevel: String, CaseIterable, Codable {
    case none
    case spotting
    case light
    case medium
    case heavy

    var localizationKey: LocalizedStringKey {
        switch self {
        case .none: "cycle.bleeding.none"
        case .spotting: "cycle.bleeding.spotting"
        case .light: "cycle.bleeding.light"
        case .medium: "cycle.bleeding.medium"
        case .heavy: "cycle.bleeding.heavy"
        }
    }

    var sortOrder: Int {
        switch self {
        case .none: 0
        case .spotting: 1
        case .light: 2
        case .medium: 3
        case .heavy: 4
        }
    }

    var indicatesCycleStart: Bool {
        switch self {
        case .light, .medium, .heavy:
            return true
        case .none, .spotting:
            return false
        }
    }
}

enum MucusObservation: String, CaseIterable, Codable {
    case none
    case dry
    case sticky
    case creamy
    case watery
    case eggWhite

    var localizationKey: LocalizedStringKey {
        switch self {
        case .none: "cycle.mucus.none"
        case .dry: "cycle.mucus.dry"
        case .sticky: "cycle.mucus.sticky"
        case .creamy: "cycle.mucus.creamy"
        case .watery: "cycle.mucus.watery"
        case .eggWhite: "cycle.mucus.eggWhite"
        }
    }

    var fertilityScore: Int {
        switch self {
        case .none, .dry: 0
        case .sticky: 1
        case .creamy: 2
        case .watery: 3
        case .eggWhite: 4
        }
    }
}

enum LHTestResult: String, CaseIterable, Codable {
    case none
    case negative
    case positive
    case peak
    
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none: "cycle.lh.none"
        case .negative: "cycle.lh.negative"
        case .positive: "cycle.lh.positive"
        case .peak: "cycle.lh.peak"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .none: 0
        case .negative: 1
        case .positive: 2
        case .peak: 3
        }
    }
}

enum CervixObservation: String, CaseIterable, Codable {
    case none
    case lowFirmClosed
    case medium
    case highSoftOpen

    var localizationKey: LocalizedStringKey {
        switch self {
        case .none: "cycle.cervix.none"
        case .lowFirmClosed: "cycle.cervix.lowFirmClosed"
        case .medium: "cycle.cervix.medium"
        case .highSoftOpen: "cycle.cervix.highSoftOpen"
        }
    }

    var fertilityScore: Int {
        switch self {
        case .none: 0
        case .lowFirmClosed: 0
        case .medium: 1
        case .highSoftOpen: 2
        }
    }
}
