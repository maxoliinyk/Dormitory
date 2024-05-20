//
//  SignUpEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

@MainActor
final class SignUpEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is wrong")
            return
        }
        
        try await AuthManager.shared.signInUser(email: email, password: password)
    }
}

struct SignUpEmailView: View {
    
    @StateObject var viewModel = SignUpEmailViewModel()
    @Binding var showSignUpView: Bool

    var body: some View {
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            print("User created successfully!")
                            showSignUpView = false
                            return
                        } catch {
                            print("Error: \(error)")
                        }
                        
                        do {
                            try await viewModel.signIn()
                            print("Successful log in!")
                            showSignUpView = false
                            return
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up With Email")
            .textInputAutocapitalization(.never)

    }
}

#Preview {
    NavigationStack {
        SignUpEmailView(showSignUpView: .constant(true))
    }
}
