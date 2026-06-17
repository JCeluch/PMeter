//
//  AppRootVieww.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            CycleHomeView()
                .tabItem {
                    Label {
                        Text(L10n.Tabs.cycle)
                    } icon: {
                        Image(systemName: "drop.circle")
                    }
                }

            CalendarView()
                .tabItem {
                    Label {
                        Text(L10n.Tabs.calendar)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
            
            InsightsView()
                .tabItem {
                    Label("Wnioski", systemImage: "lightbulb.fill")
                }

            StatsView()
                .tabItem {
                    Label {
                        Text(L10n.Tabs.stats)
                    } icon: {
                        Image(systemName: "chart.pie")
                    }
                }
            
            EducationHomeView()
                .tabItem {
                    Label {
                        Text(L10n.Tabs.education)
                    } icon: {
                        Image(systemName: "book.circle")
                    }
                }
            
            SettingsView()
                .tabItem {
                    Label {
                        Text(L10n.Tabs.settings)
                    } icon: {
                        Image(systemName: "gearshape")
                    }
                }
        }
        .tint(.pmPrimary)
    }
}


//#Preview {
//    AppRootView()
//}
