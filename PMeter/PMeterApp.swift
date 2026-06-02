//
//  PMeterApp.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import CoreData

@main
struct PMeterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
