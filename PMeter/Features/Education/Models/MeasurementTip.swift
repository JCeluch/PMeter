//
//  MeasurementTip.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import SwiftUI

struct MeasurementTip: Identifiable {
    let id: String
    let systemImage: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let bodyParagraphs: [LocalizedStringKey]
    let dos: [LocalizedStringKey]
    let donts: [LocalizedStringKey]
    let warning: LocalizedStringKey?
}

// MARK: - Collections

extension MeasurementTip {
    static let temperature: [MeasurementTip] = [
        .thermometerChoice,
        .measurementTime,
        .measurementTechnique,
        .disturbances
    ]

    static let mucus: [MeasurementTip] = [
        .mucusBasics,
        .mucusObservation,
        .mucusRecording
    ]

    static let cervix: [MeasurementTip] = [
        .cervixBasics,
        .cervixTechnique
    ]
}

// MARK: - Temperatura

extension MeasurementTip {

    static let thermometerChoice = MeasurementTip(
        id: "thermometer-choice",
        systemImage: "thermometer.medium",
        title: L10n.Education.MeasurementTips.Tip.ThermometerChoice.title,
        subtitle: L10n.Education.MeasurementTips.Tip.ThermometerChoice.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.body1,
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.do1,
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.do2,
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.do3
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.dont1,
            L10n.Education.MeasurementTips.Tip.ThermometerChoice.dont2
        ],
        warning: nil
    )

    static let measurementTime = MeasurementTip(
        id: "measurement-time",
        systemImage: "clock",
        title: L10n.Education.MeasurementTips.Tip.MeasurementTime.title,
        subtitle: L10n.Education.MeasurementTips.Tip.MeasurementTime.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.MeasurementTime.body1,
            L10n.Education.MeasurementTips.Tip.MeasurementTime.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.MeasurementTime.do1,
            L10n.Education.MeasurementTips.Tip.MeasurementTime.do2
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.MeasurementTime.dont1,
            L10n.Education.MeasurementTips.Tip.MeasurementTime.dont2
        ],
        warning: L10n.Education.MeasurementTips.Tip.MeasurementTime.warning
    )

    static let measurementTechnique = MeasurementTip(
        id: "measurement-technique",
        systemImage: "mouth",
        title: L10n.Education.MeasurementTips.Tip.MeasurementTechnique.title,
        subtitle: L10n.Education.MeasurementTips.Tip.MeasurementTechnique.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.MeasurementTechnique.body1
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.MeasurementTechnique.do1,
            L10n.Education.MeasurementTips.Tip.MeasurementTechnique.do2,
            L10n.Education.MeasurementTips.Tip.MeasurementTechnique.do3
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.MeasurementTechnique.dont1,
            L10n.Education.MeasurementTips.Tip.MeasurementTechnique.dont2
        ],
        warning: nil
    )

    static let disturbances = MeasurementTip(
        id: "disturbances",
        systemImage: "exclamationmark.triangle",
        title: L10n.Education.MeasurementTips.Tip.Disturbances.title,
        subtitle: L10n.Education.MeasurementTips.Tip.Disturbances.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.Disturbances.body1,
            L10n.Education.MeasurementTips.Tip.Disturbances.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.Disturbances.do1,
            L10n.Education.MeasurementTips.Tip.Disturbances.do2
        ],
        donts: [],
        warning: L10n.Education.MeasurementTips.Tip.Disturbances.warning
    )
}

// MARK: - Śluz

extension MeasurementTip {

    static let mucusBasics = MeasurementTip(
        id: "mucus-basics",
        systemImage: "drop.halffull",
        title: L10n.Education.MeasurementTips.Tip.MucusBasics.title,
        subtitle: L10n.Education.MeasurementTips.Tip.MucusBasics.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.MucusBasics.body1,
            L10n.Education.MeasurementTips.Tip.MucusBasics.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.MucusBasics.do1,
            L10n.Education.MeasurementTips.Tip.MucusBasics.do2,
            L10n.Education.MeasurementTips.Tip.MucusBasics.do3
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.MucusBasics.dont1,
            L10n.Education.MeasurementTips.Tip.MucusBasics.dont2
        ],
        warning: nil
    )

    static let mucusObservation = MeasurementTip(
        id: "mucus-observation",
        systemImage: "eye",
        title: L10n.Education.MeasurementTips.Tip.MucusObservation.title,
        subtitle: L10n.Education.MeasurementTips.Tip.MucusObservation.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.MucusObservation.body1,
            L10n.Education.MeasurementTips.Tip.MucusObservation.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.MucusObservation.do1,
            L10n.Education.MeasurementTips.Tip.MucusObservation.do2,
            L10n.Education.MeasurementTips.Tip.MucusObservation.do3
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.MucusObservation.dont1,
            L10n.Education.MeasurementTips.Tip.MucusObservation.dont2
        ],
        warning: L10n.Education.MeasurementTips.Tip.MucusObservation.warning
    )

    static let mucusRecording = MeasurementTip(
        id: "mucus-recording",
        systemImage: "square.and.pencil",
        title: L10n.Education.MeasurementTips.Tip.MucusRecording.title,
        subtitle: L10n.Education.MeasurementTips.Tip.MucusRecording.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.MucusRecording.body1
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.MucusRecording.do1,
            L10n.Education.MeasurementTips.Tip.MucusRecording.do2,
            L10n.Education.MeasurementTips.Tip.MucusRecording.do3
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.MucusRecording.dont1
        ],
        warning: nil
    )
}

// MARK: - Szyjka

extension MeasurementTip {

    static let cervixBasics = MeasurementTip(
        id: "cervix-basics",
        systemImage: "circle.dotted",
        title: L10n.Education.MeasurementTips.Tip.CervixBasics.title,
        subtitle: L10n.Education.MeasurementTips.Tip.CervixBasics.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.CervixBasics.body1,
            L10n.Education.MeasurementTips.Tip.CervixBasics.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.CervixBasics.do1,
            L10n.Education.MeasurementTips.Tip.CervixBasics.do2,
            L10n.Education.MeasurementTips.Tip.CervixBasics.do3
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.CervixBasics.dont1
        ],
        warning: L10n.Education.MeasurementTips.Tip.CervixBasics.warning
    )

    static let cervixTechnique = MeasurementTip(
        id: "cervix-technique",
        systemImage: "hand.point.up",
        title: L10n.Education.MeasurementTips.Tip.CervixTechnique.title,
        subtitle: L10n.Education.MeasurementTips.Tip.CervixTechnique.subtitle,
        bodyParagraphs: [
            L10n.Education.MeasurementTips.Tip.CervixTechnique.body1,
            L10n.Education.MeasurementTips.Tip.CervixTechnique.body2
        ],
        dos: [
            L10n.Education.MeasurementTips.Tip.CervixTechnique.do1,
            L10n.Education.MeasurementTips.Tip.CervixTechnique.do2
        ],
        donts: [
            L10n.Education.MeasurementTips.Tip.CervixTechnique.dont1,
            L10n.Education.MeasurementTips.Tip.CervixTechnique.dont2
        ],
        warning: nil
    )
}
