//
//  SettingsView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Button("Вийти") {
                Task {
                    do {
                        try authViewModel.signOut()
                        authViewModel.showSignUpView = true
                        authViewModel.isAuthenticated = false
                        dismiss()
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            
            Button("Скинути пароль") {
                Task {
                    do {
                        try await authViewModel.resetPassword()
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
    NavigationStack {
        SettingsView()
    }
}
