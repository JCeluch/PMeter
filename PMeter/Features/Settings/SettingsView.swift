//
//  SettingsView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue
    
    var body: some View {
        NavigationStack {
            List {
                languageSection
                
                Section(L10n.Settings.appSection) {
                    settingsRow(
                        icon: "lock.shield",
                        title: L10n.Settings.dataPrivacyTitle,
                        subtitle: L10n.Settings.dataPrivacySubtitle
                    )

                    settingsRow(
                        icon: "heart.text.square",
                        title: L10n.Settings.healthIntegrationTitle,
                        subtitle: L10n.Settings.healthIntegrationSubtitle
                    )
                }

                Section(L10n.Settings.methodSection) {
                    settingsRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: L10n.Settings.observationMethodTitle,
                        subtitle: L10n.Settings.observationMethodSubtitle
                    )
                }
            }
            .navigationTitle(L10n.Settings.title)
        }
    }
    
    private var languageSection: some View {
        Section("settings.language.section") {
            Picker("settings.language.picker", selection: $appLanguage) {
                Text("settings.language.system").tag(AppLanguage.system.rawValue)
                Text("settings.language.polish").tag(AppLanguage.polish.rawValue)
                Text("settings.language.english").tag(AppLanguage.english.rawValue)
            }
        }
    }

    private func settingsRow(
        icon: String,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.pmPrimary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundStyle(Color.pmTextPrimary)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color.pmTextSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    SettingsView()
//}
