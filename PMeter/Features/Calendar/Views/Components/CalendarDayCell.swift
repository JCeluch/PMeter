//
//  CalendarDayCell.swift
//  PMeter
//
//  Created by JCeluch on 14/06/2026.
//

import SwiftUI

struct CalendarDayCell: View {
    let day: CalendarDay
    let dayEntries: [CycleEntry]
    let cycleDay: Int?
    let fertileKind: CalendarViewModel.FertileDayKind
    let isPredictedPeriod: Bool
    let onTap: () -> Void
    let onAddEntry: () -> Void

    private var entriesForDay: [CycleEntry] {
        dayEntries
    }

    private var isToday: Bool {
        Calendar.current.isDateInToday(day.date)
    }

    // Najsilniejszy poziom krwawienia w tym dniu
    private var bleedingLevel: BleedingLevel {
        entriesForDay
            .map(\.bleeding)
            .max(by: { $0.sortOrder < $1.sortOrder }) ?? .none
    }

    private var hasPeakDay: Bool {
        entriesForDay.contains { $0.isPeakDay }
    }

    private var hasIntermenstrualSpotting: Bool {
        entriesForDay.contains { $0.intermenstrualSpotting }
    }

    private var hasEntry: Bool { !entriesForDay.isEmpty }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                // Dzień miesiąca
                Text("\(CalendarHelper.dayNumber(day.date))")
                    .font(.subheadline.weight(isToday ? .bold : .regular))
                    .foregroundStyle(day.isCurrentMonth ? Color.pmTextPrimary : Color.pmTextSecondary)

                // Dzień cyklu
                if let cycleDay {
                    Text("CD\(cycleDay)")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color.pmTextSecondary)
                } else {
                    Text(" ").font(.system(size: 9))
                }

                // Wskaźniki (dot row)
                HStack(spacing: 3) {
                    // Kropka wejścia / krwawienia
                    if bleedingLevel != .none {
                        Circle()
                            .fill(bleedingDotColor)
                            .frame(width: 5, height: 5)
                    } else if hasEntry {
                        Circle()
                            .fill(Color.pmPrimary)
                            .frame(width: 5, height: 5)
                    }

                    // Peak day
                    if hasPeakDay {
                        Image(systemName: "p.circle.fill")
                            .font(.system(size: 7))
                            .foregroundStyle(Color.pmPrimary)
                    }

                    // Plamienie śródcykliczne
                    if hasIntermenstrualSpotting {
                        Circle()
                            .fill(Color.orange.opacity(0.8))
                            .frame(width: 4, height: 4)
                    }
                }
                .frame(height: 8)
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.vertical, 6)
            .background(cellBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                Group {
                    if showDashedBorder {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                overlayStroke,
                                style: StrokeStyle(lineWidth: 1, dash: [4, 3])
                            )
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                onAddEntry()
            } label: {
                Label("calendar.addEntry", systemImage: "plus.circle")
            }
        }
    }

    // MARK: - Colors

    private var bleedingDotColor: Color {
        switch bleedingLevel {
        case .heavy, .medium: return .red
        case .light:          return .red.opacity(0.7)
        case .spotting:       return .red.opacity(0.45)
        default:              return .clear
        }
    }

    private var cellBackground: Color {
        if isToday { return .pmSurface }

        if bleedingLevel.indicatesCycleStart || bleedingLevel == .spotting || hasIntermenstrualSpotting {
            return .pmPeriod.opacity(bleedingLevel == .heavy ? 0.22 : 0.14)
        }

        if hasPeakDay {
            return .pmPrimary.opacity(0.14)
        }

//        if let cycleDay, (10...17).contains(cycleDay) {
//            return .pmFertile.opacity(0.15)
//        }
        
        switch fertileKind {
        case .confirmed:    return .pmFertile.opacity(0.18)
        case .estimated:    return .pmFertile.opacity(0.09)
        case .predicted:    return .pmFertile.opacity(0.07)
        case .none:         break
        }
        
        if isPredictedPeriod {
            return .pmPeriod.opacity(0.07)
        }

        return day.isCurrentMonth ? .pmSurface : .pmSurface.opacity(0.55)
    }
    
    private var overlayStroke: Color {
        switch fertileKind {
        case .predicted:    return .pmFertile.opacity(0.5)
        case .estimated:    return .pmFertile.opacity(0.3)
        case .none where isPredictedPeriod: return .pmPeriod.opacity(0.5)
        default:            return .clear
        }
    }
    
    private var showDashedBorder: Bool {
        switch fertileKind {
        case .estimated, .predicted: return true
        default: return isPredictedPeriod
        }
    }
}
