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
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.locale, resolvedLocale)
        }
        .modelContainer(for: [CycleEntry.self])
    }
    
    private var resolvedLocale: Locale {
        let selection = AppLanguage(rawValue: appLanguage) ?? .system
        return selection.locale ?? .autoupdatingCurrent
    }
}
