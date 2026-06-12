//
//  Untitled.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case polish = "pl"
    case english = "en"

    var id: String { rawValue }

    var locale: Locale? {
        switch self {
        case .system: return nil
        case .polish: return Locale(identifier: "pl")
        case .english: return Locale(identifier: "en")
        }
    }
}
