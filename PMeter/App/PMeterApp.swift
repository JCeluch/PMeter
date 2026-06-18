//
//  PMeterApp.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData
import Observation

@main
struct PMeterApp: App {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue

    private let sharedModelContainer: ModelContainer = ModelContainerFactory.makeShared()
    
    @State private var cycleStore = CycleStore()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.locale, resolvedLocale)
                .environment(cycleStore)
        }
        .modelContainer(sharedModelContainer)
    }

    private var resolvedLocale: Locale {
        let selection = AppLanguage(rawValue: appLanguage) ?? .system
        return selection.locale ?? .autoupdatingCurrent
    }
}
