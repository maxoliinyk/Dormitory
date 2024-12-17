//
//  ProfileView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var requestViewModel: RequestViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showingSettings = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if let user = profileViewModel.user,
               let dormitory = profileViewModel.dormitory,
               let dormitoryID = DormitoryIDs(rawValue: user.dormitoryID) {
                
                ProfileHeader(user: user, dormitoryID: dormitoryID)
                
                DormitorySection(dormitory: dormitory)
                
                if !profileViewModel.isAdmin {
                    RequestsSection(requests: profileViewModel.requests)
                }
            }
        }
        .task {
            try? await profileViewModel.loadCurrentUser()
        }
        .navigationTitle("Профіль")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                SettingsButton(showingSettings: $showingSettings)
            }
            ToolbarItem(placement: .topBarTrailing) {
                DismissButton(dismiss: dismiss)
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                SettingsView()
            }
        }
    }
}



//#Preview {
//    NavigationStack {
//        ProfileView(showSignUpView: .constant(false))
//    }
//}
