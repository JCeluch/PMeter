//
//  GlossaryModels.swift
//  PMeter
//
//  Created by JCeluch on 15/06/2026.
//

import Foundation
import SwiftUI

enum GlossaryCategory: String, CaseIterable, Identifiable {
    case cycle
    case temperature
    case mucus
    case cervix
    case hormones
    case interpretation
    case methods

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .cycle:
            return L10n.Education.Glossary.Category.cycle
        case .temperature:
            return L10n.Education.Glossary.Category.temperature
        case .mucus:
            return L10n.Education.Glossary.Category.mucus
        case .cervix:
            return L10n.Education.Glossary.Category.cervix
        case .hormones:
            return L10n.Education.Glossary.Category.hormones
        case .interpretation:
            return L10n.Education.Glossary.Category.interpretation
        case .methods:
            return L10n.Education.Glossary.Category.methods
        }
    }

    var searchableText: String {
        switch self {
        case .cycle:
            return L10n.string("education.glossary.category.cycle")
        case .temperature:
            return L10n.string("education.glossary.category.temperature")
        case .mucus:
            return L10n.string("education.glossary.category.mucus")
        case .cervix:
            return L10n.string("education.glossary.category.cervix")
        case .hormones:
            return L10n.string("education.glossary.category.hormones")
        case .interpretation:
            return L10n.string("education.glossary.category.interpretation")
        case .methods:
            return L10n.string("education.glossary.category.methods")
        }
    }

    var systemImage: String {
        switch self {
        case .cycle:
            return "calendar"
        case .temperature:
            return "thermometer.medium"
        case .mucus:
            return "drop"
        case .cervix:
            return "circle.dotted"
        case .hormones:
            return "testtube.2"
        case .interpretation:
            return "waveform.path.ecg"
        case .methods:
            return "book"
        }
    }
}

enum GlossaryTag: String, CaseIterable, Identifiable {
    case basics
    case measurement
    case fertility
    case interpretation
    case chart
    case symptoms

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .basics:
            return L10n.Education.Glossary.Tag.basics
        case .measurement:
            return L10n.Education.Glossary.Tag.measurement
        case .fertility:
            return L10n.Education.Glossary.Tag.fertility
        case .interpretation:
            return L10n.Education.Glossary.Tag.interpretation
        case .chart:
            return L10n.Education.Glossary.Tag.chart
        case .symptoms:
            return L10n.Education.Glossary.Tag.symptoms
        }
    }

    var searchableText: String {
        switch self {
        case .basics:
            return L10n.string("education.glossary.tag.basics")
        case .measurement:
            return L10n.string("education.glossary.tag.measurement")
        case .fertility:
            return L10n.string("education.glossary.tag.fertility")
        case .interpretation:
            return L10n.string("education.glossary.tag.interpretation")
        case .chart:
            return L10n.string("education.glossary.tag.chart")
        case .symptoms:
            return L10n.string("education.glossary.tag.symptoms")
        }
    }
}

struct GlossaryMeasurementTip: Identifiable {
    let id: String
    let text: LocalizedStringKey
    let searchableText: String
}

struct GlossaryEntry: Identifiable {
    let id: String
    let title: LocalizedStringKey
    let shortDefinition: LocalizedStringKey
    let definition: LocalizedStringKey
    let searchableTitle: String
    let searchableShortDefinition: String
    let category: GlossaryCategory
    let tags: [GlossaryTag]
    let relatedEntryIDs: [String]
    let measurementTips: [GlossaryMeasurementTip]
    let keywords: [String]
}
