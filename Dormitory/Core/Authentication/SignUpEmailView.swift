//
//  SignUpEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct SignUpEmailView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @ObservedObject var rootViewModel: RootViewModel
    
    private var isFormValid: Bool {
        !viewModel.email.isEmpty &&
        !viewModel.password.isEmpty &&
        !viewModel.name.isEmpty &&
        !viewModel.lastName.isEmpty &&
        !viewModel.roomNumber.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Електронна адреса...", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .modifiedField
                    .textInputAutocapitalization(.never)
                
                SecureField("Пароль...", text: $viewModel.password)
                    .modifiedField
                    .textInputAutocapitalization(.never)
                
                TextField("Імʼя...", text: $viewModel.name)
                    .keyboardType(.default)
                    .modifiedField
                
                TextField("Прізвище...", text: $viewModel.lastName)
                    .keyboardType(.default)
                    .modifiedField
                
                Picker("Гуртожиток", selection: $viewModel.dormitoryID) {
                    ForEach(DormitoryIDs.allCases) { dormitory in
                        Text(dormitory.displayName).tag(dormitory)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .modifiedField
                
                TextField("Номер кімнати...", text: $viewModel.roomNumber)
                    .keyboardType(.numberPad)
                    .modifiedField
                
                Button {
                    if isFormValid {
                        Task {
                            do {
                                try await viewModel.signUp()
                                await rootViewModel.loadUserData()
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                } label: {
                    Text("Створити обліковий запис")
                        .proceedButton
                }
            }
            .padding()
            .navigationTitle("Створення акаунту")
        }
    }
}

#Preview {
    NavigationStack {
        SignUpEmailView(viewModel: AuthenticationViewModel(), rootViewModel: RootViewModel())
    }
}
