//
//  RootView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                NavigationStack {
                        if authViewModel.isAdmin {
                            AdminNotificationView()
                        } else {
                            UserNotificationView(dormitoryID: authViewModel.dormitoryID)
                        }
                }
            } else {
                NavigationStack {
                    LogInEmailView()
                }
            }
        }
        .overlay {
            if authViewModel.isLoading {
                ProgressView("Loading...")
            }
        }
    }
}

#Preview {
    RootView()
}

