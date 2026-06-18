//
//  FAQRowView.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//

import SwiftUI

struct FAQRowView: View {
    let questionKey: String
    let answerKey: String
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 12) {
                    Text(LocalizedStringKey(questionKey))
                        .font(.body.weight(.semibold))
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }

                if isExpanded {
                    Text(LocalizedStringKey(answerKey))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            .contentShape(Rectangle())
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}
