//
//  StatsSkeletonView.swift
//  PMeter
//
//  Created by JCeluch on 18/06/2026.
//


import SwiftUI

struct StatsSkeletonView: View {
    var body: some View {
        List {
            skeletonSection(rows: 4)
            skeletonSection(rows: 3)
            skeletonSection(rows: 2)
            skeletonSection(rows: 3)
        }
    }

    private func skeletonSection(rows: Int) -> some View {
        Section {
            ForEach(0..<rows, id: \.self) { i in
                HStack {
                    SkeletonBar(width: CGFloat.random(in: 120...200))
                    Spacer()
                    SkeletonBar(width: CGFloat.random(in: 40...80))
                }
                .padding(.vertical, 2)
            }
        } header: {
            SkeletonBar(width: 100, height: 12)
        }
    }
}

struct SkeletonBar: View {
    var width: CGFloat
    var height: CGFloat = 14
    @State private var animating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(
                LinearGradient(
                    colors: [
                        Color(.systemFill),
                        Color(.tertiarySystemFill),
                        Color(.systemFill)
                    ],
                    startPoint: animating ? .leading : .trailing,
                    endPoint: animating ? .trailing : .leading
                )
            )
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                    animating = true
                }
            }
    }
}