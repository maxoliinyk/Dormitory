//
//  AuthView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct AuthView: View {
    
    @Binding var showSignUpView: Bool

    var body: some View {
        VStack {
            NavigationLink {
                LogInEmailView(showSignUpView: $showSignUpView)
            } label: {
                Text("Continue With Email")
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
        .navigationTitle("Ласкаво просимо!")
    }
}

#Preview {
    NavigationStack {
        AuthView(showSignUpView: .constant(true))
    }
}
