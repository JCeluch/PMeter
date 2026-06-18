//
//  SettingsView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue

    @Environment(\.modelContext) private var modelContext

    @State private var pendingPreset: SeedPreset? = nil
    @State private var showSeedConfirm = false
    @State private var seedError: String? = nil
    @State private var showSeedError = false

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

                // MARK: - Dane startowe
                Section {
                    seedButton(
                        icon: "waveform.path.ecg",
                        title: "Załaduj dane NPR",
                        subtitle: "Podręcznikowy wzorzec NPR/FAM (10 cykli, ~12 mies.)",
                        preset: .classicNPR
                    )
                    seedButton(
                        icon: "wand.and.sparkles",
                        title: "Załaduj seed testowy",
                        subtitle: "Losowe dane demonstracyjne (8 cykli)",
                        preset: .random
                    )
                    seedButton(
                        icon: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                        title: "Załaduj dane historyczne",
                        subtitle: "Dane z eksportu aplikacji (12 cykli, 2025–2026)",
                        preset: .historicalPartner
                    )
                } header: {
                    Text("Dane startowe")
                } footer: {
                    Text("Załadowanie danych usunie wszystkie istniejące wpisy.")
                        .foregroundStyle(Color.pmTextSecondary)
                }
            }
            .navigationTitle(L10n.Settings.title)
            .confirmationDialog(
                "Zastąpić istniejące dane?",
                isPresented: $showSeedConfirm,
                titleVisibility: .visible
            ) {
                Button("Załaduj i usuń dane", role: .destructive) {
                    loadSeed()
                }
                Button("Anuluj", role: .cancel) {
                    pendingPreset = nil
                }
            } message: {
                Text("Ta operacja jest nieodwracalna. Wszystkie Twoje wpisy zostaną usunięte.")
            }
            .alert("Błąd ładowania danych", isPresented: $showSeedError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(seedError ?? "Nieznany błąd")
            }
        }
    }

    // MARK: - Helpers

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

    @ViewBuilder
    private func seedButton(
        icon: String,
        title: String,
        subtitle: String,
        preset: SeedPreset
    ) -> some View {
        Button {
            pendingPreset = preset
            showSeedConfirm = true
        } label: {
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

    @MainActor
    private func loadSeed() {
        guard let preset = pendingPreset else { return }
        let repository = SwiftDataCycleEntryRepository(modelContext: modelContext)
        let service = SeedService(repository: repository)
        do {
            try service.reseed(preset: preset)
        } catch {
            seedError = error.localizedDescription
            showSeedError = true
        }
        pendingPreset = nil
    }
}

//#Preview {
//    SettingsView()
//}
