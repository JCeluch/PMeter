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
        static let cervixBleedingWarning: LocalizedStringKey = "cycleForm.cervixBleedingWarning"
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
            static let title: LocalizedStringKey = "education.home.title"
            static let chartGuideSubtitle: LocalizedStringKey = "education.home.chart-guide.subtitle"
            static let measurementTipsSubtitle: LocalizedStringKey = "education.home.measurement-tips.subtitle"
            static let nprMethodsSubtitle: LocalizedStringKey = "education.home.npr-methods.subtitle"
            static let glossarySubtitle: LocalizedStringKey = "education.home.glossary.subtitle"
        }
        
        enum Glossary {
            static let title: LocalizedStringKey = "education.glossary.title"
            static let searchPlaceholder: LocalizedStringKey = "education.glossary.search.placeholder"
            static let emptyTitle: LocalizedStringKey = "education.glossary.empty.title"
            static let emptyMessage: LocalizedStringKey = "education.glossary.empty.message"
            static let allCategories: LocalizedStringKey = "education.glossary.category.all"
            static let tips: LocalizedStringKey = "education.glossary.detail.tips"
            static let related: LocalizedStringKey = "education.glossary.detail.related"
            static let tags: LocalizedStringKey = "education.glossary.detail.tags"

            enum Category {
                static let cycle: LocalizedStringKey = "education.glossary.category.cycle"
                static let temperature: LocalizedStringKey = "education.glossary.category.temperature"
                static let mucus: LocalizedStringKey = "education.glossary.category.mucus"
                static let cervix: LocalizedStringKey = "education.glossary.category.cervix"
                static let hormones: LocalizedStringKey = "education.glossary.category.hormones"
                static let interpretation: LocalizedStringKey = "education.glossary.category.interpretation"
                static let methods: LocalizedStringKey = "education.glossary.category.methods"
            }

            enum Tag {
                static let basics: LocalizedStringKey = "education.glossary.tag.basics"
                static let measurement: LocalizedStringKey = "education.glossary.tag.measurement"
                static let fertility: LocalizedStringKey = "education.glossary.tag.fertility"
                static let interpretation: LocalizedStringKey = "education.glossary.tag.interpretation"
                static let chart: LocalizedStringKey = "education.glossary.tag.chart"
                static let symptoms: LocalizedStringKey = "education.glossary.tag.symptoms"
            }

            enum Entry {
                enum BBT {
                    static let title: LocalizedStringKey = "education.glossary.entry.bbt.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.bbt.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.bbt.definition"
                    static let tip1: LocalizedStringKey = "education.glossary.entry.bbt.tip.1"
                    static let tip2: LocalizedStringKey = "education.glossary.entry.bbt.tip.2"
                    static let tip3: LocalizedStringKey = "education.glossary.entry.bbt.tip.3"
                }

                enum PeakDay {
                    static let title: LocalizedStringKey = "education.glossary.entry.peak-day.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.peak-day.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.peak-day.definition"
                    static let tip1: LocalizedStringKey = "education.glossary.entry.peak-day.tip.1"
                }

                enum LH {
                    static let title: LocalizedStringKey = "education.glossary.entry.lh.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.lh.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.lh.definition"
                    static let tip1: LocalizedStringKey = "education.glossary.entry.lh.tip.1"
                    static let tip2: LocalizedStringKey = "education.glossary.entry.lh.tip.2"
                    static let tip3: LocalizedStringKey = "education.glossary.entry.lh.tip.3"
                }

                enum CervicalMucus {
                    static let title: LocalizedStringKey = "education.glossary.entry.cervical-mucus.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.cervical-mucus.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.cervical-mucus.definition"
                    static let tip1: LocalizedStringKey = "education.glossary.entry.cervical-mucus.tip.1"
                    static let tip2: LocalizedStringKey = "education.glossary.entry.cervical-mucus.tip.2"
                    static let tip3: LocalizedStringKey = "education.glossary.entry.cervical-mucus.tip.3"
                }

                enum Cervix {
                    static let title: LocalizedStringKey = "education.glossary.entry.cervix.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.cervix.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.cervix.definition"
                    static let tip1: LocalizedStringKey = "education.glossary.entry.cervix.tip.1"
                    static let tip2: LocalizedStringKey = "education.glossary.entry.cervix.tip.2"
                    static let tip3: LocalizedStringKey = "education.glossary.entry.cervix.tip.3"
                }

                enum SHOW {
                    static let title: LocalizedStringKey = "education.glossary.entry.show.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.show.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.show.definition"
                }

                enum FertileWindow {
                    static let title: LocalizedStringKey = "education.glossary.entry.fertile-window.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.fertile-window.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.fertile-window.definition"
                }

                enum ThermalShift {
                    static let title: LocalizedStringKey = "education.glossary.entry.thermal-shift.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.thermal-shift.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.thermal-shift.definition"
                }

                enum BiphasicCycle {
                    static let title: LocalizedStringKey = "education.glossary.entry.biphasic-cycle.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.biphasic-cycle.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.biphasic-cycle.definition"
                }

                enum LutealPhase {
                    static let title: LocalizedStringKey = "education.glossary.entry.luteal-phase.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.luteal-phase.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.luteal-phase.definition"
                }
                
                enum MenstrualCycle {
                    static let title: LocalizedStringKey = "education.glossary.entry.menstrual-cycle.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.menstrual-cycle.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.menstrual-cycle.definition"
                }
                
                enum FollicularPhase {
                    static let title: LocalizedStringKey = "education.glossary.entry.follicular-phase.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.follicular-phase.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.follicular-phase.definition"
                }

                enum Ovulation {
                    static let title: LocalizedStringKey = "education.glossary.entry.ovulation.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.ovulation.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.ovulation.definition"
                }

                enum CorpusLuteum {
                    static let title: LocalizedStringKey = "education.glossary.entry.corpus-luteum.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.corpus-luteum.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.corpus-luteum.definition"
                }

                enum Estrogen {
                    static let title: LocalizedStringKey = "education.glossary.entry.estrogen.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.estrogen.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.estrogen.definition"
                }

                enum Progesterone {
                    static let title: LocalizedStringKey = "education.glossary.entry.progesterone.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.progesterone.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.progesterone.definition"
                }

                enum FSH {
                    static let title: LocalizedStringKey = "education.glossary.entry.fsh.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.fsh.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.fsh.definition"
                }

                enum AnovulatoryCycle {
                    static let title: LocalizedStringKey = "education.glossary.entry.anovulatory-cycle.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.anovulatory-cycle.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.anovulatory-cycle.definition"
                }

                enum Coverline {
                    static let title: LocalizedStringKey = "education.glossary.entry.coverline.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.coverline.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.coverline.definition"
                }

                enum SymptothermalMethod {
                    static let title: LocalizedStringKey = "education.glossary.entry.sympto-thermal.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.sympto-thermal.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.sympto-thermal.definition"
                }

                enum BillingsMethod {
                    static let title: LocalizedStringKey = "education.glossary.entry.billings.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.billings.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.billings.definition"
                }

                enum CreightonModel {
                    static let title: LocalizedStringKey = "education.glossary.entry.creighton.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.creighton.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.creighton.definition"
                }

                enum PMS {
                    static let title: LocalizedStringKey = "education.glossary.entry.pms.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.pms.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.pms.definition"
                }

                enum Implantation {
                    static let title: LocalizedStringKey = "education.glossary.entry.implantation.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.implantation.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.implantation.definition"
                }

                enum SpottingEntry {
                    static let title: LocalizedStringKey = "education.glossary.entry.spotting.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.spotting.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.spotting.definition"
                }

                enum Breastfeeding {
                    static let title: LocalizedStringKey = "education.glossary.entry.breastfeeding.title"
                    static let short: LocalizedStringKey = "education.glossary.entry.breastfeeding.short"
                    static let definition: LocalizedStringKey = "education.glossary.entry.breastfeeding.definition"
                }
            }
        }
        
        enum ChartGuide {
            static let title: LocalizedStringKey = "education.chart-guide.title"
            static let intro: LocalizedStringKey = "education.chart-guide.intro"
            static let exampleChart: LocalizedStringKey = "education.chart-guide.example-chart"
            static let keyPoints: LocalizedStringKey = "education.chart-guide.key-points"
            
            enum Section {
                static let basics: LocalizedStringKey = "education.chart-guide.section.basics"
                static let interpretation: LocalizedStringKey = "education.chart-guide.section.interpretation"
                static let disturbances: LocalizedStringKey = "education.chart-guide.section.disturbances"
            }
            
            enum Lesson {
                enum WhatIsChart {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.what-is-chart.point3"

                }
                
                enum Temperature {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.temperature.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.temperature.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.temperature.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.temperature.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.temperature.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.temperature.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.temperature.point3"
                    static let warning: LocalizedStringKey = "education.chart-guide.lesson.temperature.warning"

                }
                
                enum Mucus {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.mucus.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.mucus.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.mucus.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.mucus.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.mucus.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.mucus.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.mucus.point3"
                    static let point4: LocalizedStringKey = "education.chart-guide.lesson.mucus.point4"

                }
                
                enum Biphasic {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.biphasic.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.biphasic.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.biphasic.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.biphasic.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.biphasic.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.biphasic.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.biphasic.point3"
                }

                enum ThermalShift {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.point3"
                    static let warning: LocalizedStringKey = "education.chart-guide.lesson.thermal-shift.warning"
                }

                enum Coverline {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.coverline.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.coverline.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.coverline.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.coverline.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.coverline.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.coverline.point2"
                }

                enum PeakDay {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.peak-day.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.peak-day.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.peak-day.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.peak-day.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.peak-day.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.peak-day.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.peak-day.point3"
                }

                enum Disturbed {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.disturbed.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.disturbed.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.disturbed.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.disturbed.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.disturbed.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.disturbed.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.disturbed.point3"
                    static let warning: LocalizedStringKey = "education.chart-guide.lesson.disturbed.warning"
                }

                enum Anovulatory {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.point2"
                    static let warning: LocalizedStringKey = "education.chart-guide.lesson.anovulatory.warning"
                }

                enum Irregular {
                    static let title: LocalizedStringKey = "education.chart-guide.lesson.irregular.title"
                    static let subtitle: LocalizedStringKey = "education.chart-guide.lesson.irregular.subtitle"
                    static let body1: LocalizedStringKey = "education.chart-guide.lesson.irregular.body1"
                    static let body2: LocalizedStringKey = "education.chart-guide.lesson.irregular.body2"
                    static let point1: LocalizedStringKey = "education.chart-guide.lesson.irregular.point1"
                    static let point2: LocalizedStringKey = "education.chart-guide.lesson.irregular.point2"
                    static let point3: LocalizedStringKey = "education.chart-guide.lesson.irregular.point3"
                }
            }
        }
        
        enum MeasurementTips {
            static let title: LocalizedStringKey = "education.measurement-tips.title"
            static let intro: LocalizedStringKey = "education.measurement-tips.intro"
            static let dos: LocalizedStringKey = "education.measurement-tips.dos"
            static let donts: LocalizedStringKey = "education.measurement-tips.donts"

            enum Section {
                static let temperature: LocalizedStringKey = "education.measurement-tips.section.temperature"
                static let mucus: LocalizedStringKey = "education.measurement-tips.section.mucus"
                static let cervix: LocalizedStringKey = "education.measurement-tips.section.cervix"
            }

            enum Tip {
                enum ThermometerChoice {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.do2"
                    static let do3: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.do3"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.dont1"
                    static let dont2: LocalizedStringKey = "education.measurement-tips.tip.thermometer-choice.dont2"
                }
                enum MeasurementTime {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.do2"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.dont1"
                    static let dont2: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.dont2"
                    static let warning: LocalizedStringKey = "education.measurement-tips.tip.measurement-time.warning"
                }
                enum MeasurementTechnique {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.body1"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.do2"
                    static let do3: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.do3"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.dont1"
                    static let dont2: LocalizedStringKey = "education.measurement-tips.tip.measurement-technique.dont2"
                }
                enum Disturbances {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.disturbances.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.disturbances.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.disturbances.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.disturbances.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.disturbances.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.disturbances.do2"
                    static let warning: LocalizedStringKey = "education.measurement-tips.tip.disturbances.warning"
                }
                enum MucusBasics {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.do2"
                    static let do3: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.do3"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.dont1"
                    static let dont2: LocalizedStringKey = "education.measurement-tips.tip.mucus-basics.dont2"
                }
                enum MucusObservation {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.do2"
                    static let do3: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.do3"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.dont1"
                    static let dont2: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.dont2"
                    static let warning: LocalizedStringKey = "education.measurement-tips.tip.mucus-observation.warning"
                }
                enum MucusRecording {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.body1"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.do2"
                    static let do3: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.do3"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.mucus-recording.dont1"
                }
                enum CervixBasics {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.do2"
                    static let do3: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.do3"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.dont1"
                    static let warning: LocalizedStringKey = "education.measurement-tips.tip.cervix-basics.warning"
                }
                enum CervixTechnique {
                    static let title: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.title"
                    static let subtitle: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.subtitle"
                    static let body1: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.body1"
                    static let body2: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.body2"
                    static let do1: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.do1"
                    static let do2: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.do2"
                    static let dont1: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.dont1"
                    static let dont2: LocalizedStringKey = "education.measurement-tips.tip.cervix-technique.dont2"
                }
            }
        }
        
        enum NPRMethods {
            static let title: LocalizedStringKey = "education.npr-methods.title"
            static let intro: LocalizedStringKey = "education.npr-methods.intro"

            enum Section {
                static let sympto: LocalizedStringKey = "education.npr-methods.section.sympto"
                static let mucusBased: LocalizedStringKey = "education.npr-methods.section.mucus-based"
                static let other: LocalizedStringKey = "education.npr-methods.section.other"
            }

            enum Difficulty {
                static let easy: LocalizedStringKey = "education.npr-methods.difficulty.easy"
                static let medium: LocalizedStringKey = "education.npr-methods.difficulty.medium"
                static let hard: LocalizedStringKey = "education.npr-methods.difficulty.hard"
            }

            enum Detail {
                static let signsTitle: LocalizedStringKey = "education.npr-methods.detail.signs-title"
                static let rulesTitle: LocalizedStringKey = "education.npr-methods.detail.rules-title"
                static let suitableFor: LocalizedStringKey = "education.npr-methods.detail.suitable-for"
                enum Badge {
                    static let evidenceBased: LocalizedStringKey = "education.npr-methods.detail.badge.evidence-based"
                }
            }

            enum Method {
                enum STM {
                    static let name: LocalizedStringKey = "education.npr-methods.method.stm.name"
                    static let tagline: LocalizedStringKey = "education.npr-methods.method.stm.tagline"
                    static let signsBadge: LocalizedStringKey = "education.npr-methods.method.stm.signs-badge"
                    static let body1: LocalizedStringKey = "education.npr-methods.method.stm.body1"
                    static let body2: LocalizedStringKey = "education.npr-methods.method.stm.body2"
                    static let body3: LocalizedStringKey = "education.npr-methods.method.stm.body3"
                    static let sign1: LocalizedStringKey = "education.npr-methods.method.stm.sign1"
                    static let sign2: LocalizedStringKey = "education.npr-methods.method.stm.sign2"
                    static let sign3: LocalizedStringKey = "education.npr-methods.method.stm.sign3"
                    static let rule1: LocalizedStringKey = "education.npr-methods.method.stm.rule1"
                    static let rule2: LocalizedStringKey = "education.npr-methods.method.stm.rule2"
                    static let rule3: LocalizedStringKey = "education.npr-methods.method.stm.rule3"
                    static let rule4: LocalizedStringKey = "education.npr-methods.method.stm.rule4"
                    static let suitableFor: LocalizedStringKey = "education.npr-methods.method.stm.suitable-for"
                    static let certification: LocalizedStringKey = "education.npr-methods.method.stm.certification"
                }
                enum Roetzer {
                    static let name: LocalizedStringKey = "education.npr-methods.method.roetzer.name"
                    static let tagline: LocalizedStringKey = "education.npr-methods.method.roetzer.tagline"
                    static let signsBadge: LocalizedStringKey = "education.npr-methods.method.roetzer.signs-badge"
                    static let body1: LocalizedStringKey = "education.npr-methods.method.roetzer.body1"
                    static let body2: LocalizedStringKey = "education.npr-methods.method.roetzer.body2"
                    static let sign1: LocalizedStringKey = "education.npr-methods.method.roetzer.sign1"
                    static let sign2: LocalizedStringKey = "education.npr-methods.method.roetzer.sign2"
                    static let sign3: LocalizedStringKey = "education.npr-methods.method.roetzer.sign3"
                    static let rule1: LocalizedStringKey = "education.npr-methods.method.roetzer.rule1"
                    static let rule2: LocalizedStringKey = "education.npr-methods.method.roetzer.rule2"
                    static let rule3: LocalizedStringKey = "education.npr-methods.method.roetzer.rule3"
                    static let suitableFor: LocalizedStringKey = "education.npr-methods.method.roetzer.suitable-for"
                    static let certification: LocalizedStringKey = "education.npr-methods.method.roetzer.certification"
                }
                enum Billings {
                    static let name: LocalizedStringKey = "education.npr-methods.method.billings.name"
                    static let tagline: LocalizedStringKey = "education.npr-methods.method.billings.tagline"
                    static let signsBadge: LocalizedStringKey = "education.npr-methods.method.billings.signs-badge"
                    static let body1: LocalizedStringKey = "education.npr-methods.method.billings.body1"
                    static let body2: LocalizedStringKey = "education.npr-methods.method.billings.body2"
                    static let sign1: LocalizedStringKey = "education.npr-methods.method.billings.sign1"
                    static let rule1: LocalizedStringKey = "education.npr-methods.method.billings.rule1"
                    static let rule2: LocalizedStringKey = "education.npr-methods.method.billings.rule2"
                    static let rule3: LocalizedStringKey = "education.npr-methods.method.billings.rule3"
                    static let rule4: LocalizedStringKey = "education.npr-methods.method.billings.rule4"
                    static let suitableFor: LocalizedStringKey = "education.npr-methods.method.billings.suitable-for"
                    static let certification: LocalizedStringKey = "education.npr-methods.method.billings.certification"
                }
                enum Creighton {
                    static let name: LocalizedStringKey = "education.npr-methods.method.creighton.name"
                    static let tagline: LocalizedStringKey = "education.npr-methods.method.creighton.tagline"
                    static let signsBadge: LocalizedStringKey = "education.npr-methods.method.creighton.signs-badge"
                    static let body1: LocalizedStringKey = "education.npr-methods.method.creighton.body1"
                    static let body2: LocalizedStringKey = "education.npr-methods.method.creighton.body2"
                    static let body3: LocalizedStringKey = "education.npr-methods.method.creighton.body3"
                    static let sign1: LocalizedStringKey = "education.npr-methods.method.creighton.sign1"
                    static let rule1: LocalizedStringKey = "education.npr-methods.method.creighton.rule1"
                    static let rule2: LocalizedStringKey = "education.npr-methods.method.creighton.rule2"
                    static let rule3: LocalizedStringKey = "education.npr-methods.method.creighton.rule3"
                    static let suitableFor: LocalizedStringKey = "education.npr-methods.method.creighton.suitable-for"
                    static let certification: LocalizedStringKey = "education.npr-methods.method.creighton.certification"
                }
                enum Calendar {
                    static let name: LocalizedStringKey = "education.npr-methods.method.calendar.name"
                    static let tagline: LocalizedStringKey = "education.npr-methods.method.calendar.tagline"
                    static let signsBadge: LocalizedStringKey = "education.npr-methods.method.calendar.signs-badge"
                    static let body1: LocalizedStringKey = "education.npr-methods.method.calendar.body1"
                    static let body2: LocalizedStringKey = "education.npr-methods.method.calendar.body2"
                    static let sign1: LocalizedStringKey = "education.npr-methods.method.calendar.sign1"
                    static let rule1: LocalizedStringKey = "education.npr-methods.method.calendar.rule1"
                    static let rule2: LocalizedStringKey = "education.npr-methods.method.calendar.rule2"
                    static let suitableFor: LocalizedStringKey = "education.npr-methods.method.calendar.suitable-for"
                }
            }
        }
    }
}
