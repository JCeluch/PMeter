//
//  CycleChartView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData
import Charts

struct CycleChartView: View {
    let entries: [CycleEntry]
    @Binding var selectedDate: Date?
    @State private var anchorDate: Date = .now
    
    private let cellWidth: CGFloat = 32
    private let rowSpacing: CGFloat = 8

    private var gridWidth: CGFloat {
        let count = CGFloat(days.count)
        guard count > 0 else { return 0 }
        
        print("GridWidth = \(count) * \(cellWidth) + \(count) * \(rowSpacing)")
        return count * cellWidth + count * rowSpacing
    }

    private var days: [CycleChartDay] {
        CalendarHelper.cycleDays(containing: anchorDate, entries: entries)
    }

    private var temperatureDays: [CycleChartDay] {
        days.filter { $0.temperature != nil }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if days.isEmpty {
                ContentUnavailableView(
                    L10n.Calendar.emptyTitle,
                    systemImage: "waveform.path.ecg",
                    description: Text(L10n.Calendar.emptyDescription)
                )
            } else {
                ScrollView(.horizontal, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 12) {
                        cycleDayRow
                        dateRow
                        temperatureChart
                        bleedingRow
                        mucusRow
                        cervixRow
                        observationRow(title: "LH", values: days.map { lhSymbol(for: $0.lhTest) })
                        intercourseRow
                    }
                    .padding(.bottom, 8)
                }
            }
        }
        .padding()
        .background(Color.pmBackground)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.Calendar.chartTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.pmTextPrimary)

                if let first = days.first?.date, let last = days.last?.date {
                    Text("\(first.formatted(date: .abbreviated, time: .omitted)) – \(last.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundStyle(Color.pmTextSecondary)
                }
            }

            Spacer()

            Button {
                moveCycle(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.pmPrimary)
                    .frame(width: 36, height: 36)
                    .background(Color.pmSurface)
                    .clipShape(Circle())
            }

            Button {
                moveCycle(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.pmPrimary)
                    .frame(width: 36, height: 36)
                    .background(Color.pmSurface)
                    .clipShape(Circle())
            }
        }
    }

    private var cycleDayRow: some View {
        HStack(spacing: rowSpacing) {
            rowTitle(String(localized: "calendar.cycleDay.label"))

            ForEach(days) { day in
                Button {
                    selectedDate = day.date
                } label: {
                    Text("\(day.cycleDay)")
                        .font(.caption.weight(.semibold))
                        .frame(width: cellWidth, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    isSelected(day.date)
                                    ? Color.pmPrimary.opacity(0.18)
                                    : Color.pmSurface
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var dateRow: some View {
        HStack(spacing: rowSpacing) {
            rowTitle(String(localized: "calendar.chart.dateShort"))

            ForEach(days) { day in
                Text(day.date.formatted(.dateTime.day()))
                    .font(.caption2)
                    .foregroundStyle(Color.pmTextSecondary)
                    .frame(width: cellWidth)
            }
        }
    }

    private var temperatureChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: rowSpacing) {
                rowTitle(String(localized: "calendar.chart.temperatureShort"))
                Text(L10n.ChartEnums.tempUnit)
                    .font(.caption)
                    .foregroundStyle(Color.pmTextSecondary)
            }

            Chart(temperatureDays) { day in
                if let temperature = day.temperature {
                    LineMark(
                        x: .value(String(localized: "calendar.cycleDay.label"), day.cycleDay),
                        y: .value(String(localized: "calendar.chart.temperature"), temperature)
                    )
                    .foregroundStyle(Color.pmPrimary)
                    .interpolationMethod(.linear)

                    PointMark(
                        x: .value(String(localized: "calendar.cycleDay.label"), day.cycleDay),
                        y: .value(String(localized: "calendar.chart.temperature"), temperature)
                    )
                    .foregroundStyle(temperaturePointColor(for: day))
                    .symbolSize(40)
                }
            }
            .frame(width: gridWidth, height: 320)
            .chartYScale(domain: yDomain, range: .plotDimension(padding: 12))
            .chartXAxis {
                AxisMarks(values: days.map(\.cycleDay)) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.pmTextSecondary.opacity(0.15))
                    AxisTick()
                    AxisValueLabel {
                        if let day = value.as(Int.self) {
                            Text("\(day)")
                                .font(.caption2)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: yAxisMarks) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.pmTextSecondary.opacity(0.18))
                    AxisTick()
                    AxisValueLabel {
                        if let temp = value.as(Double.self) {
                            Text(String(format: "%.2f", temp))
                                .font(.caption2)
                                .foregroundStyle(Color.pmTextSecondary)
                        }
                    }
                }
            }
        }
    }

    private func observationRow(title: String, values: [String]) -> some View {
        HStack(spacing: rowSpacing) {
            rowTitle(title)

            ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                Text(value.isEmpty ? "–" : value)
                    .font(.caption)
                    .foregroundStyle(Color.pmTextPrimary)
                    .frame(width: cellWidth, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.pmSurface)
                    )
            }
        }
    }

    private func rowTitle(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.pmTextSecondary)
            .frame(width: cellWidth, alignment: .leading)
    }
    
    private func isSelected(_ date: Date) -> Bool {
        guard let selectedDate else { return false }
        return CalendarHelper.isSameDay(selectedDate, date)
    }

    private func moveCycle(by direction: Int) {
        let starts = CalendarHelper.cycleStartDates(in: entries)
        guard !starts.isEmpty else { return }

        guard let currentStart = CalendarHelper.cycleStartDate(for: anchorDate, entries: entries),
              let currentIndex = starts.firstIndex(where: { CalendarHelper.isSameDay($0, currentStart) }) else {
            return
        }

        let newIndex = currentIndex + direction
        guard starts.indices.contains(newIndex) else { return }

        anchorDate = starts[newIndex]
    }

    private func bleedingSymbol(for value: BleedingLevel) -> String {
        switch value {
        case .none: return String(localized: "bleeding.symbols.none")
        case .spotting: return String(localized: "bleeding.symbols.spotting")
        case .light: return String(localized: "bleeding.symbols.light")
        case .medium: return String(localized: "bleeding.symbols.medium")
        case .heavy: return String(localized: "bleeding.symbols.heavy")
        }
    }

//    private func mucusSymbol(for value: MucusObservation) -> String {
//        switch value {
//        case .none: return String(localized: "mucus.symbols.none")
//        case .dry: return String(localized: "mucus.symbols.dry")
//        case .sticky: return String(localized: "mucus.symbols.sticky")
//        case .creamy: return String(localized: "mucus.symbols.creamy")
//        case .watery: return String(localized: "mucus.symbols.watery")
//        case .eggWhite: return String(localized: "mucus.symbols.eggWhite")
//        }
//    }

    private func lhSymbol(for value: LHTestResult) -> String {
        switch value {
        case .none: return String(localized: "lh.symbols.none")
        case .negative: return String(localized: "lh.symbols.negative")
        case .positive: return String(localized: "lh.symbols.positive")
        case .peak: return String(localized: "lh.symbols.peak")
        }
    }
    
    private var temperatureValues: [Double] {
        temperatureDays.compactMap(\.temperature)
    }

    private var yDomain: ClosedRange<Double> {
        guard let minValue = temperatureValues.min(),
              let maxValue = temperatureValues.max() else {
            return 36.20...36.80
        }

        let step = 0.02
        let padding = 0.04

        var lower = minValue - padding
        var upper = maxValue + padding

        if (upper - lower) < 0.24 {
            let center = (lower + upper) / 2
            lower = center - 0.12
            upper = center + 0.12
        }

        lower = floor(lower / step) * step
        upper = ceil(upper / step) * step

        return lower...upper
    }

    private var yAxisMarks: [Double] {
        let lower = yDomain.lowerBound
        let upper = yDomain.upperBound
        let step = 0.02

        let count = Int(round((upper - lower) / step))
        return (0...count).map { index in
            lower + (Double(index) * step)
        }
    }
    
    private func isBleedingDay(_ value: BleedingLevel) -> Bool {
        value != .none
    }

    private func bleedingCellBackground(for value: BleedingLevel) -> Color {
        switch value {
        case .none:
            return Color.pmSurface
        case .spotting:
            return Color.red.opacity(0.10)
        case .light:
            return Color.red.opacity(0.14)
        case .medium:
            return Color.red.opacity(0.18)
        case .heavy:
            return Color.red.opacity(0.24)
        }
    }

    private func temperaturePointColor(for day: CycleChartDay) -> Color {
        isBleedingDay(day.bleeding) ? .red : .pmPrimary
    }
    
    private var bleedingRow: some View {
        HStack(spacing: rowSpacing) {
            rowTitle(String(localized: "calendar.chart.bleedingShort"))

            ForEach(days) { day in
                Text(bleedingSymbol(for: day.bleeding))
                    .font(.caption)
                    .foregroundStyle(isBleedingDay(day.bleeding) ? Color.red : Color.pmTextPrimary)
                    .frame(width: cellWidth, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(bleedingCellBackground(for: day.bleeding))
                    )
            }
        }
    }
    
    // MARK: - Mucus row
    private var mucusRow: some View {
        HStack(spacing: rowSpacing) {
            rowTitle("Śluz")
            ForEach(days) { day in
                Text(mucusSymbol(for: day.mucusSensation))
                    .font(.caption)
                    .foregroundStyle(mucusColor(for: day.mucusSensation))
                    .frame(width: cellWidth, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(mucusCellBackground(for: day.mucusSensation))
                    )
            }
        }
    }

    // MARK: - Cervix row
    private var cervixRow: some View {
        HStack(spacing: rowSpacing) {
            rowTitle("SHOW")
            ForEach(days) { day in
                Text(cervixSymbol(fertilityScore: day.cervixFertilityScore))
                    .font(.caption)
                    .foregroundStyle(Color.pmTextPrimary)
                    .frame(width: cellWidth, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.pmSurface)
                    )
            }
        }
    }

    // MARK: - Intercourse row
    private var intercourseRow: some View {
        HStack(spacing: rowSpacing) {
            rowTitle("Int.")
            ForEach(days) { day in
                Text(intercourseSymbol(for: day.intercourse))
                    .font(.caption)
                    .foregroundStyle(day.intercourse != .none ? Color.pmPrimary : Color.pmTextSecondary.opacity(0.4))
                    .frame(width: cellWidth, height: 24)
            }
        }
    }

    // MARK: - Symbol helpers
    private func mucusSymbol(for value: MucusSensation) -> String {
        switch value {
        case .none:     return "–"
        case .dry:      return "○"
        case .damp:     return "◔"
        case .wet:      return "◑"
        case .slippery: return "●"
        }
    }

    private func mucusColor(for value: MucusSensation) -> Color {
        switch value {
        case .slippery: return .pmPrimary
        case .wet:      return .pmPrimary.opacity(0.75)
        default:        return .pmTextSecondary
        }
    }

    private func mucusCellBackground(for value: MucusSensation) -> Color {
        switch value {
        case .slippery: return Color.pmPrimary.opacity(0.14)
        case .wet:      return Color.pmPrimary.opacity(0.08)
        default:        return Color.pmSurface
        }
    }

    private func cervixSymbol(fertilityScore score: Int) -> String {
        switch score {
        case 0:    return "–"
        case 1...2: return "△"
        default:   return "▲"
        }
    }

    private func intercourseSymbol(for value: IntercourseType) -> String {
        switch value {
        case .none:        return ""
        case .unprotected: return "♥"
        case .protected:   return "○"
        }
    }
}
