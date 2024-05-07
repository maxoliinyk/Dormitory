//
//  LoginView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 07.05.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    private var isLoginButtonDisabled: Bool {
        username.isEmpty || password.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.title.bold())
            
            // TextFields
            VStack {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
            Button("Login") {
                print(
                    """
                    username: \(username)
                    password: \(password)
                    """
                )
            }
            .frame(width: 250, height: 50)
            .font(.title2.bold())
            .foregroundStyle(.primary)
            .background(Color(.systemBlue))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .disabled(isLoginButtonDisabled)
        }
    }
}

#Preview {
    LoginView()
}
