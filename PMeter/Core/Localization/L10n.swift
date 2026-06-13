//
//  L10n.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import SwiftUI

enum L10n {
    enum Tabs {
        static let cycle: LocalizedStringKey = "tabs.cycle"
        static let calendar: LocalizedStringKey = "tabs.calendar"
        static let settings: LocalizedStringKey = "tabs.settings"
        static let stats: LocalizedStringKey = "tabs.stats"
    }

    enum CycleForm {
        static let newEntryTitle: LocalizedStringKey = "cycleForm.newEntryTitle"
        static let editEntryTitle: LocalizedStringKey = "cycleForm.editEntryTitle"
        static let dateSection: LocalizedStringKey = "cycleForm.dateSection"
        static let observationsSection: LocalizedStringKey = "cycleForm.observationsSection"
        static let notesSection: LocalizedStringKey = "cycleForm.notesSection"
        static let observationDate: LocalizedStringKey = "cycleForm.observationDate"
        static let bleeding: LocalizedStringKey = "cycleForm.bleeding"
        static let mucus: LocalizedStringKey = "cycleForm.mucus"
        static let mucusAmount: LocalizedStringKey = "cycleForm.mucusAmount"
        static let mucusSensation: LocalizedStringKey = "cycleForm.mucusSensation"
        static let mucusAppearance: LocalizedStringKey = "cycleForm.mucusAppearance"
        static let mucusStretch: LocalizedStringKey = "cycleForm.mucusStretch"
        static let mucusVolume: LocalizedStringKey = "cycleForm.mucusVolume"
        static let isPeakDay: LocalizedStringKey = "cycleForm.isPeakDay"
        static let cervix: LocalizedStringKey = "cycleForm.cervix"
        static let breastTenderness: LocalizedStringKey = "cycleForm.breastTenderness"
        static let temperature: LocalizedStringKey = "cycleForm.temperature"
        static let lhTest: LocalizedStringKey = "cycleForm.lhTest"
        static let addTemperature: LocalizedStringKey = "cycleForm.addTemperature"
        static let temperaturePlaceholder: LocalizedStringKey = "cycleForm.temperaturePlaceholder"
        static let intercourse: LocalizedStringKey = "cycleForm.intercourse"
        static let notesPlaceholder: LocalizedStringKey = "cycleForm.notesPlaceholder"
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
