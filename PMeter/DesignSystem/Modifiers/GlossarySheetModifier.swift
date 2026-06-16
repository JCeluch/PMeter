//
//  GlossarySheetModifier.swift
//  PMeter
//
//  Created by JCeluch on 16/06/2026.
//

import SwiftUI

private struct GlossarySheetModifier: ViewModifier {
    let entryID: String
    @State private var isPresented = false

    private var entry: GlossaryEntry? { GlossaryService.shared.entry(withID: entryID) }
    private var related: [GlossaryEntry] {
        entry.map { GlossaryService.shared.relatedEntries(for: $0) } ?? []
    }

    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Button {
                isPresented = true
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(.accent)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isPresented) {
            if let entry {
                NavigationStack {
                    GlossaryDetailView(
                        entry: entry,
                        relatedEntries: related,
                        relatedEntriesResolver: { GlossaryService.shared.relatedEntries(for: $0) }
                    )
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(L10n.Common.done) { isPresented = false }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

extension View {
    func glossaryInfo(_ entryID: String) -> some View {
        modifier(GlossarySheetModifier(entryID: entryID))
    }
}
