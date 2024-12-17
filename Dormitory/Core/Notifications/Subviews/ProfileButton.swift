//
//  ProfileButton.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct ProfileButton: View {
    @Binding var showingProfile: Bool
    
    var body: some View {
        Button("Profile", systemImage: "person.circle") {
            showingProfile = true
        }
        .font(.headline)
    }
}
