//
//  CollapsibleFormSection.swift
//  PMeter
//
//  Reusable collapsible section header for Form use.
//
//  Created by JCeluch on 13/06/2026.
//

import SwiftUI

struct CollapsibleFormSection<Content: View>: View {
    let title: LocalizedStringKey
    let systemImage: String
    @Binding var isExpanded: Bool
    var badge: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        Section {
            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        } header: {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: systemImage)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(isExpanded ? Color.pmPrimary : Color.pmTextSecondary)
                        .frame(width: 16)

                    Text(title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(isExpanded ? Color.pmPrimary : Color.pmTextSecondary)
                        .textCase(nil)

                    if let badge {
                        Text(badge)
                            .font(.caption2.weight(.medium))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.pmPrimary.opacity(0.15), in: Capsule())
                            .foregroundStyle(Color.pmPrimary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(Color.pmTextSecondary)
                }
                .contentShape(Rectangle())
                .padding(.vertical, 2)
            }
            .buttonStyle(.plain)
        }
    }
}
