//
//  AddEntryView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    var body: some View {
        EntryFormView(existingEntry: nil)
    }
}

//#Preview {
//    AddEntryView()
//        .modelContainer(for: CycleEntry.self, inMemory: true)
//}
