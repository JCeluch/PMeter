//
//  GlossaryListViewModel.swift
//  PMeter
//
//  Created by JCeluch on 15/06/2026.
//

import Foundation
import Observation

@Observable
final class GlossaryListViewModel {
    var searchText: String = ""
    var selectedCategory: GlossaryCategory? = nil

    private let glossaryService: GlossaryProviding
    private(set) var allEntries: [GlossaryEntry] = []

    init(glossaryService: GlossaryProviding = GlossaryService()) {
        self.glossaryService = glossaryService
        self.allEntries = glossaryService.allEntries()
    }

    var filteredEntries: [GlossaryEntry] {
        allEntries
            .filter(matchesCategory)
            .filter(matchesSearch)
    }

    var groupedEntries: [(category: GlossaryCategory, entries: [GlossaryEntry])] {
        let grouped = Dictionary(grouping: filteredEntries, by: \.category)

        return GlossaryCategory.allCases.compactMap { category in
            guard let entries = grouped[category], !entries.isEmpty else { return nil }
            return (category, entries)
        }
    }

    func entry(for id: String) -> GlossaryEntry? {
        glossaryService.entry(withID: id)
    }

    private func matchesCategory(_ entry: GlossaryEntry) -> Bool {
        guard let selectedCategory else { return true }
        return entry.category == selectedCategory
    }

    private func matchesSearch(_ entry: GlossaryEntry) -> Bool {
        let query = normalized(searchText)
        guard !query.isEmpty else { return true }

        let haystack = normalized(
            [
                entry.searchableTitle,
                entry.searchableShortDefinition,
                entry.category.searchableText,
                entry.tags.map(\.searchableText).joined(separator: " "),
                entry.measurementTips.map(\.searchableText).joined(separator: " "),
                entry.keywords.joined(separator: " ")
            ]
            .joined(separator: " ")
        )

        return haystack.contains(query)
    }

    private func normalized(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
