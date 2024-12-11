//
//  BaseViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 12.12.2024.
//

import Foundation
import Firebase

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: DBUser?
    
    func loadCurrentUser() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let authUser = try AuthManager.shared.getAuthenticatedUser()
            currentUser = try await UserManager.shared.getUser(userID: authUser.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func formatDate(from timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
