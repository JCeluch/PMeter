//
//  GlossaryService.swift
//  PMeter
//
//  Created by JCeluch on 15/06/2026.
//

import Foundation

protocol GlossaryProviding {
    func allEntries() -> [GlossaryEntry]
    func entry(withID id: String) -> GlossaryEntry?
}

struct GlossaryService: GlossaryProviding {
    func allEntries() -> [GlossaryEntry] {
        Self.entries.sorted { $0.searchableTitle < $1.searchableTitle }
    }

    func entry(withID id: String) -> GlossaryEntry? {
        Self.entries.first(where: { $0.id == id })
    }
}

extension GlossaryService {
    static let shared = GlossaryService()
    
    static let entries: [GlossaryEntry] = [
        GlossaryEntry(
            id: "menstrual-cycle",
            title: L10n.Education.Glossary.Entry.MenstrualCycle.title,
            shortDefinition: L10n.Education.Glossary.Entry.MenstrualCycle.short,
            definition: L10n.Education.Glossary.Entry.MenstrualCycle.definition,
            searchableTitle: L10n.string("education.glossary.entry.menstrual-cycle.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.menstrual-cycle.short"),
            category: .cycle,
            tags: [.basics, .fertility, .interpretation],
            relatedEntryIDs: ["fertile-window", "luteal-phase", "bbt"],
            measurementTips: [],
            keywords: ["cykl", "menstruacja", "okres", "miesiączka", "cycle", "menstrual"]
        ),
        GlossaryEntry(
            id: "bbt",
            title: L10n.Education.Glossary.Entry.BBT.title,
            shortDefinition: L10n.Education.Glossary.Entry.BBT.short,
            definition: L10n.Education.Glossary.Entry.BBT.definition,
            searchableTitle: L10n.string("education.glossary.entry.bbt.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.bbt.short"),
            category: .temperature,
            tags: [.basics, .measurement, .chart],
            relatedEntryIDs: ["thermal-shift", "biphasic-cycle", "luteal-phase"],
            measurementTips: [
                .init(
                    id: "bbt.tip.1",
                    text: L10n.Education.Glossary.Entry.BBT.tip1,
                    searchableText: L10n.string("education.glossary.entry.bbt.tip.1")
                ),
                .init(
                    id: "bbt.tip.2",
                    text: L10n.Education.Glossary.Entry.BBT.tip2,
                    searchableText: L10n.string("education.glossary.entry.bbt.tip.2")
                ),
                .init(
                    id: "bbt.tip.3",
                    text: L10n.Education.Glossary.Entry.BBT.tip3,
                    searchableText: L10n.string("education.glossary.entry.bbt.tip.3")
                )
            ],
            keywords: ["bbt", "ptc", "temperatura", "termometr"]
        ),
        GlossaryEntry(
            id: "peak-day",
            title: L10n.Education.Glossary.Entry.PeakDay.title,
            shortDefinition: L10n.Education.Glossary.Entry.PeakDay.short,
            definition: L10n.Education.Glossary.Entry.PeakDay.definition,
            searchableTitle: L10n.string("education.glossary.entry.peak-day.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.peak-day.short"),
            category: .mucus,
            tags: [.fertility, .interpretation],
            relatedEntryIDs: ["cervical-mucus", "fertile-window", "lh"],
            measurementTips: [
                .init(
                    id: "peak.tip.1",
                    text: L10n.Education.Glossary.Entry.PeakDay.tip1,
                    searchableText: L10n.string("education.glossary.entry.peak-day.tip.1")
                )
            ],
            keywords: ["peak", "peak day", "dzień szczytowy"]
        ),
        GlossaryEntry(
            id: "lh",
            title: L10n.Education.Glossary.Entry.LH.title,
            shortDefinition: L10n.Education.Glossary.Entry.LH.short,
            definition: L10n.Education.Glossary.Entry.LH.definition,
            searchableTitle: L10n.string("education.glossary.entry.lh.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.lh.short"),
            category: .hormones,
            tags: [.measurement, .fertility],
            relatedEntryIDs: ["fertile-window", "peak-day"],
            measurementTips: [
                .init(
                    id: "lh.tip.1",
                    text: L10n.Education.Glossary.Entry.LH.tip1,
                    searchableText: L10n.string("education.glossary.entry.lh.tip.1")
                ),
                .init(
                    id: "lh.tip.2",
                    text: L10n.Education.Glossary.Entry.LH.tip2,
                    searchableText: L10n.string("education.glossary.entry.lh.tip.2")
                ),
                .init(
                    id: "lh.tip.3",
                    text: L10n.Education.Glossary.Entry.LH.tip3,
                    searchableText: L10n.string("education.glossary.entry.lh.tip.3")
                )
            ],
            keywords: ["lh", "test owulacyjny", "surge", "peak"]
        ),
        GlossaryEntry(
            id: "cervical-mucus",
            title: L10n.Education.Glossary.Entry.CervicalMucus.title,
            shortDefinition: L10n.Education.Glossary.Entry.CervicalMucus.short,
            definition: L10n.Education.Glossary.Entry.CervicalMucus.definition,
            searchableTitle: L10n.string("education.glossary.entry.cervical-mucus.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.cervical-mucus.short"),
            category: .mucus,
            tags: [.basics, .measurement, .fertility],
            relatedEntryIDs: ["peak-day", "fertile-window", "show"],
            measurementTips: [
                .init(
                    id: "mucus.tip.1",
                    text: L10n.Education.Glossary.Entry.CervicalMucus.tip1,
                    searchableText: L10n.string("education.glossary.entry.cervical-mucus.tip.1")
                ),
                .init(
                    id: "mucus.tip.2",
                    text: L10n.Education.Glossary.Entry.CervicalMucus.tip2,
                    searchableText: L10n.string("education.glossary.entry.cervical-mucus.tip.2")
                ),
                .init(
                    id: "mucus.tip.3",
                    text: L10n.Education.Glossary.Entry.CervicalMucus.tip3,
                    searchableText: L10n.string("education.glossary.entry.cervical-mucus.tip.3")
                )
            ],
            keywords: ["śluz", "mucus", "sucho", "mokro", "ślisko"]
        ),
        GlossaryEntry(
            id: "cervix",
            title: L10n.Education.Glossary.Entry.Cervix.title,
            shortDefinition: L10n.Education.Glossary.Entry.Cervix.short,
            definition: L10n.Education.Glossary.Entry.Cervix.definition,
            searchableTitle: L10n.string("education.glossary.entry.cervix.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.cervix.short"),
            category: .cervix,
            tags: [.measurement, .fertility],
            relatedEntryIDs: ["show", "cervical-mucus"],
            measurementTips: [
                .init(
                    id: "cervix.tip.1",
                    text: L10n.Education.Glossary.Entry.Cervix.tip1,
                    searchableText: L10n.string("education.glossary.entry.cervix.tip.1")
                ),
                .init(
                    id: "cervix.tip.2",
                    text: L10n.Education.Glossary.Entry.Cervix.tip2,
                    searchableText: L10n.string("education.glossary.entry.cervix.tip.2")
                ),
                .init(
                    id: "cervix.tip.3",
                    text: L10n.Education.Glossary.Entry.Cervix.tip3,
                    searchableText: L10n.string("education.glossary.entry.cervix.tip.3")
                )
            ],
            keywords: ["szyjka", "pozycja szyjki", "miękkość", "otwartość"]
        ),
        GlossaryEntry(
            id: "show",
            title: L10n.Education.Glossary.Entry.SHOW.title,
            shortDefinition: L10n.Education.Glossary.Entry.SHOW.short,
            definition: L10n.Education.Glossary.Entry.SHOW.definition,
            searchableTitle: L10n.string("education.glossary.entry.show.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.show.short"),
            category: .cervix,
            tags: [.fertility, .interpretation],
            relatedEntryIDs: ["cervix", "fertile-window"],
            measurementTips: [],
            keywords: ["show", "soft", "high", "open", "wet"]
        ),
        GlossaryEntry(
            id: "fertile-window",
            title: L10n.Education.Glossary.Entry.FertileWindow.title,
            shortDefinition: L10n.Education.Glossary.Entry.FertileWindow.short,
            definition: L10n.Education.Glossary.Entry.FertileWindow.definition,
            searchableTitle: L10n.string("education.glossary.entry.fertile-window.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.fertile-window.short"),
            category: .cycle,
            tags: [.basics, .fertility, .interpretation],
            relatedEntryIDs: ["peak-day", "lh", "cervical-mucus"],
            measurementTips: [],
            keywords: ["okno płodności", "dni płodne"]
        ),
        GlossaryEntry(
            id: "thermal-shift",
            title: L10n.Education.Glossary.Entry.ThermalShift.title,
            shortDefinition: L10n.Education.Glossary.Entry.ThermalShift.short,
            definition: L10n.Education.Glossary.Entry.ThermalShift.definition,
            searchableTitle: L10n.string("education.glossary.entry.thermal-shift.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.thermal-shift.short"),
            category: .interpretation,
            tags: [.chart, .interpretation],
            relatedEntryIDs: ["bbt", "biphasic-cycle", "luteal-phase"],
            measurementTips: [],
            keywords: ["skok termiczny", "wykres", "temperatura"]
        )
    ]
    
    func relatedEntries(for entry: GlossaryEntry) -> [GlossaryEntry] {
        entry.relatedEntryIDs.compactMap { self.entry(withID: $0) }
    }
}
