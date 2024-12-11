//
//  RootViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 09.12.2024.
//

import Foundation

@MainActor
class RootViewModel: ObservableObject {
    @Published var isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
    @Published var isAdmin = false
    @Published var dormitoryID: String?
    @Published var isLoading = false
    @Published var showSignUpView = false
    
    init() {
        if isAuthenticated {
            Task { await loadUserData() }
        }
    }
    
    func loadUserData() async {
        isLoading = true
        do {
            let authUser = try AuthManager.shared.getAuthenticatedUser()
            let dbUser = try await UserManager.shared.getUser(userID: authUser.uid)
            isAdmin = dbUser.isAdmin
            dormitoryID = dbUser.dormitoryID
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            isAuthenticated = false
            UserDefaults.standard.set(false, forKey: "isAuthenticated")
        }
        isLoading = false
    }
}
