//
//  CycleEnums.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import SwiftUI

// MARK: - Bleeding

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
        default:
            return false
        }
    }
}

enum BleedingColor: String, CaseIterable, Codable {
    case none        // brak / nie zaznaczono
    case red         // czerwone (świeże)
    case pink        // różowe (słabe estrogeny)
    case brown       // brązowe (stare)
    case black       // czarne (bardzo stare)

    /// Creighton/NaPro — niebezpieczne kolory wymagające uwagi
    var isNaProFlagged: Bool { self == .brown || self == .black || self == .pink }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:  "cycle.bleeding.color.none"
        case .red:   "cycle.bleeding.color.red"
        case .pink:  "cycle.bleeding.color.pink"
        case .brown: "cycle.bleeding.color.brown"
        case .black: "cycle.bleeding.color.black"
        }
    }
}


// MARK: - Mucus (4 niezależne wymiary per Billings/Creighton/STM)

//enum MucusObservation: String, CaseIterable, Codable {
//    case none
//    case dry
//    case sticky
//    case creamy
//    case watery
//    case eggWhite
//
//    var localizationKey: LocalizedStringKey {
//        switch self {
//        case .none: "cycle.mucus.none"
//        case .dry: "cycle.mucus.dry"
//        case .sticky: "cycle.mucus.sticky"
//        case .creamy: "cycle.mucus.creamy"
//        case .watery: "cycle.mucus.watery"
//        case .eggWhite: "cycle.mucus.eggWhite"
//        }
//    }
//
//    var fertilityScore: Int {
//        switch self {
//        case .none, .dry: 0
//        case .sticky: 1
//        case .creamy: 2
//        case .watery: 3
//        case .eggWhite: 4
//        }
//    }
//}

enum MucusSensation: String, CaseIterable, Codable {
    case none        // nie zaznaczono
    case dry         // sucho
    case damp        // wilgotno
    case wet         // mokro
    case slippery    // ślisko (= Peak Day Billingsów)

    var isFertile: Bool { self == .slippery || self == .wet }
    var isPeakSensation: Bool { self == .slippery }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:     "cycle.mucus.sensation.none"
        case .dry:      "cycle.mucus.sensation.dry"
        case .damp:     "cycle.mucus.sensation.damp"
        case .wet:      "cycle.mucus.sensation.wet"
        case .slippery: "cycle.mucus.sensation.slippery"
        }
    }
}

enum MucusAppearance: String, CaseIterable, Codable {
    case none          // brak / nie zaobserwowano
    case absent        // sucho, brak wydzieliny
    case cloudy        // mętny, biały
    case yellow        // żółtawy
    case mixed         // mieszany (mętny + przezroczysty)
    case clear         // przezroczysty
    case eggWhite      // jak surowe białko jaja – szczytowo płodny

    var fertilityScore: Int {
        switch self {
        case .none, .absent: 0
        case .cloudy, .yellow: 1
        case .mixed: 2
        case .clear: 3
        case .eggWhite: 4
        }
    }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:     "cycle.mucus.appearance.none"
        case .absent:   "cycle.mucus.appearance.absent"
        case .cloudy:   "cycle.mucus.appearance.cloudy"
        case .yellow:   "cycle.mucus.appearance.yellow"
        case .mixed:    "cycle.mucus.appearance.mixed"
        case .clear:    "cycle.mucus.appearance.clear"
        case .eggWhite: "cycle.mucus.appearance.eggWhite"
        }
    }
}

enum MucusStretch: String, CaseIterable, Codable {
    case none           // nie zaznaczono
    case absent         // brak rozciągliwości
    case slight         // trochę (< 1 cm)
    case moderate       // umiarkowana (1–3 cm)
    case stretchy       // bardzo (> 3 cm, eggWhite)

    var fertilityScore: Int {
        switch self {
        case .none, .absent: 0
        case .slight: 1
        case .moderate: 2
        case .stretchy: 3
        }
    }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:     "cycle.mucus.stretch.none"
        case .absent:   "cycle.mucus.stretch.absent"
        case .slight:   "cycle.mucus.stretch.slight"
        case .moderate: "cycle.mucus.stretch.moderate"
        case .stretchy: "cycle.mucus.stretch.stretchy"
        }
    }
}

enum MucusVolume: String, CaseIterable, Codable {
    case none        // nie zaznaczono
    case absent      // brak
    case scant       // skąpy
    case moderate    // umiarkowany
    case abundant    // obfity

    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:     "cycle.mucus.volume.none"
        case .absent:   "cycle.mucus.volume.absent"
        case .scant:    "cycle.mucus.volume.scant"
        case .moderate: "cycle.mucus.volume.moderate"
        case .abundant: "cycle.mucus.volume.abundant"
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

// MARK: - Cervix (3 niezależne wymiary, akronim SHOW)

//enum CervixObservation: String, CaseIterable, Codable {
//    case none
//    case lowFirmClosed
//    case medium
//    case highSoftOpen
//
//    var localizationKey: LocalizedStringKey {
//        switch self {
//        case .none: "cycle.cervix.none"
//        case .lowFirmClosed: "cycle.cervix.lowFirmClosed"
//        case .medium: "cycle.cervix.medium"
//        case .highSoftOpen: "cycle.cervix.highSoftOpen"
//        }
//    }
//
//    var fertilityScore: Int {
//        switch self {
//        case .none: 0
//        case .lowFirmClosed: 0
//        case .medium: 1
//        case .highSoftOpen: 2
//        }
//    }
//}

enum CervixPosition: String, CaseIterable, Codable {
    case none    // nie zaznaczono
    case low
    case medium
    case high    // SHOW: High

    var fertilityScore: Int {
        switch self {
        case .none, .low: 0
        case .medium: 1
        case .high: 2
        }
    }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:   "cycle.cervix.position.none"
        case .low:    "cycle.cervix.position.low"
        case .medium: "cycle.cervix.position.medium"
        case .high:   "cycle.cervix.position.high"
        }
    }
}

enum CervixFirmness: String, CaseIterable, Codable {
    case none    // nie zaznaczono
    case firm    // twarda jak czubek nosa — niepłodność
    case medium
    case soft    // SHOW: Soft — miękka jak wargi

    var fertilityScore: Int {
        switch self {
        case .none, .firm: 0
        case .medium: 1
        case .soft: 2
        }
    }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:   "cycle.cervix.firmness.none"
        case .firm:   "cycle.cervix.firmness.firm"
        case .medium: "cycle.cervix.firmness.medium"
        case .soft:   "cycle.cervix.firmness.soft"
        }
    }
}

enum CervixOpening: String, CaseIterable, Codable {
    case none
    case closed      // zamknięta — niepłodność
    case slightlyOpen
    case open        // SHOW: Open — otwarta

    var fertilityScore: Int {
        switch self {
        case .none, .closed: 0
        case .slightlyOpen: 1
        case .open: 2
        }
    }
    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:         "cycle.cervix.opening.none"
        case .closed:       "cycle.cervix.opening.closed"
        case .slightlyOpen: "cycle.cervix.opening.slightlyOpen"
        case .open:         "cycle.cervix.opening.open"
        }
    }
}

// MARK: - BBT disturbances

enum BBTDisturbance: String, CaseIterable, Codable {
    case illness        // choroba / gorączka
    case alcohol        // alkohol poprzedniego dnia
    case shortSleep     // < 3–6 godz. snu
    case differentTime  // inna pora pomiaru
    case timeZone       // zmiana strefy czasowej
    case stress         // silny stres

    var localizationKey: LocalizedStringKey {
        switch self {
        case .illness:       "cycle.bbt.disturbance.illness"
        case .alcohol:       "cycle.bbt.disturbance.alcohol"
        case .shortSleep:    "cycle.bbt.disturbance.shortSleep"
        case .differentTime: "cycle.bbt.disturbance.differentTime"
        case .timeZone:      "cycle.bbt.disturbance.timeZone"
        case .stress:        "cycle.bbt.disturbance.stress"
        }
    }
}

enum BBTMeasurementSite: String, CaseIterable, Codable {
    case oral
    case vaginal
    case rectal

    var localizationKey: LocalizedStringKey {
        switch self {
        case .oral:    "cycle.bbt.site.oral"
        case .vaginal: "cycle.bbt.site.vaginal"
        case .rectal:  "cycle.bbt.site.rectal"
        }
    }
}

// MARK: - Pain

enum PainSide: String, CaseIterable, Codable {
    case none
    case left
    case right
    case both
}

// MARK: - Intercourse

enum IntercourseType: String, CaseIterable, Codable {
    case none
    case unprotected
    case protected

    var localizationKey: LocalizedStringKey {
        switch self {
        case .none:        "cycle.intercourse.none"
        case .unprotected: "cycle.intercourse.unprotected"
        case .protected:   "cycle.intercourse.protected"
        }
    }
}
