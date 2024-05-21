//
//  SignUpEmailViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation

@MainActor
final class SignUpEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var lastName = ""
    @Published var roomNumber = ""
    @Published var dormitoryNumber = ""
    @Published var isAdmin = false
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        guard !name.isEmpty else {
            print("Enter the name.")
            return
        }
        
        do {
            let authDataResult = try await AuthManager.shared.createUser(email: email, password: password)
            
            try await UserManager.shared.createNewUser(auth: authDataResult, name: name, lastName: lastName, roomNumber: roomNumber, dormitoryNumber: dormitoryNumber, isAdmin: isAdmin)
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is wrong")
            
            throw URLError(.badURL)
        }
        
        
        try await AuthManager.shared.signInUser(email: email, password: password)
    }
}
