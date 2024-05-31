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
            TextField("Електронна адреса...", text: $viewModel.email)
                .modifiedField()
            SecureField("Пароль...", text: $viewModel.password)
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
                Text("Увійти")
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
                Text("Створити обліковий запис")
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
        .navigationTitle("Ласкаво просимо!")
        .textInputAutocapitalization(.never)
    }
}

#Preview {
    NavigationView {
        LogInEmailView(showSignUpView: .constant(true))
    }
}
