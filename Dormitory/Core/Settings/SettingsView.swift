//
//  SettingsView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignUpView: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Button("Вийти") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignUpView = true
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            
            Button("Скинути пароль") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        .navigationTitle("Налаштування")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Готово") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingsView(showSignUpView: .constant(false))
    }
}
