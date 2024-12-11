//
//  SignUpEmailView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct SignUpEmailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    private var isFormValid: Bool {
        !authViewModel.email.isEmpty &&
        !authViewModel.password.isEmpty &&
        !authViewModel.name.isEmpty &&
        !authViewModel.lastName.isEmpty &&
        !authViewModel.roomNumber.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Електронна адреса...", text: $authViewModel.email)
                    .keyboardType(.emailAddress)
                    .modifiedField
                    .textInputAutocapitalization(.never)
                
                SecureField("Пароль...", text: $authViewModel.password)
                    .modifiedField
                    .textInputAutocapitalization(.never)
                
                TextField("Імʼя...", text: $authViewModel.name)
                    .keyboardType(.default)
                    .modifiedField
                
                TextField("Прізвище...", text: $authViewModel.lastName)
                    .keyboardType(.default)
                    .modifiedField
                
                Picker("Гуртожиток", selection: $authViewModel.dormitoryID) {
                    ForEach(DormitoryIDs.allCases) { dormitory in
                        Text(dormitory.displayName).tag(dormitory)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .modifiedField
                
                TextField("Номер кімнати...", text: $authViewModel.roomNumber)
                    .keyboardType(.numberPad)
                    .modifiedField
                
                Button {
                    if isFormValid {
                        Task {
                            do {
                                try await authViewModel.signUp()
                                await authViewModel.loadUserData()
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
        SignUpEmailView()
    }
}
