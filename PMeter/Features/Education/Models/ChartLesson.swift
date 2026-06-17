//
//  ChartLesson.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import SwiftUI

struct ChartLesson: Identifiable {
    let id: String
    let systemImage: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let asciiChart: String?
    let bodyParagraphs: [LocalizedStringKey]
    let keyPoints: [LocalizedStringKey]
    let warning: LocalizedStringKey?
}

// MARK: - Lesson Collections

extension ChartLesson {

    // MARK: Podstawy

    static let basics: [ChartLesson] = [
        .whatIsChart,
        .howToReadTemperature,
        .howToReadMucus
    ]

    // MARK: Interpretacja

    static let interpretation: [ChartLesson] = [
        .biphasicChart,
        .thermalShift,
        .coverline,
        .peakDay
    ]

    // MARK: Zaburzenia i wyjątki

    static let disturbances: [ChartLesson] = [
        .disturbedTemperature,
        .anovulatoryChart,
        .irregularCycle
    ]
}

// MARK: - Podstawy

extension ChartLesson {

    static let whatIsChart = ChartLesson(
        id: "what-is-chart",
        systemImage: "chart.xyaxis.line",
        title: "education.chart-guide.lesson.what-is-chart.title",
        subtitle: "education.chart-guide.lesson.what-is-chart.subtitle",
        asciiChart: """
        °C  │
        37.0│                    · · · · ·
        36.8│              ·  ·
        36.6│  · · · · · ·
        36.4│
            └─────────────────────────────
              1   5   9  13  17  21  25  28
        """,
        bodyParagraphs: [
            L10n.Education.ChartGuide.Lesson.WhatIsChart.body1,
            L10n.Education.ChartGuide.Lesson.WhatIsChart.body2
        ],
        keyPoints: [
            L10n.Education.ChartGuide.Lesson.WhatIsChart.point1,
            L10n.Education.ChartGuide.Lesson.WhatIsChart.point2,
            L10n.Education.ChartGuide.Lesson.WhatIsChart.point3
        ],
        warning: nil
    )

    static let howToReadTemperature = ChartLesson(
        id: "how-to-read-temperature",
        systemImage: "thermometer.medium",
        title: "education.chart-guide.lesson.temperature.title",
        subtitle: "education.chart-guide.lesson.temperature.subtitle",
        asciiChart: nil,
        bodyParagraphs: [
            "education.chart-guide.lesson.temperature.body1",
            "education.chart-guide.lesson.temperature.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.temperature.point1",
            "education.chart-guide.lesson.temperature.point2",
            "education.chart-guide.lesson.temperature.point3"
        ],
        warning: "education.chart-guide.lesson.temperature.warning"
    )

    static let howToReadMucus = ChartLesson(
        id: "how-to-read-mucus",
        systemImage: "drop.halffull",
        title: "education.chart-guide.lesson.mucus.title",
        subtitle: "education.chart-guide.lesson.mucus.subtitle",
        asciiChart: nil,
        bodyParagraphs: [
            "education.chart-guide.lesson.mucus.body1",
            "education.chart-guide.lesson.mucus.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.mucus.point1",
            "education.chart-guide.lesson.mucus.point2",
            "education.chart-guide.lesson.mucus.point3",
            "education.chart-guide.lesson.mucus.point4"
        ],
        warning: nil
    )
}

// MARK: - Interpretacja

extension ChartLesson {

    static let biphasicChart = ChartLesson(
        id: "biphasic-chart",
        systemImage: "waveform.path",
        title: "education.chart-guide.lesson.biphasic.title",
        subtitle: "education.chart-guide.lesson.biphasic.subtitle",
        asciiChart: """
        °C  │          FAZA I          │       FAZA II
        37.1│                          │  · · · · · · ·
        36.9│                      ·   │·
        36.7│          · · · · · ·     │
        36.5│· · · · ·                 │
            └──────────────────────────┼──────────────
              1   5   9  13      owul. 17  21  25  28
        """,
        bodyParagraphs: [
            "education.chart-guide.lesson.biphasic.body1",
            "education.chart-guide.lesson.biphasic.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.biphasic.point1",
            "education.chart-guide.lesson.biphasic.point2",
            "education.chart-guide.lesson.biphasic.point3"
        ],
        warning: nil
    )

    static let thermalShift = ChartLesson(
        id: "thermal-shift",
        systemImage: "arrow.up.right",
        title: "education.chart-guide.lesson.thermal-shift.title",
        subtitle: "education.chart-guide.lesson.thermal-shift.subtitle",
        asciiChart: """
        °C  │
        37.0│                     [3] [4] [5]
        36.9│                [2]
        36.8│           [1]       ← linia pokrycia: 36.85
        36.7│  · · · · ·
            └─────────────────────────────
        """,
        bodyParagraphs: [
            "education.chart-guide.lesson.thermal-shift.body1",
            "education.chart-guide.lesson.thermal-shift.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.thermal-shift.point1",
            "education.chart-guide.lesson.thermal-shift.point2",
            "education.chart-guide.lesson.thermal-shift.point3"
        ],
        warning: "education.chart-guide.lesson.thermal-shift.warning"
    )

    static let coverline = ChartLesson(
        id: "coverline",
        systemImage: "minus.forwardslash.plus",
        title: "education.chart-guide.lesson.coverline.title",
        subtitle: "education.chart-guide.lesson.coverline.subtitle",
        asciiChart: """
        °C  │
        37.0│                    · · · · ·
        36.85│ · · · · · · ─ ─ ─ ─ ─ ─ ─  ← linia pokrycia
        36.7│
            └─────────────────────────────
        """,
        bodyParagraphs: [
            "education.chart-guide.lesson.coverline.body1",
            "education.chart-guide.lesson.coverline.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.coverline.point1",
            "education.chart-guide.lesson.coverline.point2"
        ],
        warning: nil
    )

    static let peakDay = ChartLesson(
        id: "peak-day",
        systemImage: "star.circle",
        title: "education.chart-guide.lesson.peak-day.title",
        subtitle: "education.chart-guide.lesson.peak-day.subtitle",
        asciiChart: nil,
        bodyParagraphs: [
            "education.chart-guide.lesson.peak-day.body1",
            "education.chart-guide.lesson.peak-day.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.peak-day.point1",
            "education.chart-guide.lesson.peak-day.point2",
            "education.chart-guide.lesson.peak-day.point3"
        ],
        warning: nil
    )
}

// MARK: - Zaburzenia

extension ChartLesson {

    static let disturbedTemperature = ChartLesson(
        id: "disturbed-temperature",
        systemImage: "exclamationmark.triangle",
        title: "education.chart-guide.lesson.disturbed.title",
        subtitle: "education.chart-guide.lesson.disturbed.subtitle",
        asciiChart: """
        °C  │
        37.4│         ⚠ (choroba)
        37.0│                    · · · · ·
        36.8│                ·
        36.6│  · · · · · · ·
            └─────────────────────────────
        """,
        bodyParagraphs: [
            "education.chart-guide.lesson.disturbed.body1",
            "education.chart-guide.lesson.disturbed.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.disturbed.point1",
            "education.chart-guide.lesson.disturbed.point2",
            "education.chart-guide.lesson.disturbed.point3"
        ],
        warning: "education.chart-guide.lesson.disturbed.warning"
    )

    static let anovulatoryChart = ChartLesson(
        id: "anovulatory-chart",
        systemImage: "waveform.path.badge.minus",
        title: "education.chart-guide.lesson.anovulatory.title",
        subtitle: "education.chart-guide.lesson.anovulatory.subtitle",
        asciiChart: """
        °C  │
        36.8│  · ·  · · · · · · · · · · ·  ← brak skoku
        36.6│      ·
        36.4│
            └─────────────────────────────
              1   5   9  13  17  21  25  28
        """,
        bodyParagraphs: [
            "education.chart-guide.lesson.anovulatory.body1",
            "education.chart-guide.lesson.anovulatory.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.anovulatory.point1",
            "education.chart-guide.lesson.anovulatory.point2"
        ],
        warning: "education.chart-guide.lesson.anovulatory.warning"
    )

    static let irregularCycle = ChartLesson(
        id: "irregular-cycle",
        systemImage: "arrow.left.arrow.right",
        title: "education.chart-guide.lesson.irregular.title",
        subtitle: "education.chart-guide.lesson.irregular.subtitle",
        asciiChart: nil,
        bodyParagraphs: [
            "education.chart-guide.lesson.irregular.body1",
            "education.chart-guide.lesson.irregular.body2"
        ],
        keyPoints: [
            "education.chart-guide.lesson.irregular.point1",
            "education.chart-guide.lesson.irregular.point2",
            "education.chart-guide.lesson.irregular.point3"
        ],
        warning: nil
    )
}
