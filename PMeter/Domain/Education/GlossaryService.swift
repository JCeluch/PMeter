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
            id: "luteal-phase",
            title: L10n.Education.Glossary.Entry.LutealPhase.title,
            shortDefinition: L10n.Education.Glossary.Entry.LutealPhase.short,
            definition: L10n.Education.Glossary.Entry.LutealPhase.definition,
            searchableTitle: L10n.string("education.glossary.entry.luteal-phase.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.luteal-phase.short"),
            category: .cycle,
            tags: [.basics, .fertility, .interpretation],
            relatedEntryIDs: ["fertile-window", "menstrual-cycle", "bbt", "cervical-mucus"],
            measurementTips: [],
            keywords: ["cykl", "hormony", "faza lutealna"]
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
        ),
        GlossaryEntry(
            id: "biphasic-cycle",
            title: L10n.Education.Glossary.Entry.BiphasicCycle.title,
            shortDefinition: L10n.Education.Glossary.Entry.BiphasicCycle.short,
            definition: L10n.Education.Glossary.Entry.BiphasicCycle.definition,
            searchableTitle: L10n.string("education.glossary.entry.biphasic-cycle.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.biphasic-cycle.short"),
            category: .temperature,
            tags: [.interpretation, .chart],
            relatedEntryIDs: ["bbt", "thermal-shift", "luteal-phase"],
            measurementTips: [],
            keywords: ["cykl dwufazowy", "biphasic", "wykres temperatury"]
        ),
        GlossaryEntry(
            id: "follicular-phase",
            title: L10n.Education.Glossary.Entry.FollicularPhase.title,
            shortDefinition: L10n.Education.Glossary.Entry.FollicularPhase.short,
            definition: L10n.Education.Glossary.Entry.FollicularPhase.definition,
            searchableTitle: L10n.string("education.glossary.entry.follicular-phase.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.follicular-phase.short"),
            category: .cycle,
            tags: [.basics, .fertility],
            relatedEntryIDs: ["ovulation", "estrogen", "fsh", "menstrual-cycle"],
            measurementTips: [],
            keywords: ["faza folikularna", "follicular", "pierwsza faza", "estrogen"]
        ),
        GlossaryEntry(
            id: "ovulation",
            title: L10n.Education.Glossary.Entry.Ovulation.title,
            shortDefinition: L10n.Education.Glossary.Entry.Ovulation.short,
            definition: L10n.Education.Glossary.Entry.Ovulation.definition,
            searchableTitle: L10n.string("education.glossary.entry.ovulation.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.ovulation.short"),
            category: .cycle,
            tags: [.basics, .fertility, .interpretation],
            relatedEntryIDs: ["lh", "fertile-window", "peak-day", "corpus-luteum", "bbt"],
            measurementTips: [],
            keywords: ["owulacja", "ovulation", "jajeczko", "jajnik"]
        ),
        GlossaryEntry(
            id: "corpus-luteum",
            title: L10n.Education.Glossary.Entry.CorpusLuteum.title,
            shortDefinition: L10n.Education.Glossary.Entry.CorpusLuteum.short,
            definition: L10n.Education.Glossary.Entry.CorpusLuteum.definition,
            searchableTitle: L10n.string("education.glossary.entry.corpus-luteum.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.corpus-luteum.short"),
            category: .hormones,
            tags: [.basics, .interpretation],
            relatedEntryIDs: ["ovulation", "luteal-phase", "progesterone"],
            measurementTips: [],
            keywords: ["ciałko żółte", "corpus luteum", "progesteron", "luteal"]
        ),
        GlossaryEntry(
            id: "estrogen",
            title: L10n.Education.Glossary.Entry.Estrogen.title,
            shortDefinition: L10n.Education.Glossary.Entry.Estrogen.short,
            definition: L10n.Education.Glossary.Entry.Estrogen.definition,
            searchableTitle: L10n.string("education.glossary.entry.estrogen.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.estrogen.short"),
            category: .hormones,
            tags: [.basics, .fertility],
            relatedEntryIDs: ["follicular-phase", "cervical-mucus", "lh"],
            measurementTips: [],
            keywords: ["estrogen", "estradiol", "hormony", "faza folikularna"]
        ),
        GlossaryEntry(
            id: "progesterone",
            title: L10n.Education.Glossary.Entry.Progesterone.title,
            shortDefinition: L10n.Education.Glossary.Entry.Progesterone.short,
            definition: L10n.Education.Glossary.Entry.Progesterone.definition,
            searchableTitle: L10n.string("education.glossary.entry.progesterone.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.progesterone.short"),
            category: .hormones,
            tags: [.basics, .fertility, .interpretation],
            relatedEntryIDs: ["luteal-phase", "corpus-luteum", "bbt", "thermal-shift"],
            measurementTips: [],
            keywords: ["progesteron", "progesterone", "hormony", "faza lutealna"]
        ),
        GlossaryEntry(
            id: "fsh",
            title: L10n.Education.Glossary.Entry.FSH.title,
            shortDefinition: L10n.Education.Glossary.Entry.FSH.short,
            definition: L10n.Education.Glossary.Entry.FSH.definition,
            searchableTitle: L10n.string("education.glossary.entry.fsh.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.fsh.short"),
            category: .hormones,
            tags: [.basics],
            relatedEntryIDs: ["follicular-phase", "ovulation", "lh"],
            measurementTips: [],
            keywords: ["fsh", "folikulotropina", "hormony", "przysadka"]
        ),
        GlossaryEntry(
            id: "anovulatory-cycle",
            title: L10n.Education.Glossary.Entry.AnovulatoryCycle.title,
            shortDefinition: L10n.Education.Glossary.Entry.AnovulatoryCycle.short,
            definition: L10n.Education.Glossary.Entry.AnovulatoryCycle.definition,
            searchableTitle: L10n.string("education.glossary.entry.anovulatory-cycle.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.anovulatory-cycle.short"),
            category: .interpretation,
            tags: [.interpretation, .chart],
            relatedEntryIDs: ["ovulation", "biphasic-cycle", "bbt"],
            measurementTips: [],
            keywords: ["cykl bezowulacyjny", "anovulatory", "brak owulacji", "jednofazowy"]
        ),
        GlossaryEntry(
            id: "coverline",
            title: L10n.Education.Glossary.Entry.Coverline.title,
            shortDefinition: L10n.Education.Glossary.Entry.Coverline.short,
            definition: L10n.Education.Glossary.Entry.Coverline.definition,
            searchableTitle: L10n.string("education.glossary.entry.coverline.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.coverline.short"),
            category: .interpretation,
            tags: [.chart, .interpretation],
            relatedEntryIDs: ["thermal-shift", "bbt", "biphasic-cycle"],
            measurementTips: [],
            keywords: ["linia pokrycia", "coverline", "wykres", "temperatura"]
        ),
        GlossaryEntry(
            id: "sympto-thermal",
            title: L10n.Education.Glossary.Entry.SymptothermalMethod.title,
            shortDefinition: L10n.Education.Glossary.Entry.SymptothermalMethod.short,
            definition: L10n.Education.Glossary.Entry.SymptothermalMethod.definition,
            searchableTitle: L10n.string("education.glossary.entry.sympto-thermal.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.sympto-thermal.short"),
            category: .methods,
            tags: [.basics, .measurement, .fertility],
            relatedEntryIDs: ["bbt", "cervical-mucus", "cervix", "thermal-shift"],
            measurementTips: [],
            keywords: ["metoda symptotermalna", "STM", "NPR", "temperatura", "śluz"]
        ),
        GlossaryEntry(
            id: "billings",
            title: L10n.Education.Glossary.Entry.BillingsMethod.title,
            shortDefinition: L10n.Education.Glossary.Entry.BillingsMethod.short,
            definition: L10n.Education.Glossary.Entry.BillingsMethod.definition,
            searchableTitle: L10n.string("education.glossary.entry.billings.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.billings.short"),
            category: .methods,
            tags: [.basics, .measurement, .fertility],
            relatedEntryIDs: ["cervical-mucus", "peak-day", "sympto-thermal"],
            measurementTips: [],
            keywords: ["metoda Billingsów", "Billings", "śluz", "owulacja"]
        ),
        GlossaryEntry(
            id: "creighton",
            title: L10n.Education.Glossary.Entry.CreightonModel.title,
            shortDefinition: L10n.Education.Glossary.Entry.CreightonModel.short,
            definition: L10n.Education.Glossary.Entry.CreightonModel.definition,
            searchableTitle: L10n.string("education.glossary.entry.creighton.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.creighton.short"),
            category: .methods,
            tags: [.basics, .measurement, .fertility],
            relatedEntryIDs: ["cervical-mucus", "peak-day", "billings"],
            measurementTips: [],
            keywords: ["Creighton", "model Creightona", "NaProTechnology", "śluz"]
        ),
        GlossaryEntry(
            id: "pms",
            title: L10n.Education.Glossary.Entry.PMS.title,
            shortDefinition: L10n.Education.Glossary.Entry.PMS.short,
            definition: L10n.Education.Glossary.Entry.PMS.definition,
            searchableTitle: L10n.string("education.glossary.entry.pms.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.pms.short"),
            category: .cycle,
            tags: [.symptoms, .interpretation],
            relatedEntryIDs: ["luteal-phase", "progesterone", "menstrual-cycle"],
            measurementTips: [],
            keywords: ["PMS", "zespół napięcia przedmiesiączkowego", "nastrój", "objawy"]
        ),
        GlossaryEntry(
            id: "implantation",
            title: L10n.Education.Glossary.Entry.Implantation.title,
            shortDefinition: L10n.Education.Glossary.Entry.Implantation.short,
            definition: L10n.Education.Glossary.Entry.Implantation.definition,
            searchableTitle: L10n.string("education.glossary.entry.implantation.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.implantation.short"),
            category: .cycle,
            tags: [.fertility, .interpretation],
            relatedEntryIDs: ["luteal-phase", "spotting", "ovulation"],
            measurementTips: [],
            keywords: ["implantacja", "zagnieżdżenie", "zarodek", "ciąża"]
        ),
        GlossaryEntry(
            id: "spotting",
            title: L10n.Education.Glossary.Entry.SpottingEntry.title,
            shortDefinition: L10n.Education.Glossary.Entry.SpottingEntry.short,
            definition: L10n.Education.Glossary.Entry.SpottingEntry.definition,
            searchableTitle: L10n.string("education.glossary.entry.spotting.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.spotting.short"),
            category: .cycle,
            tags: [.symptoms, .interpretation],
            relatedEntryIDs: ["implantation", "menstrual-cycle", "cervix"],
            measurementTips: [],
            keywords: ["plamienie", "spotting", "brunatne", "krwawienie między"]
        ),
        GlossaryEntry(
            id: "breastfeeding",
            title: L10n.Education.Glossary.Entry.Breastfeeding.title,
            shortDefinition: L10n.Education.Glossary.Entry.Breastfeeding.short,
            definition: L10n.Education.Glossary.Entry.Breastfeeding.definition,
            searchableTitle: L10n.string("education.glossary.entry.breastfeeding.title"),
            searchableShortDefinition: L10n.string("education.glossary.entry.breastfeeding.short"),
            category: .cycle,
            tags: [.basics, .fertility],
            relatedEntryIDs: ["anovulatory-cycle", "ovulation", "menstrual-cycle"],
            measurementTips: [],
            keywords: ["karmienie piersią", "laktacja", "prolaktyna", "LAM", "breastfeeding"]
        ),
    ]
    
    func relatedEntries(for entry: GlossaryEntry) -> [GlossaryEntry] {
        entry.relatedEntryIDs.compactMap { self.entry(withID: $0) }
    }
}
