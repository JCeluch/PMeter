import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(sort: \CycleEntry.date, order: .forward) private var entries: [CycleEntry]

    @State private var currentMonth = Date()
    @State private var selectedDate: CalendarDay?
    @State private var mode: CalendarMode = .chart
    @State private var entryFormTarget: EntryFormTarget?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("calendar.viewMode", selection: $mode) {
                        Text("calendar.mode.chart").tag(CalendarMode.chart)
                        Text("calendar.mode.month").tag(CalendarMode.month)
                    }
                    .pickerStyle(.segmented)

                    if mode == .chart {
                        CycleChartView(
                            entries: entries,
                            selectedDate: Binding(
                                get: { selectedDate?.date },
                                set: { newValue in
                                    if let newValue {
                                        let isCurrentMonth = Calendar.current.isDate(
                                            newValue,
                                            equalTo: currentMonth,
                                            toGranularity: .month
                                        )
                                        selectedDate = CalendarDay(date: newValue, isCurrentMonth: isCurrentMonth)
                                    } else {
                                        selectedDate = nil
                                    }
                                }
                            )
                        )
                    } else {
                        VStack(spacing: 16) {
                            monthHeader
                            weekHeader
                            monthGrid
                            cycleInfoCard
                        }
                    }
                }
                .padding()
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.pmBackground.ignoresSafeArea())
            .navigationTitle(L10n.Calendar.title)
            .inlineNavigationTitle()
            .toolbarTrailingItem {
                Button {
                    entryFormTarget = EntryFormTarget(date: Date())
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("calendar.addEntry")
            }
            .sheet(item: $selectedDate) { day in
                DayDetailSheetView(date: day.date, entries: entries)
            }
            .sheet(item: $entryFormTarget) { target in
                EntryFormView(
                    initialDate: target.date,
                    onSave: { savedDate in
                        openNextDayIfNeeded(after: savedDate)
                    }
                )
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 12)
            }
        }
    }

    private var monthHeader: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.pmPrimary)
                    .frame(width: 36, height: 36)
                    .background(Color.pmSurface)
                    .clipShape(Circle())
            }

            Spacer()

            Text(CalendarHelper.monthTitle(for: currentMonth))
                .font(.title3.bold())
                .foregroundStyle(Color.pmTextPrimary)

            Spacer()

            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.pmPrimary)
                    .frame(width: 36, height: 36)
                    .background(Color.pmSurface)
                    .clipShape(Circle())
            }
        }
    }

    private var weekHeader: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(CalendarHelper.weekDaySymbols(), id: \.self) { symbol in
                Text(symbol)
                    .font(.caption.bold())
                    .foregroundStyle(Color.pmTextSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var monthGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(CalendarHelper.visibleDays(for: currentMonth)) { day in
                CalendarDayCell(
                    day: day,
                    entries: entries,
                    onTap: { selectedDate = day },
                    onAddEntry: { entryFormTarget = EntryFormTarget(date: day.date) }
                )
            }
        }
    }

    private func dayCell(for day: CalendarDay) -> some View {
        let hasEntry = entries.contains { CalendarHelper.isSameDay($0.date, day.date) }
        let cycleDay = CalendarHelper.cycleDay(for: day.date, entries: entries)
        let isToday = Calendar.current.isDateInToday(day.date)

        return Button {
            selectedDate = day
        } label: {
            VStack(spacing: 6) {
                Text("\(CalendarHelper.dayNumber(day.date))")
                    .font(.subheadline.weight(isToday ? .bold : .regular))
                    .foregroundStyle(day.isCurrentMonth ? Color.pmTextPrimary : Color.pmTextSecondary)

                if let cycleDay {
                    Text("CD \(cycleDay)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.pmTextSecondary)
                } else {
                    Text(" ")
                        .font(.system(size: 10))
                }

                Circle()
                    .fill(hasEntry ? Color.pmPrimary : Color.clear)
                    .frame(width: 6, height: 6)
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.vertical, 8)
            .background(backgroundColor(for: day, isToday: isToday, cycleDay: cycleDay))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                entryFormTarget = EntryFormTarget(date: day.date)
            } label: {
                Label("calendar.addEntry", systemImage: "plus.circle")
            }
        }
    }

    private func backgroundColor(for day: CalendarDay, isToday: Bool, cycleDay: Int?) -> Color {
        if isToday {
            return .pmSurface
        }

        let entriesForDay = entries.filter { CalendarHelper.isSameDay($0.date, day.date) }

        if entriesForDay.contains(where: { $0.bleeding.indicatesCycleStart || $0.bleeding == .spotting }) {
            return .pmPeriod.opacity(0.18)
        }

        if let cycleDay, (10...17).contains(cycleDay) {
            return .pmFertile.opacity(0.18)
        }

        return day.isCurrentMonth ? .pmSurface : .pmSurface.opacity(0.55)
    }

    private var cycleInfoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.Calendar.previewTitle)
                .font(.headline)
                .foregroundStyle(Color.pmTextPrimary)

            if let todayCycleDay = CalendarHelper.cycleDay(for: .now, entries: entries) {
                Text("calendar.preview.todayCycleDay: \(todayCycleDay)")
                    .foregroundStyle(Color.pmTextPrimary)
            } else {
                Text(L10n.Calendar.previewNoData)
                    .foregroundStyle(Color.pmTextSecondary)
            }

            Text(L10n.Calendar.previewDescription)
                .font(.footnote)
                .foregroundStyle(Color.pmTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.pmSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
        }
    }

    private func openNextDayIfNeeded(after savedDate: Date) {
        let today = Calendar.current.startOfDay(for: Date())
        let saved = Calendar.current.startOfDay(for: savedDate)

        guard saved < today,
              let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: saved) else {
            entryFormTarget = nil
            return
        }

        if nextDay <= today {
            entryFormTarget = EntryFormTarget(date: nextDay)
        } else {
            entryFormTarget = nil
        }
    }

    enum CalendarMode: String, CaseIterable {
        case chart
        case month
    }
}

struct EntryFormTarget: Identifiable {
    let id = UUID()
    let date: Date
}
