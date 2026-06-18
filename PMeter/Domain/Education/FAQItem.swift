//
//  FAQItem.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import Foundation

struct FAQItem: Identifiable, Hashable {
    let id: String
    let category: FAQCategory
    let questionKey: String
    let answerKey: String
}

enum FAQCategory: String, CaseIterable, Identifiable {
    case basics
    case observations
    case interpretation

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .basics: "education.faq.category.basics"
        case .observations: "education.faq.category.observations"
        case .interpretation: "education.faq.category.interpretation"
        }
    }
}
