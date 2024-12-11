//
//  LogInEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI

struct LogInEmailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Електронна адреса...", text: $authViewModel.email)
                .modifiedField
            SecureField("Пароль...", text: $authViewModel.password)
                .modifiedField
            
            Button {
                Task {
                    do {
                        try await authViewModel.signIn()
                        await authViewModel.loadUserData()
                    } catch {
                        print("Error: \(error)")
                    }
                }
            } label: {
                Text("Увійти")
                    .proceedButton
            }
            
            NavigationLink {
                SignUpEmailView()
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
    NavigationStack {
        LogInEmailView()
    }
}
