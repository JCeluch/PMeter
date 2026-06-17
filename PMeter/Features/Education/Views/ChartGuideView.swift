//
//  ChartGuideView.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import SwiftUI

struct ChartGuideView: View {
    @State private var selectedLesson: ChartLesson? = nil

    var body: some View {
        List {
            Section {
                Text(L10n.Education.ChartGuide.intro)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }

            Section(header: Text(L10n.Education.ChartGuide.Section.basics)) {
                ForEach(ChartLesson.basics) { lesson in
                    NavigationLink {
                        ChartLessonDetailView(lesson: lesson)
                    } label: {
                        ChartLessonRowView(lesson: lesson)
                    }
                }
            }

            Section(header: Text(L10n.Education.ChartGuide.Section.interpretation)) {
                ForEach(ChartLesson.interpretation) { lesson in
                    NavigationLink {
                        ChartLessonDetailView(lesson: lesson)
                    } label: {
                        ChartLessonRowView(lesson: lesson)
                    }
                }
            }

            Section(header: Text(L10n.Education.ChartGuide.Section.disturbances)) {
                ForEach(ChartLesson.disturbances) { lesson in
                    NavigationLink {
                        ChartLessonDetailView(lesson: lesson)
                    } label: {
                        ChartLessonRowView(lesson: lesson)
                    }
                }
            }
        }
        .navigationTitle(L10n.Education.ChartGuide.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Row

private struct ChartLessonRowView: View {
    let lesson: ChartLesson

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: lesson.systemImage)
                .font(.title2)
                .foregroundStyle(.accent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.headline)
                Text(lesson.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Detail

struct ChartLessonDetailView: View {
    let lesson: ChartLesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: lesson.systemImage)
                        .font(.largeTitle)
                        .foregroundStyle(.accent)
                    Text(lesson.title)
                        .font(.title2.bold())
                    Text(lesson.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Divider()
                    .padding(.horizontal)

                // ASCII chart (jeśli istnieje)
                if let chart = lesson.asciiChart {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.Education.ChartGuide.exampleChart)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(chart)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.primary)
                                .padding(12)
                                .background(Color.secondary.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal)
                        }
                    }
                }

                // Treść
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(lesson.bodyParagraphs.enumerated()), id: \.offset) { _, paragraph in
                        Text(paragraph)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)

                // Kluczowe punkty
                if !lesson.keyPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(L10n.Education.ChartGuide.keyPoints)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)

                        ForEach(Array(lesson.keyPoints.enumerated()), id: \.offset) { _, point in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.accent)
                                    .font(.subheadline)
                                    .padding(.top, 1)
                                Text(point)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color.accentColor.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                // Uwaga / ostrzeżenie
                if let warning = lesson.warning {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.subheadline)
                            .padding(.top, 1)
                        Text(warning)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .background(Color.orange.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                Spacer(minLength: 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
