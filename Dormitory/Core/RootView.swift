//
//  RootView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignUpView = false
    @State private var isAdmin = false
    @State private var isLoading = true // Added loading state
    
    var body: some View {
        ZStack {
            NavigationStack {
//                DormitoriesView()
                if isLoading {
                    ProgressView("Loading...") // Show a loading indicator while fetching user data
                } else {
                    if isAdmin {
                        AdminNotificationView(showSignUpView: $showSignUpView)
                    } else {
                        UserNotificationView(showSignUpView: $showSignUpView)
                    }
                }
//                ProfileView(showSignUpView: $showSignUpView)
            }
        }
        .onAppear() {
            Task {
                await loadUserData()
            }
        }
        .fullScreenCover(isPresented: $showSignUpView) {
            NavigationStack {
                AuthView(showSignUpView: $showSignUpView)
            }
        }
    }
    
    private func loadUserData() async {
        do {
            let authUser = try AuthManager.shared.getAuthenticatedUser()
            let dbUser = try await UserManager.shared.getUser(userID: authUser.uid)
            self.isAdmin = dbUser.isAdmin
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            self.showSignUpView = true
        }
        self.isLoading = false // Set loading state to false after fetching user data
    }
}

#Preview {
    RootView()
}
