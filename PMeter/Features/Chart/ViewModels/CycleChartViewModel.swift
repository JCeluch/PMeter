//
//  CycleChartViewModel.swift
//  PMeter
//
//  Created by JCeluch on 11/06/2026.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class CycleChartViewModel {

    // MARK: - Output dla widoku
    private(set) var days: [CycleChartDay] = []
    private(set) var predictedCycleLength: Int = 28
    private(set) var isCurrentCycle: Bool = false
    private(set) var isLoading: Bool = false

    // MARK: - Cache
    private var cachedEntryIDs: [PersistentIdentifier] = []
    private var cachedAnchorDate: Date = .distantPast

    // MARK: - Refresh
    func refresh(entries: [CycleEntry], anchorDate: Date) {
        let ids = entries.map(\.persistentModelID)
        let sameAnchor = Calendar.current.isDate(anchorDate, inSameDayAs: cachedAnchorDate)
        guard ids != cachedEntryIDs || !sameAnchor else { return }

        cachedEntryIDs = ids
        cachedAnchorDate = anchorDate
        isLoading = days.isEmpty  // skeleton tylko przy pierwszym otwarciu

        Task.detached(priority: .userInitiated) { [entries, anchorDate] in
            let stats = CycleAnalyticsService.statistics(from: entries)
            let avg = stats.averageCycleLength

            let rawDays = CalendarHelper.cycleDays(containing: anchorDate, entries: entries)
            let rawCount = rawDays.count
            let predicted = avg > 0 ? max(Int(round(avg)), rawCount) : max(28, rawCount)

            let lastStart = CalendarHelper.cycleStartDate(for: .now, entries: entries)
            let anchorStart = CalendarHelper.cycleStartDate(for: anchorDate, entries: entries)

            let isCurrent: Bool
            if let l = lastStart, let a = anchorStart {
                isCurrent = CalendarHelper.isSameDay(l, a)
            } else {
                isCurrent = false
            }

            let finalDays: [CycleChartDay]
            if isCurrent {
                finalDays = CalendarHelper.cycleDaysWithPredictedPadding(
                    containing: anchorDate,
                    entries: entries,
                    predictedLength: predicted
                )
            } else {
                finalDays = rawDays
            }

            await MainActor.run {
                self.days = finalDays
                self.predictedCycleLength = predicted
                self.isCurrentCycle = isCurrent
                self.isLoading = false
            }
        }
    }
}
