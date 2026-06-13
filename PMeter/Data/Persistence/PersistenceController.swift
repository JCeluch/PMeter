//
//  Persistence.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init(inMemory: Bool = false) {
        self.container = ModelContainerFactory.makeShared(inMemory: inMemory)
    }

    static var preview: PersistenceController {
        PersistenceController(inMemory: true)
    }
}
