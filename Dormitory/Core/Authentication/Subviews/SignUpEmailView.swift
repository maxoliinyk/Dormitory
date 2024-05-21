//
//  SignUpEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct SignUpEmailView: View {
    
    @StateObject var viewModel = SignUpEmailViewModel()
    @Binding var showSignUpView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .modifiedField()
            SecureField("Password...", text: $viewModel.password)
                .modifiedField()
            TextField("Name...", text: $viewModel.name)
                .modifiedField()
            TextField("Last name...", text: $viewModel.lastName)
                .modifiedField()
            TextField("Dormitory number...", text: $viewModel.dormitoryNumber)
                .modifiedField()
            TextField("Room number...", text: $viewModel.roomNumber)
                .modifiedField()
            
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

struct ModifiedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
}

extension View {
    func modifiedField() -> some View {
        modifier(ModifiedTextField())
    }
}

#Preview {
    NavigationStack {
        SignUpEmailView(showSignUpView: .constant(true))
    }
}
