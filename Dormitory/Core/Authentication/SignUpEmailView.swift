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
                    .modifiedField()
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                SecureField("Пароль...", text: $viewModel.password)
                    .modifiedField()
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                TextField("Імʼя...", text: $viewModel.name)
                    .keyboardType(.default)
                    .modifiedField()
                    .autocorrectionDisabled(true)
                
                TextField("Прізвище...", text: $viewModel.lastName)
                    .keyboardType(.default)
                    .modifiedField()
                    .autocorrectionDisabled(true)
                
                Picker("Гуртожиток", selection: $viewModel.dormitoryID) {
                    ForEach(DormitoryIDs.allCases) { dormitory in
                        Text(dormitory.displayName).tag(dormitory)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .modifiedField()
                
                TextField("Номер кімнати...", text: $viewModel.roomNumber)
                    .keyboardType(.numberPad)
                    .modifiedField()
                    .autocorrectionDisabled(true)
                
                Button {
                    if isFormValid {
                        Task {
                            do {
                                try await viewModel.signUp()
                                print("User created successfully!")
                                showSignUpView = false
                                return
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                } label: {
                    Text("Створити обліковий запис")
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
            .navigationTitle("Створення акаунту")
        }
    }
}

#Preview {
    NavigationView {
        SignUpEmailView(showSignUpView: .constant(true))
    }
}
