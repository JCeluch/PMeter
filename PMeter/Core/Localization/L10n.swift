//
//  L10n.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import SwiftUI

enum L10n {
    static func key(_ key: String) -> LocalizedStringKey {
            LocalizedStringKey(key)
        }

        static func string(_ key: String) -> String {
            String(localized: String.LocalizationValue(key))
        }
    
    enum Tabs {
        static let cycle: LocalizedStringKey = "tabs.cycle"
        static let calendar: LocalizedStringKey = "tabs.calendar"
        static let stats: LocalizedStringKey = "tabs.stats"
        static let education: LocalizedStringKey = "tabs.education"
        static let settings: LocalizedStringKey = "tabs.settings"
    }

    enum CycleForm {
        static let newEntryTitle: LocalizedStringKey = "cycleForm.newEntryTitle"
        static let editEntryTitle: LocalizedStringKey = "cycleForm.editEntryTitle"
        static let dateSection: LocalizedStringKey = "cycleForm.dateSection"
        static let observationsSection: LocalizedStringKey = "cycleForm.observationsSection"
        static let notesSection: LocalizedStringKey = "cycleForm.notesSection"
        static let observationDate: LocalizedStringKey = "cycleForm.observationDate"
        
        static let bleeding: LocalizedStringKey = "cycleForm.bleeding"
        static let bleedingSection: LocalizedStringKey = "cycleForm.bleedingSection"
        static let bleedingColor: LocalizedStringKey = "cycleForm.bleedingColor"
        static let intermenstrualSpotting: LocalizedStringKey = "cycleForm.intermenstrualSpotting"
    
        static let mucus: LocalizedStringKey = "cycleForm.mucus"
        static let mucusSection: LocalizedStringKey = "cycleForm.mucusSection"
        static let mucusAmount: LocalizedStringKey = "cycleForm.mucusAmount"
        static let mucusSensation: LocalizedStringKey = "cycleForm.mucusSensation"
        static let mucusAppearance: LocalizedStringKey = "cycleForm.mucusAppearance"
        static let mucusStretch: LocalizedStringKey = "cycleForm.mucusStretch"
        static let mucusVolume: LocalizedStringKey = "cycleForm.mucusVolume"
        static let isPeakDay: LocalizedStringKey = "cycleForm.isPeakDay"
        
        static let cervix: LocalizedStringKey = "cycleForm.cervix"
        static let breastTenderness: LocalizedStringKey = "cycleForm.breastTenderness"
        static let temperature: LocalizedStringKey = "cycleForm.temperature"
        static let temperatureSection: LocalizedStringKey = "cycleForm.temperatureSection"
        static let temperatureSite: LocalizedStringKey = "cycleForm.temperatureSite"

        static let lhTest: LocalizedStringKey = "cycleForm.lhTest"
        static let addTemperature: LocalizedStringKey = "cycleForm.addTemperature"
        static let temperaturePlaceholder: LocalizedStringKey = "cycleForm.temperaturePlaceholder"
        static let intercourse: LocalizedStringKey = "cycleForm.intercourse"
        static let notesPlaceholder: LocalizedStringKey = "cycleForm.notesPlaceholder"

        static let temperatureExcluded: LocalizedStringKey = "cycleForm.temperatureExcluded"
        static let bbtDisturbances: LocalizedStringKey = "cycleForm.bbtDisturbances"
        static let cervixSection: LocalizedStringKey = "cycleForm.cervixSection"
        static let cervixPosition: LocalizedStringKey = "cycleForm.cervixPosition"
        static let cervixFirmness: LocalizedStringKey = "cycleForm.cervixFirmness"
        static let cervixOpening: LocalizedStringKey = "cycleForm.cervixOpening"
        static let testsSection: LocalizedStringKey = "cycleForm.testsSection"
        static let symptomsSection: LocalizedStringKey = "cycleForm.symptomsSection"
        static let ovulationPain: LocalizedStringKey = "cycleForm.ovulationPain"
        static let ovulationPainSide: LocalizedStringKey = "cycleForm.ovulationPainSide"
        static let menstrualPain: LocalizedStringKey = "cycleForm.menstrualPain"
        static let otherSection: LocalizedStringKey = "cycleForm.otherSection"
        static let isBreastfeeding: LocalizedStringKey = "cycleForm.isBreastfeeding"
    }

    enum CycleList {
        static let title: LocalizedStringKey = "cycleList.title"
        static let emptyTitle: LocalizedStringKey = "cycleList.empty.title"
        static let emptySubtitle: LocalizedStringKey = "cycleList.empty.subtitle"
        static let add: LocalizedStringKey = "cycleList.add"
        static let recentEntries: LocalizedStringKey = "cycleList.recentEntries"
        static let lhTestPrefix: LocalizedStringKey = "cycleList.lhTestPrefix"
        static let intercourseSaved: LocalizedStringKey = "cycleList.intercourseSaved"
        static let temperaturePrefix: LocalizedStringKey = "cycleList.temperaturePrefix"
        static let delete: LocalizedStringKey = "common.delete"
    }

    enum CycleDetail {
        static let title: LocalizedStringKey = "cycleDetail.title"
        static let dateSection: LocalizedStringKey = "cycleDetail.dateSection"
        static let observationsSection: LocalizedStringKey = "cycleDetail.observationsSection"
        static let notesSection: LocalizedStringKey = "cycleDetail.notesSection"
        static let day: LocalizedStringKey = "cycleDetail.day"
        static let bleeding: LocalizedStringKey = "cycleDetail.bleeding"
        static let mucus: LocalizedStringKey = "cycleDetail.mucus"
        static let mucusAmount: LocalizedStringKey = "cycleDetail.mucusAmount"
        static let cervix: LocalizedStringKey = "cycleDetail.cervix"
        static let breastTenderness: LocalizedStringKey = "cycleDetail.breastTenderness"
        static let lhTest: LocalizedStringKey = "cycleDetail.lhTest"
        static let intercourse: LocalizedStringKey = "cycleDetail.intercourse"
        static let temperature: LocalizedStringKey = "cycleDetail.temperature"
        static let noNotes: LocalizedStringKey = "cycleDetail.noNotes"
        static let deleteEntry: LocalizedStringKey = "cycleDetail.deleteEntry"
        static let deleteConfirmTitle: LocalizedStringKey = "cycleDetail.deleteConfirmTitle"
        static let deleteConfirmMessage: LocalizedStringKey = "cycleDetail.deleteConfirmMessage"
    }

    enum Calendar {
        static let title: LocalizedStringKey = "calendar.title"
        static let emptyTitle: LocalizedStringKey = "calendar.empty.title"
        static let emptyDescription: LocalizedStringKey = "calendar.empty.description"
        static let detailsTitle: LocalizedStringKey = "calendar.detailsTitle"
        static let daySection: LocalizedStringKey = "calendar.daySection"
        static let dayLabel: LocalizedStringKey = "calendar.dayLabel"
        static let cycleDay: LocalizedStringKey = "calendar.cycleDay"
        static let noData: LocalizedStringKey = "calendar.noData"
        static let entries: LocalizedStringKey = "calendar.entries"
        static let noEntriesForDay: LocalizedStringKey = "calendar.noEntriesForDay"
        static let previewTitle: LocalizedStringKey = "calendar.previewTitle"
        static let previewNoData: LocalizedStringKey = "calendar.previewNoData"
        static let previewDescription: LocalizedStringKey = "calendar.previewDescription"
        static let chartTitle: LocalizedStringKey = "calendar.mode.chart"
    }

    enum Settings {
        static let title: LocalizedStringKey = "settings.title"
        static let appSection: LocalizedStringKey = "settings.appSection"
        static let methodSection: LocalizedStringKey = "settings.methodSection"
        static let dataPrivacyTitle: LocalizedStringKey = "settings.dataPrivacyTitle"
        static let dataPrivacySubtitle: LocalizedStringKey = "settings.dataPrivacySubtitle"
        static let healthIntegrationTitle: LocalizedStringKey = "settings.healthIntegrationTitle"
        static let healthIntegrationSubtitle: LocalizedStringKey = "settings.healthIntegrationSubtitle"
        static let observationMethodTitle: LocalizedStringKey = "settings.observationMethodTitle"
        static let observationMethodSubtitle: LocalizedStringKey = "settings.observationMethodSubtitle"
    }
    
    enum Common {
        static let save: LocalizedStringKey = "common.save"
        static let cancel: LocalizedStringKey = "common.cancel"
        static let edit: LocalizedStringKey = "common.edit"
        static let delete: LocalizedStringKey = "common.delete"
        static let yes: LocalizedStringKey = "common.yes"
        static let no: LocalizedStringKey = "common.no"
        static let done: LocalizedStringKey = "common.done"
        static let none: LocalizedStringKey = "common.none"
    }
    
    enum ChartEnums {
        static let dateShort: LocalizedStringKey = "calendar.chart.dateShort"
        static let bleedingShort: LocalizedStringKey = "calendar.chart.bleedingShort"
        static let mucusShort: LocalizedStringKey = "calendar.chart.mucusShort"
        static let intercourseShort: LocalizedStringKey = "calendar.chart.intercourseShort"
        static let temperatureShort: LocalizedStringKey = "calendar.chart.temperatureShort"
        static let tempUnit: LocalizedStringKey = "calendar.chart.tempUnit"
        static let cycleDayLabel: LocalizedStringKey = "calendar.cycleDay.label"
        static let temperature: LocalizedStringKey = "calendar.chart.temperature"
    }
    
    enum BleedingSymbols {
        static let none: LocalizedStringKey = "bleeding.symbols.none"
        static let spotting: LocalizedStringKey = "bleeding.symbols.spotting"
        static let light: LocalizedStringKey = "bleeding.symbols.light"
        static let medium: LocalizedStringKey = "bleeding.symbols.medium"
        static let heavy: LocalizedStringKey = "bleeding.symbols.heavy"
    }
    
    enum MucusSymbols {
        static let none: LocalizedStringKey = "mucus.symbols.none"
        static let dry: LocalizedStringKey = "mucus.symbols.dry"
        static let sticky: LocalizedStringKey = "mucus.symbols.sticky"
        static let creamy: LocalizedStringKey = "mucus.symbols.creamy"
        static let watery: LocalizedStringKey = "mucus.symbols.watery"
        static let eggWhite: LocalizedStringKey = "mucus.symbols.eggWhite"
    }
    
    enum LHSymbols {
        static let none: LocalizedStringKey = "lh.symbols.none"
        static let negative: LocalizedStringKey = "lh.symbols.negative"
        static let positive: LocalizedStringKey = "lh.symbols.positive"
        static let peak: LocalizedStringKey = "lh.symbols.peak"
    }
}

extension L10n {
    enum Education {
        enum Home {
            static let title = key("education.home.title")
            static let glossarySubtitle = key("education.home.glossary.subtitle")
        }
        
        enum Glossary {
            static let title = key("education.glossary.title")
            static let searchPlaceholder = key("education.glossary.search.placeholder")
            static let emptyTitle = key("education.glossary.empty.title")
            static let emptyMessage = key("education.glossary.empty.message")
            static let allCategories = key("education.glossary.category.all")
            static let tips = key("education.glossary.detail.tips")
            static let related = key("education.glossary.detail.related")
            static let tags = key("education.glossary.detail.tags")

            enum Category {
                static let cycle = key("education.glossary.category.cycle")
                static let temperature = key("education.glossary.category.temperature")
                static let mucus = key("education.glossary.category.mucus")
                static let cervix = key("education.glossary.category.cervix")
                static let hormones = key("education.glossary.category.hormones")
                static let interpretation = key("education.glossary.category.interpretation")
                static let methods = key("education.glossary.category.methods")
            }

            enum Tag {
                static let basics = key("education.glossary.tag.basics")
                static let measurement = key("education.glossary.tag.measurement")
                static let fertility = key("education.glossary.tag.fertility")
                static let interpretation = key("education.glossary.tag.interpretation")
                static let chart = key("education.glossary.tag.chart")
                static let symptoms = key("education.glossary.tag.symptoms")
            }

            enum Entry {
                enum BBT {
                    static let title = key("education.glossary.entry.bbt.title")
                    static let short = key("education.glossary.entry.bbt.short")
                    static let definition = key("education.glossary.entry.bbt.definition")
                    static let tip1 = key("education.glossary.entry.bbt.tip.1")
                    static let tip2 = key("education.glossary.entry.bbt.tip.2")
                    static let tip3 = key("education.glossary.entry.bbt.tip.3")
                }

                enum PeakDay {
                    static let title = key("education.glossary.entry.peak-day.title")
                    static let short = key("education.glossary.entry.peak-day.short")
                    static let definition = key("education.glossary.entry.peak-day.definition")
                    static let tip1 = key("education.glossary.entry.peak-day.tip.1")
                }

                enum LH {
                    static let title = key("education.glossary.entry.lh.title")
                    static let short = key("education.glossary.entry.lh.short")
                    static let definition = key("education.glossary.entry.lh.definition")
                    static let tip1 = key("education.glossary.entry.lh.tip.1")
                    static let tip2 = key("education.glossary.entry.lh.tip.2")
                    static let tip3 = key("education.glossary.entry.lh.tip.3")
                }

                enum CervicalMucus {
                    static let title = key("education.glossary.entry.cervical-mucus.title")
                    static let short = key("education.glossary.entry.cervical-mucus.short")
                    static let definition = key("education.glossary.entry.cervical-mucus.definition")
                    static let tip1 = key("education.glossary.entry.cervical-mucus.tip.1")
                    static let tip2 = key("education.glossary.entry.cervical-mucus.tip.2")
                    static let tip3 = key("education.glossary.entry.cervical-mucus.tip.3")
                }

                enum Cervix {
                    static let title = key("education.glossary.entry.cervix.title")
                    static let short = key("education.glossary.entry.cervix.short")
                    static let definition = key("education.glossary.entry.cervix.definition")
                    static let tip1 = key("education.glossary.entry.cervix.tip.1")
                    static let tip2 = key("education.glossary.entry.cervix.tip.2")
                    static let tip3 = key("education.glossary.entry.cervix.tip.3")
                }

                enum SHOW {
                    static let title = key("education.glossary.entry.show.title")
                    static let short = key("education.glossary.entry.show.short")
                    static let definition = key("education.glossary.entry.show.definition")
                }

                enum FertileWindow {
                    static let title = key("education.glossary.entry.fertile-window.title")
                    static let short = key("education.glossary.entry.fertile-window.short")
                    static let definition = key("education.glossary.entry.fertile-window.definition")
                }

                enum ThermalShift {
                    static let title = key("education.glossary.entry.thermal-shift.title")
                    static let short = key("education.glossary.entry.thermal-shift.short")
                    static let definition = key("education.glossary.entry.thermal-shift.definition")
                }

                enum BiphasicCycle {
                    static let title = key("education.glossary.entry.biphasic-cycle.title")
                    static let short = key("education.glossary.entry.biphasic-cycle.short")
                    static let definition = key("education.glossary.entry.biphasic-cycle.definition")
                }

                enum LutealPhase {
                    static let title = key("education.glossary.entry.luteal-phase.title")
                    static let short = key("education.glossary.entry.luteal-phase.short")
                    static let definition = key("education.glossary.entry.luteal-phase.definition")
                }
            }

        }
    }
}
