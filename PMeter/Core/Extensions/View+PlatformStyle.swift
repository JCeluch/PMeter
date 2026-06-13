//
//  View+PlatformStyle.swift
//  PMeter
//
//  Created by JCeluch on 13/06/2026.
//

import SwiftUI

extension View {
    func platformFormListStyle() -> some View {
        #if os(iOS)
        self.listStyle(.insetGrouped)
        #else
        self.listStyle(.inset)
        #endif
    }
    
    func platformWheelPickerStyle() -> some View {
        #if os(iOS)
        self.pickerStyle(.wheel)
        #else
        self.pickerStyle(.menu)
        #endif
    }

}
