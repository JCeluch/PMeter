//
//  PMeterApp.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

@main
struct PMeterApp: App {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue

    private let sharedModelContainer: ModelContainer = ModelContainerFactory.makeShared()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.locale, resolvedLocale)
                .task {
                    await seedInitialDataIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private var resolvedLocale: Locale {
        let selection = AppLanguage(rawValue: appLanguage) ?? .system
        return selection.locale ?? .autoupdatingCurrent
    }

    @MainActor
    private func seedInitialDataIfNeeded() async {
        let repository = SwiftDataCycleEntryRepository(modelContext: sharedModelContainer.mainContext)
        let seedService = SeedService(repository: repository)

        do {
            #if DEBUG
            try seedService.seedIfNeeded()
            #endif
        } catch {
            assertionFailure("Initial seed failed: \(error)")
        }
    }
}
