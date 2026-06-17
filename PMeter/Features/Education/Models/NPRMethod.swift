//
//  NPRMethod.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import SwiftUI

struct NPRMethod: Identifiable {
    let id: String
    let systemImage: String
    let name: LocalizedStringKey
    let tagline: LocalizedStringKey
    let signsUsedBadge: LocalizedStringKey
    let difficultyBadge: LocalizedStringKey
    let difficultyColor: Color
    let hasScientificBacking: Bool
    let descriptionParagraphs: [LocalizedStringKey]
    let signs: [LocalizedStringKey]
    let keyRules: [LocalizedStringKey]
    let suitableFor: LocalizedStringKey
    let certificationInfo: LocalizedStringKey?
}

// MARK: - Collections

extension NPRMethod {
    static let symptoThermal: [NPRMethod] = [.stm, .roetzer]
    static let mucusBased: [NPRMethod] = [.billings, .creighton]
    static let other: [NPRMethod] = [.calendar]
}

// MARK: - Sympto-termiczne

extension NPRMethod {

    static let stm = NPRMethod(
        id: "stm",
        systemImage: "thermometer.and.liquid.waves",
        name: L10n.Education.NPRMethods.Method.STM.name,
        tagline: L10n.Education.NPRMethods.Method.STM.tagline,
        signsUsedBadge: L10n.Education.NPRMethods.Method.STM.signsBadge,
        difficultyBadge: L10n.Education.NPRMethods.Difficulty.medium,
        difficultyColor: .orange,
        hasScientificBacking: true,
        descriptionParagraphs: [
            L10n.Education.NPRMethods.Method.STM.body1,
            L10n.Education.NPRMethods.Method.STM.body2,
            L10n.Education.NPRMethods.Method.STM.body3
        ],
        signs: [
            L10n.Education.NPRMethods.Method.STM.sign1,
            L10n.Education.NPRMethods.Method.STM.sign2,
            L10n.Education.NPRMethods.Method.STM.sign3
        ],
        keyRules: [
            L10n.Education.NPRMethods.Method.STM.rule1,
            L10n.Education.NPRMethods.Method.STM.rule2,
            L10n.Education.NPRMethods.Method.STM.rule3,
            L10n.Education.NPRMethods.Method.STM.rule4
        ],
        suitableFor: L10n.Education.NPRMethods.Method.STM.suitableFor,
        certificationInfo: L10n.Education.NPRMethods.Method.STM.certification
    )

    static let roetzer = NPRMethod(
        id: "roetzer",
        systemImage: "waveform.path.ecg",
        name: L10n.Education.NPRMethods.Method.Roetzer.name,
        tagline: L10n.Education.NPRMethods.Method.Roetzer.tagline,
        signsUsedBadge: L10n.Education.NPRMethods.Method.Roetzer.signsBadge,
        difficultyBadge: L10n.Education.NPRMethods.Difficulty.hard,
        difficultyColor: .red,
        hasScientificBacking: true,
        descriptionParagraphs: [
            L10n.Education.NPRMethods.Method.Roetzer.body1,
            L10n.Education.NPRMethods.Method.Roetzer.body2
        ],
        signs: [
            L10n.Education.NPRMethods.Method.Roetzer.sign1,
            L10n.Education.NPRMethods.Method.Roetzer.sign2,
            L10n.Education.NPRMethods.Method.Roetzer.sign3
        ],
        keyRules: [
            L10n.Education.NPRMethods.Method.Roetzer.rule1,
            L10n.Education.NPRMethods.Method.Roetzer.rule2,
            L10n.Education.NPRMethods.Method.Roetzer.rule3
        ],
        suitableFor: L10n.Education.NPRMethods.Method.Roetzer.suitableFor,
        certificationInfo: L10n.Education.NPRMethods.Method.Roetzer.certification
    )
}

// MARK: - Śluzowe

extension NPRMethod {

    static let billings = NPRMethod(
        id: "billings",
        systemImage: "drop.halffull",
        name: L10n.Education.NPRMethods.Method.Billings.name,
        tagline: L10n.Education.NPRMethods.Method.Billings.tagline,
        signsUsedBadge: L10n.Education.NPRMethods.Method.Billings.signsBadge,
        difficultyBadge: L10n.Education.NPRMethods.Difficulty.medium,
        difficultyColor: .orange,
        hasScientificBacking: true,
        descriptionParagraphs: [
            L10n.Education.NPRMethods.Method.Billings.body1,
            L10n.Education.NPRMethods.Method.Billings.body2
        ],
        signs: [
            L10n.Education.NPRMethods.Method.Billings.sign1
        ],
        keyRules: [
            L10n.Education.NPRMethods.Method.Billings.rule1,
            L10n.Education.NPRMethods.Method.Billings.rule2,
            L10n.Education.NPRMethods.Method.Billings.rule3,
            L10n.Education.NPRMethods.Method.Billings.rule4
        ],
        suitableFor: L10n.Education.NPRMethods.Method.Billings.suitableFor,
        certificationInfo: L10n.Education.NPRMethods.Method.Billings.certification
    )

    static let creighton = NPRMethod(
        id: "creighton",
        systemImage: "cross.case",
        name: L10n.Education.NPRMethods.Method.Creighton.name,
        tagline: L10n.Education.NPRMethods.Method.Creighton.tagline,
        signsUsedBadge: L10n.Education.NPRMethods.Method.Creighton.signsBadge,
        difficultyBadge: L10n.Education.NPRMethods.Difficulty.hard,
        difficultyColor: .red,
        hasScientificBacking: true,
        descriptionParagraphs: [
            L10n.Education.NPRMethods.Method.Creighton.body1,
            L10n.Education.NPRMethods.Method.Creighton.body2,
            L10n.Education.NPRMethods.Method.Creighton.body3
        ],
        signs: [
            L10n.Education.NPRMethods.Method.Creighton.sign1
        ],
        keyRules: [
            L10n.Education.NPRMethods.Method.Creighton.rule1,
            L10n.Education.NPRMethods.Method.Creighton.rule2,
            L10n.Education.NPRMethods.Method.Creighton.rule3
        ],
        suitableFor: L10n.Education.NPRMethods.Method.Creighton.suitableFor,
        certificationInfo: L10n.Education.NPRMethods.Method.Creighton.certification
    )
}

// MARK: - Inne

extension NPRMethod {

    static let calendar = NPRMethod(
        id: "calendar",
        systemImage: "calendar",
        name: L10n.Education.NPRMethods.Method.Calendar.name,
        tagline: L10n.Education.NPRMethods.Method.Calendar.tagline,
        signsUsedBadge: L10n.Education.NPRMethods.Method.Calendar.signsBadge,
        difficultyBadge: L10n.Education.NPRMethods.Difficulty.easy,
        difficultyColor: .green,
        hasScientificBacking: false,
        descriptionParagraphs: [
            L10n.Education.NPRMethods.Method.Calendar.body1,
            L10n.Education.NPRMethods.Method.Calendar.body2
        ],
        signs: [
            L10n.Education.NPRMethods.Method.Calendar.sign1
        ],
        keyRules: [
            L10n.Education.NPRMethods.Method.Calendar.rule1,
            L10n.Education.NPRMethods.Method.Calendar.rule2
        ],
        suitableFor: L10n.Education.NPRMethods.Method.Calendar.suitableFor,
        certificationInfo: nil
    )
}
