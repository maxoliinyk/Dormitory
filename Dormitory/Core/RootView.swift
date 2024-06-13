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
    @State private var dormitoryID: String?
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            NavigationView {
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    if isAdmin {
                        AdminNotificationView(showSignUpView: $showSignUpView)
                    } else {
                        UserNotificationView(showSignUpView: $showSignUpView, dormitoryID: dormitoryID ?? "dormitory1")
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await loadUserData()
            }
        }
        .fullScreenCover(isPresented: $showSignUpView) {
            NavigationView {
                LogInEmailView(showSignUpView: $showSignUpView)
            }
        }
    }
    
    private func loadUserData() async {
        do {
            let authUser = try AuthManager.shared.getAuthenticatedUser()
            let dbUser = try await UserManager.shared.getUser(userID: authUser.uid)
            self.isAdmin = dbUser.isAdmin
            self.dormitoryID = dbUser.dormitoryID
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            self.showSignUpView = true
        }
        self.isLoading = false
    }
}

#Preview {
    RootView()
}

