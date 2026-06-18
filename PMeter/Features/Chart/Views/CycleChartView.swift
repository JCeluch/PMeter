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
    @State private var vm = CycleChartViewModel()
    
    @State private var chartPlotOriginX: CGFloat = 0
    @State private var chartPlotWidth: CGFloat = 0
    
    private let cellWidth: CGFloat = 32
    private let rowSpacing: CGFloat = 8
    
    private var days: [CycleChartDay] { vm.days }

    // MARK: - Minimalna szerokość = max(obliczona, szerokość ekranu)
    private var gridWidth: CGFloat {
        let count = CGFloat(days.count)
        guard count > 0 else { return UIScreen.main.bounds.width }
        let computed = count * cellWidth + max(0, count - 1) * rowSpacing
        return max(computed, UIScreen.main.bounds.width)
    }
    
    private var chartOnlyWidth: CGFloat {
        let count = CGFloat(days.count)
        guard count > 0 else { return 0 }
        return count * cellWidth + max(0, count - 1) * rowSpacing
    }

    private var temperatureDays: [CycleChartDay] {
        days.filter { $0.temperature != nil }
    }
    
    // Obliczony slot na podstawie rzeczywistego plot area
    private var slotWidth: CGFloat {
        guard days.count > 0, chartPlotWidth > 0 else {
            return cellWidth
        }
        return chartPlotWidth / CGFloat(days.count)
    }

    // Lewy padding rzędów = tyle co oś Y chartu
    private var rowLeadingPadding: CGFloat {
        chartPlotOriginX > 0 ? chartPlotOriginX : cellWidth
    }
    
    private var xScalePadding: CGFloat {
        guard chartPlotWidth > 0, days.count > 0 else { return cellWidth / 2 }
        return (chartPlotWidth / CGFloat(days.count)) / 2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if days.filter({ !$0.isPlaceholder }).isEmpty {
                ContentUnavailableView(
                    L10n.Calendar.emptyTitle,
                    systemImage: "waveform.path.ecg",
                    description: Text(L10n.Calendar.emptyDescription)
                )
            } else if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
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
                        energyRow
                        sleepRow
                        weightRow
                    }
                    .padding(.bottom, 8)
                    .frame(minWidth: gridWidth, alignment: .leading)
                }
                .id(anchorDate)
            }
        }
        .padding()
        .background(Color.pmBackground)
        .task(id: anchorDate) {
            vm.refresh(entries: entries, anchorDate: anchorDate)
        }
        .task(id: entries.map(\.persistentModelID).hashValue) {
            vm.refresh(entries: entries, anchorDate: anchorDate)
        }
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
        HStack(spacing: 0) {
            rowTitle(String(localized: "calendar.cycleDay.label"))
                .frame(width: rowLeadingPadding, alignment: .leading)

            ForEach(days) { day in
                if day.isPlaceholder {
                    Text("·")
                        .font(.caption.weight(.semibold))
                        .frame(width: slotWidth, height: 28)
                        .foregroundStyle(Color.pmTextSecondary.opacity(0.3))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.pmSurface.opacity(0.5))
                                .strokeBorder(
                                    Color.pmTextSecondary.opacity(0.1),
                                    lineWidth: 0.5
                                )
                        )
                } else {
                    Button {
                        selectedDate = day.date
                    } label: {
                        Text("\(day.cycleDay)")
                            .font(.caption.weight(.semibold))
                            .frame(width: slotWidth, height: 28)
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
    }
    
    private var dateRow: some View {
        HStack(spacing: 0) {
            rowTitle(String(localized: "calendar.chart.dateShort"))
                .frame(width: rowLeadingPadding, alignment: .leading)

            ForEach(days) { day in
                Text(day.isPlaceholder ? "?" : day.date.formatted(.dateTime.day()))
                    .font(.caption2)
                    .frame(width: slotWidth, height: 28)
                    .foregroundStyle(
                        day.isPlaceholder
                            ? Color.pmTextSecondary.opacity(0.25)
                            : Color.pmTextSecondary
                    )
            }
        }
    }

    private var temperatureChart: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: rowSpacing) {
                rowTitle(String(localized: "calendar.chart.temperatureShort"))
                Text(L10n.ChartEnums.tempUnit)
                    .font(.caption)
                    .foregroundStyle(Color.pmTextSecondary)
            }

            Chart(temperatureDays) { day in
                if let temperature = day.temperature {
                    let xLabel = String(localized: "calendar.cycleDay.label")
                    let yLabel = String(localized: "calendar.chart.temperature")
                    let pointColor = temperaturePointColor(for: day)
                    
                    LineMark(
                        x: .value(xLabel, day.cycleDay),
                        y: .value(yLabel, temperature)
                    )
                    .foregroundStyle(Color.pmPrimary)
                    .interpolationMethod(.linear)

                    PointMark(
                        x: .value(xLabel, day.cycleDay),
                        y: .value(yLabel, temperature)
                    )
                    .foregroundStyle(pointColor)
                    .symbolSize(40)
                }
            }
            .frame(height: 320)
            .chartXScale(
                domain: (days.first?.cycleDay ?? 1)...(days.last?.cycleDay ?? 1),
                range: .plotDimension(padding: xScalePadding)
            )
            .chartYScale(domain: yDomain, range: .plotDimension(padding: 12))
            .chartXAxis {
                AxisMarks(values: days.map(\.cycleDay)) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.pmTextSecondary.opacity(0.15))
                    AxisTick()
                    AxisValueLabel {
                        if let day = value.as(Int.self) {
                            Text("\(day)").font(.caption2)
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
                            let label = String(format: "%.2f", temp)
                            Text(label)
                                .font(.caption2)
                                .foregroundStyle(Color.pmTextSecondary)
                        }
                    }
                }
            }
            // ← Tu mierzymy rzeczywistą pozycję i szerokość plot area
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            updatePlotMetrics(proxy: proxy, geo: geo)
                        }
                        .onChange(of: days.map(\.cycleDay)) {
                            updatePlotMetrics(proxy: proxy, geo: geo)
                        }
                }
            }
        }
    }
    
    private func updatePlotMetrics(proxy: ChartProxy, geo: GeometryProxy) {
        guard let anchor = proxy.plotFrame else { return }
        let frame = geo[anchor]
        chartPlotOriginX = frame.minX
        chartPlotWidth   = frame.width
    }

    private func observationRow(title: String, values: [String]) -> some View {
        HStack(spacing: 0) {
            rowTitle(title)
                .frame(width: rowLeadingPadding, alignment: .leading)

            ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                Text(value.isEmpty ? "–" : value)
                    .font(.caption)
                    .foregroundStyle(Color.pmTextPrimary)
                    .frame(width: slotWidth, height: 28)
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
        HStack(spacing: 0) {
            rowTitle(String(localized: "calendar.chart.bleedingShort"))
                .frame(width: rowLeadingPadding, alignment: .leading)

            ForEach(days) { day in
                Text(bleedingSymbol(for: day.bleeding))
                    .font(.caption)
                    .foregroundStyle(isBleedingDay(day.bleeding) ? Color.red : Color.pmTextPrimary)
                    .frame(width: slotWidth, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(bleedingCellBackground(for: day.bleeding))
                    )
            }
        }
    }
    
    // MARK: - Mucus row
    private var mucusRow: some View {
        HStack(spacing: 0) {
            rowTitle(String(localized: "calendar.chart.mucus"))
                .frame(width: rowLeadingPadding, alignment: .leading)
            
            ForEach(days) { day in
                Text(day.isPlaceholder ? "?" : mucusSymbol(for: day.mucusSensation))
                    .font(.caption)
                    .foregroundStyle(mucusColor(for: day.mucusSensation))
                    .frame(width: slotWidth, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                day.isPeakDay
                                    ? Color.pmPrimary.opacity(0.22)
                                    : mucusCellBackground(for: day.mucusSensation)
                            )
                            .overlay(
                                day.isPeakDay
                                    ? RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(Color.pmPrimary.opacity(0.5), lineWidth: 1)
                                    : nil
                            )
                    )
            }
        }
    }

    // MARK: - Cervix row
    private var cervixRow: some View {
        HStack(spacing: 0) {
            rowTitle(String(localized: "calendar.chart.cervix"))
                .frame(width: rowLeadingPadding, alignment: .leading)
            ForEach(days) { day in
                Text(day.isPlaceholder ? "?" : cervixSymbol(fertilityScore: day.cervixFertilityScore))
                    .font(.caption)
                    .foregroundStyle(Color.pmTextPrimary)
                    .frame(width: slotWidth, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.pmSurface)
                    )
            }
        }
    }

    // MARK: - Intercourse row
    private var intercourseRow: some View {
        HStack(spacing: 0) {
            rowTitle(String(localized: "calendar.chart.intercourse"))
                .frame(width: rowLeadingPadding, alignment: .leading)
            ForEach(days) { day in
                Text(day.isPlaceholder ? "?" : intercourseSymbol(for: day.intercourse))
                    .font(.caption)
                    .foregroundStyle(day.intercourse != .none ? Color.pmPrimary : Color.pmTextSecondary.opacity(0.4))
                    .frame(width: slotWidth, height: 28)
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
    
    // MARK: - Energy row
    private var energyRow: some View {
        HStack(spacing: 0) {
            rowTitle("⚡")
                .frame(width: rowLeadingPadding, alignment: .leading)
            ForEach(days) { day in
                let value = day.energyLevel
                Text(value > 0 ? "\(value)" : "–")
                    .font(.caption)
                    .foregroundStyle(energyColor(for: value))
                    .frame(width: slotWidth, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(value > 0 ? energyColor(for: value).opacity(0.12) : Color.pmSurface)
                    )
            }
        }
    }

    // MARK: - Sleep row
    private var sleepRow: some View {
        HStack(spacing: 0) {
            rowTitle("💤")
                .frame(width: rowLeadingPadding, alignment: .leading)
            ForEach(days) { day in
                let value = day.sleepQuality
                Text(value > 0 ? "\(value)" : "–")
                    .font(.caption)
                    .foregroundStyle(sleepColor(for: value))
                    .frame(width: slotWidth, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(value > 0 ? sleepColor(for: value).opacity(0.12) : Color.pmSurface)
                    )
            }
        }
    }

    // MARK: - Weight row
    private var weightRow: some View {
        HStack(spacing: 0) {
            rowTitle("kg")
                .frame(width: rowLeadingPadding, alignment: .leading)
            ForEach(days) { day in
                if let w = day.weight {
                    Text(String(format: "%.1f", w))
                        .font(.system(size: 9))
                        .foregroundStyle(Color.pmTextPrimary)
                        .frame(width: slotWidth, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.pmSurface)
                        )
                } else {
                    Text("–")
                        .font(.caption)
                        .foregroundStyle(Color.pmTextSecondary.opacity(0.3))
                        .frame(width: slotWidth, height: 28)
                }
            }
        }
    }
    
    private func energyColor(for value: Int) -> Color {
        switch value {
        case 1: return .orange
        case 2: return .yellow
        case 3: return .pmTextSecondary
        case 4: return .pmPrimary.opacity(0.8)
        case 5: return .pmPrimary
        default: return .pmTextSecondary
        }
    }

    private func sleepColor(for value: Int) -> Color {
        switch value {
        case 1: return .red.opacity(0.7)
        case 2: return .orange
        case 3: return .pmTextSecondary
        case 4: return .pmPrimary.opacity(0.7)
        case 5: return .pmPrimary
        default: return .pmTextSecondary
        }
    }
}
