//
//  CycleChartView.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import SwiftUI
import Charts

struct CycleBarChartView: View {
    let cycleInfos: [CycleInfo]
    let average: Double

    private struct BarData: Identifiable {
        let id: UUID = .init()
        let index: Int
        let length: Int
        let startDate: Date
    }

    private var data: [BarData] {
        cycleInfos.enumerated().map { i, info in
            BarData(index: i + 1, length: info.length, startDate: info.startDate)
        }
    }

    private var yDomain: ClosedRange<Int> {
        let lengths = cycleInfos.map(\.length)
        let lo = max((lengths.min() ?? 20) - 3, 10)
        let hi = (lengths.max() ?? 35) + 3
        return lo...hi
    }

    var body: some View {
        Chart {
            // Linia średniej
            RuleMark(y: .value("Średnia", average))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundStyle(.secondary.opacity(0.6))
                .annotation(position: .trailing, alignment: .leading) {
                    Text("\(Int(round(average)))d")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

            ForEach(data) { bar in
                BarMark(
                    x: .value("Cykl", bar.index),
                    y: .value("Dni", bar.length)
                )
                .foregroundStyle(barColor(for: bar.length))
                .cornerRadius(3)
                .annotation(position: .top, alignment: .center) {
                    if cycleInfos.count <= 8 {
                        Text("\(bar.length)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .chartYScale(domain: yDomain)
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) { value in
                if let idx = value.as(Int.self) {
                    AxisValueLabel {
                        Text("\(idx)")
                            .font(.caption2)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let v = value.as(Int.self) {
                        Text("\(v)d")
                            .font(.caption2)
                    }
                }
            }
        }
        .frame(height: 160)
        .padding(.vertical, 8)
    }

    private func barColor(for length: Int) -> Color {
        let diff = abs(Double(length) - average)
        if diff <= 2 { return .pink.opacity(0.75) }
        if diff <= 5 { return .orange.opacity(0.70) }
        return .red.opacity(0.65)
    }
}
