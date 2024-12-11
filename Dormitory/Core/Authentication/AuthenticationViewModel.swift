//
//  AuthenticationViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 09.12.2024.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var lastName = ""
    @Published var roomNumber = ""
    @Published var dormitoryID: DormitoryIDs = .dormitory1
    @Published var isAdmin = false
    @Published var authenticationError: String?
    @Published var isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            authenticationError = "Email or password is empty"
            throw AuthError.invalidCredentials
        }
        _ = try await AuthManager.shared.signInUser(email: email, password: password)
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        isAuthenticated = true
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            authenticationError = "Please fill all required fields"
            throw AuthError.invalidCredentials
        }
        
        let authDataResult = try await AuthManager.shared.createUser(email: email, password: password)
        let user = DBUser(userID: authDataResult.uid,
                         email: authDataResult.email,
                         name: name,
                         lastName: lastName,
                         roomNumber: roomNumber,
                         dormitoryID: dormitoryID.rawValue,
                         isAdmin: isAdmin)
        try await UserManager.shared.createNewUser(user: user)
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        isAuthenticated = true
    }
    
    func signOut() throws {
        try AuthManager.shared.signOut()
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        isAuthenticated = false
    }
    
    func resetPassword() async throws {
        let authUser = try AuthManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthManager.shared.resetPassword(email: email)
    }
    
    func resetFields() {
        email = ""
        password = ""
        name = ""
        lastName = ""
        roomNumber = ""
        dormitoryID = .dormitory1
        authenticationError = nil
    }
}

enum AuthError: Error {
    case invalidCredentials
}
