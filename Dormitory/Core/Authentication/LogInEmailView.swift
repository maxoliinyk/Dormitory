//
//  LogInEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI

struct LogInEmailView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @ObservedObject var rootViewModel: RootViewModel

    var body: some View {
        VStack {
            TextField("Електронна адреса...", text: $viewModel.email)
                .modifiedField
            SecureField("Пароль...", text: $viewModel.password)
                .modifiedField
            
            Button {
                Task {
                    do {
                        try await viewModel.signIn()
                        await rootViewModel.loadUserData()
                    } catch {
                        print("Error: \(error)")
                    }
                }
            } label: {
                Text("Увійти")
                    .proceedButton
            }
            
            NavigationLink {
                SignUpEmailView(viewModel: viewModel, rootViewModel: rootViewModel)
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
        LogInEmailView(rootViewModel: RootViewModel())
    }
}
