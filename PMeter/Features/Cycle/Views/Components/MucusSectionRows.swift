//
//  MucusSectionRows.swift
//  PMeter
//
//  The four mucus dimensions shown inside the always-visible mucus section.
//
//  Created by JCeluch on 13/06/2026.
//

import SwiftUI

struct MucusSectionRows: View {
    @Binding var sensation: MucusSensation
    @Binding var appearance: MucusAppearance
    @Binding var stretch: MucusStretch
    @Binding var volume: MucusVolume
    @Binding var isPeakDay: Bool

    var body: some View {
        // Odczucie — Billings-first, najważniejsze
        Picker(L10n.CycleForm.mucusSensation, selection: $sensation) {
            ForEach(MucusSensation.allCases, id: \.self) { o in
                Text(o.localizationKey).tag(o)
            }
        }

        Picker(L10n.CycleForm.mucusAppearance, selection: $appearance) {
            ForEach(MucusAppearance.allCases, id: \.self) { o in
                Text(o.localizationKey).tag(o)
            }
        }

        Picker(L10n.CycleForm.mucusStretch, selection: $stretch) {
            ForEach(MucusStretch.allCases, id: \.self) { o in
                Text(o.localizationKey).tag(o)
            }
        }

        Picker(L10n.CycleForm.mucusVolume, selection: $volume) {
            ForEach(MucusVolume.allCases, id: \.self) { o in
                Text(o.localizationKey).tag(o)
            }
        }

        Toggle(L10n.CycleForm.isPeakDay, isOn: $isPeakDay)
            .tint(Color.pmPrimary)
    }
}
