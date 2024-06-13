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
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
                        alertMessage = "Електронна адреса чи пароль невірні."
                        showingAlert = true
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
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Помилка авторизації"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            NavigationLink {
                SignUpEmailView(showSignUpView: $showSignUpView)
            } label: {
                Text("Створити обліковий запис")
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
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
