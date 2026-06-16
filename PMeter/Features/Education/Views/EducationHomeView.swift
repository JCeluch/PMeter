//
//  EducationHomeView.swift
//  PMeter
//
//  Created by JCeluch on 15/06/2026.
//

import SwiftUI

struct EducationHomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        GlossaryListView()
                    } label: {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L10n.Education.Glossary.title)
                                    .font(.headline)
                                Text(L10n.Education.Home.glossarySubtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "text.book.closed")
                                .foregroundStyle(.accent)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(L10n.Education.Home.title)
        }
    }
}
