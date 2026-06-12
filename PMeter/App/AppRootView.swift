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

            StatsView()
                .tabItem {
                    Label {
                        Text(L10n.Tabs.stats)
                    } icon: {
                        Image(systemName: "chart.pie")
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
