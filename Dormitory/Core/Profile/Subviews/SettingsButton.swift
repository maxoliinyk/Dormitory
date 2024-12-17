//
//  SettingsButton.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct SettingsButton: View {
    @Binding var showingSettings: Bool
    
    var body: some View {
        Button("Settings", systemImage: "gear") {
            showingSettings = true
        }
        .font(.headline)
    }
}
