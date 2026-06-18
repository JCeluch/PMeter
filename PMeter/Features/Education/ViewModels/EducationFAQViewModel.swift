//
//  EducationFAQViewModel.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//


import Foundation

@MainActor
final class EducationFAQViewModel: ObservableObject {
    @Published var expandedIDs: Set<String> = []

    let items: [FAQItem] = [
        .init(id: "fertile-vs-ovulation", category: .basics,
              questionKey: "education.faq.fertile_vs_ovulation.q",
              answerKey: "education.faq.fertile_vs_ovulation.a"),
        .init(id: "prediction-certainty", category: .interpretation,
              questionKey: "education.faq.prediction_certainty.q",
              answerKey: "education.faq.prediction_certainty.a"),
        .init(id: "bbt-how-to-measure", category: .observations,
              questionKey: "education.faq.bbt_measurement.q",
              answerKey: "education.faq.bbt_measurement.a"),
        .init(id: "bbt-disturbances", category: .observations,
              questionKey: "education.faq.bbt_disturbances.q",
              answerKey: "education.faq.bbt_disturbances.a"),
        .init(id: "fertile-mucus", category: .observations,
              questionKey: "education.faq.fertile_mucus.q",
              answerKey: "education.faq.fertile_mucus.a"),
        .init(id: "lh-test", category: .observations,
              questionKey: "education.faq.lh_test.q",
              answerKey: "education.faq.lh_test.a"),
        .init(id: "spotting-bleeding", category: .observations,
              questionKey: "education.faq.spotting_bleeding.q",
              answerKey: "education.faq.spotting_bleeding.a"),
        .init(id: "irregular-cycles", category: .basics,
              questionKey: "education.faq.irregular_cycles.q",
              answerKey: "education.faq.irregular_cycles.a")
    ]

    var groupedItems: [(category: FAQCategory, items: [FAQItem])] {
        FAQCategory.allCases.map { category in
            (category, items.filter { $0.category == category })
        }.filter { !$0.items.isEmpty }
    }

    func isExpanded(_ id: String) -> Bool {
        expandedIDs.contains(id)
    }

    func toggle(_ id: String) {
        if expandedIDs.contains(id) {
            expandedIDs.remove(id)
        } else {
            expandedIDs.insert(id)
        }
    }
}