//
//  View+Navigation.swift
//  PMeter
//
//  Created by JCeluch on 13/06/2026.
//

import SwiftUI

extension View {
    /// Zamiennik dla .navigationBarTitleDisplayMode — na macOS jest ignorowany
    func inlineNavigationTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    /// Zamiennik dla ToolbarItem(placement: .topBarTrailing)
    func toolbarTrailingItem<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) { content() }
            #else
            ToolbarItem(placement: .automatic) { content() }
            #endif
        }
    }
    
    func platformEditorToolbar<Leading: View, Trailing: View>(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarLeading) { leading() }
            ToolbarItem(placement: .topBarTrailing) { trailing() }
            #else
            ToolbarItem(placement: .cancellationAction) { leading() }
            ToolbarItem(placement: .confirmationAction) { trailing() }
            #endif
        }
    }

    func iosKeyboardDoneToolbar(action: @escaping () -> Void) -> some View {
        toolbar {
            #if os(iOS)
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L10n.Common.done) {
                    action()
                }
            }
            #endif
        }
    }

}
