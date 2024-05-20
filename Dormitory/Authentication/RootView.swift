//
//  RootView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignUpView = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignUpView: $showSignUpView)
            }
        }
        .onAppear() {
            let authUser = try? AuthManager.shared.getAuthenticatedUser()
            self.showSignUpView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignUpView) {
            NavigationStack {
                AuthView(showSignUpView: $showSignUpView)
            }
        }
    }
}

#Preview {
    RootView()
}
