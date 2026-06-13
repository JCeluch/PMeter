//
//  ModelContainerFactory.swift
//  PMeter
//
//  Created by JCeluch on 12/06/2026.
//

import Foundation
import SwiftData

enum ModelContainerFactory {
    @MainActor
    static func makeShared(inMemory: Bool = false) -> ModelContainer {
        let schema = Schema([
            CycleEntry.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
