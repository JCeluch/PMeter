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
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    // MARK: - Krwawienie
    var bleedingRawValue: String = BleedingLevel.none.rawValue
    var bleedingColorRawValue: String = BleedingColor.none.rawValue
    /// Plamienie pozamiesiączkowe (odrębne od krwawienia cyklu)
    var intermenstrualSpotting: Bool = false
    
    // MARK: - Śluz (4 wymiary — Billings/Creighton/STM)
    var mucusSensationRawValue: String = MucusSensation.none.rawValue
    var mucusAppearanceRawValue: String = MucusAppearance.none.rawValue
    var mucusStretchRawValue: String = MucusStretch.none.rawValue
    var mucusVolumeRawValue: String = MucusVolume.none.rawValue
    /// Użytkowniczka może ręcznie oznaczyć Dzień Szczytowy (Peak Day)
    var isPeakDay: Bool = false
    
    // MARK: - Temperatura BBT
    var temperature: Double?
    var temperatureMeasurementTime: Date?
    var temperatureSiteRawValue: String = BBTMeasurementSite.oral.rawValue
    /// Zakłócenia jako JSON-encoded lista rawValue (SwiftData nie ma natywnych array)
    var bbtDisturbancesRaw: String = ""
    var temperatureExcluded: Bool = false

    // MARK: - Szyjka macicy (3 wymiary SHOW)
    var cervixPositionRawValue: String = CervixPosition.none.rawValue
    var cervixFirmnessRawValue: String = CervixFirmness.none.rawValue
    var cervixOpeningRawValue: String = CervixOpening.none.rawValue

    // MARK: - Testy hormonalne
    var lhTestRawValue: String = LHTestResult.none.rawValue
    var progesteroneTestPositive: Bool? // Proov/PdG: nil = nie testowano

    // MARK: - Objawy dodatkowe
    var ovulationPainIntensity: Int = 0   // 0 = brak, 1–5
    var ovulationPainSideRawValue: String = PainSide.none.rawValue
    var breastTenderness: Int = 0          // 0 = brak, 1–5
    var menstrualPainIntensity: Int = 0    // 0 = brak, 1–5 (dysmenorrhea)

    // MARK: - Inne
    var intercourseRawValue: String = IntercourseType.none.rawValue
    var isBreastfeeding: Bool = false      // dla metody LAM
    var mood: Int = 0                      // 0 = nie zaznaczono, 1–5 (opcjonalne)
    var notes: String = ""
    
    // MARK: - Init
    init(
        date: Date = .now,
        bleeding: BleedingLevel = .none,
        bleedingColor: BleedingColor = .none,
        intermenstrualSpotting: Bool = false,
        mucusSensation: MucusSensation = .none,
        mucusAppearance: MucusAppearance = .none,
        mucusStretch: MucusStretch = .none,
        mucusVolume: MucusVolume = .none,
        isPeakDay: Bool = false,
        temperature: Double? = nil,
        temperatureMeasurementTime: Date? = nil,
        temperatureSite: BBTMeasurementSite = .oral,
        bbtDisturbances: [BBTDisturbance] = [],
        temperatureExcluded: Bool = false,
        cervixPosition: CervixPosition = .none,
        cervixFirmness: CervixFirmness = .none,
        cervixOpening: CervixOpening = .none,
        lhTest: LHTestResult = .none,
        progesteroneTestPositive: Bool? = nil,
        ovulationPainIntensity: Int = 0,
        ovulationPainSide: PainSide = .none,
        breastTenderness: Int = 0,
        menstrualPainIntensity: Int = 0,
        intercourse: IntercourseType = .none,
        isBreastfeeding: Bool = false,
        notes: String = ""
    ) {
        self.date = date
        self.createdAt = .now
        self.updatedAt = .now

        self.bleedingRawValue = bleeding.rawValue
        self.bleedingColorRawValue = bleedingColor.rawValue
        self.intermenstrualSpotting = intermenstrualSpotting

        self.mucusSensationRawValue = mucusSensation.rawValue
        self.mucusAppearanceRawValue = mucusAppearance.rawValue
        self.mucusStretchRawValue = mucusStretch.rawValue
        self.mucusVolumeRawValue = mucusVolume.rawValue
        self.isPeakDay = isPeakDay

        self.temperature = temperature
        self.temperatureMeasurementTime = temperatureMeasurementTime
        self.temperatureSiteRawValue = temperatureSite.rawValue
        self.bbtDisturbancesRaw = bbtDisturbances.map(\.rawValue).joined(separator: ",")
        self.temperatureExcluded = temperatureExcluded

        self.cervixPositionRawValue = cervixPosition.rawValue
        self.cervixFirmnessRawValue = cervixFirmness.rawValue
        self.cervixOpeningRawValue = cervixOpening.rawValue

        self.lhTestRawValue = lhTest.rawValue
        self.progesteroneTestPositive = progesteroneTestPositive

        self.ovulationPainIntensity = ovulationPainIntensity
        self.ovulationPainSideRawValue = ovulationPainSide.rawValue
        self.breastTenderness = breastTenderness
        self.menstrualPainIntensity = menstrualPainIntensity

        self.intercourseRawValue = intercourse.rawValue
        self.isBreastfeeding = isBreastfeeding
        self.notes = notes
    }

    
    // MARK: - Computed properties
    
    var bleeding: BleedingLevel {
        get { BleedingLevel(rawValue: bleedingRawValue) ?? .none }
        set { bleedingRawValue = newValue.rawValue }
    }
    var bleedingColor: BleedingColor {
        get { BleedingColor(rawValue: bleedingColorRawValue) ?? .none }
        set { bleedingColorRawValue = newValue.rawValue }
    }
    var mucusSensation: MucusSensation {
        get { MucusSensation(rawValue: mucusSensationRawValue) ?? .none }
        set { mucusSensationRawValue = newValue.rawValue }
    }
    var mucusAppearance: MucusAppearance {
        get { MucusAppearance(rawValue: mucusAppearanceRawValue) ?? .none }
        set { mucusAppearanceRawValue = newValue.rawValue }
    }
    var mucusStretch: MucusStretch {
        get { MucusStretch(rawValue: mucusStretchRawValue) ?? .none }
        set { mucusStretchRawValue = newValue.rawValue }
    }
    var mucusVolume: MucusVolume {
        get { MucusVolume(rawValue: mucusVolumeRawValue) ?? .none }
        set { mucusVolumeRawValue = newValue.rawValue }
    }
    var cervixPosition: CervixPosition {
        get { CervixPosition(rawValue: cervixPositionRawValue) ?? .none }
        set { cervixPositionRawValue = newValue.rawValue }
    }
    var cervixFirmness: CervixFirmness {
        get { CervixFirmness(rawValue: cervixFirmnessRawValue) ?? .none }
        set { cervixFirmnessRawValue = newValue.rawValue }
    }
    var cervixOpening: CervixOpening {
        get { CervixOpening(rawValue: cervixOpeningRawValue) ?? .none }
        set { cervixOpeningRawValue = newValue.rawValue }
    }
    var lhTest: LHTestResult {
        get { LHTestResult(rawValue: lhTestRawValue) ?? .none }
        set { lhTestRawValue = newValue.rawValue }
    }
    var intercourse: IntercourseType {
        get { IntercourseType(rawValue: intercourseRawValue) ?? .none }
        set { intercourseRawValue = newValue.rawValue }
    }
    var ovulationPainSide: PainSide {
        get { PainSide(rawValue: ovulationPainSideRawValue) ?? .none }
        set { ovulationPainSideRawValue = newValue.rawValue }
    }
    var bbtDisturbances: [BBTDisturbance] {
        get {
            bbtDisturbancesRaw
                .split(separator: ",")
                .compactMap { BBTDisturbance(rawValue: String($0)) }
        }
        set {
            bbtDisturbancesRaw = newValue.map(\.rawValue).joined(separator: ",")
        }
    }
    var temperatureSite: BBTMeasurementSite {
        get { BBTMeasurementSite(rawValue: temperatureSiteRawValue) ?? .oral }
        set { temperatureSiteRawValue = newValue.rawValue }
    }

    /// Composite fertility score (pomocniczy, nie zastępuje reguł metody)
    var fertilityScore: Int {
        mucusAppearance.fertilityScore
        + mucusStretch.fertilityScore
        + cervixPosition.fertilityScore
        + cervixFirmness.fertilityScore
        + cervixOpening.fertilityScore
    }

    func touch() { updatedAt = .now }
}
