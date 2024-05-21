//
//  LogInEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI

struct LogInEmailView: View {
    
    @StateObject var viewModel = SignUpEmailViewModel()
    @Binding var showSignUpView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .modifiedField()
            SecureField("Password...", text: $viewModel.password)
                .modifiedField()
            
            Button {
                Task {
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
                Text("Log in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            NavigationLink {
                SignUpEmailView(showSignUpView: $showSignUpView)
            } label: {
                Text("Create an account")
                    .font(.headline)
//                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
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
        LogInEmailView(showSignUpView: .constant(true))
    }
}
