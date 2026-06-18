//
//  EducationFAQView.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//


import SwiftUI

struct EducationFAQView: View {
    @StateObject private var viewModel = EducationFAQViewModel()

    var body: some View {
        List {
            Section {
                Text(L10n.educationFaqDisclaimer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.groupedItems, id: \.category.id) { group in
                Section(LocalizedStringKey(group.category.titleKey)) {
                    ForEach(group.items) { item in
                        FAQRowView(
                            questionKey: item.questionKey,
                            answerKey: item.answerKey,
                            isExpanded: viewModel.isExpanded(item.id),
                            onTap: { viewModel.toggle(item.id) }
                        )
                    }
                }
            }
        }
        .navigationTitle(L10n.educationFaqTitle)
    }
}