//
//  UserNotificationView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserNotificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var notificationViewModel = NotificationViewModel()
    @StateObject private var requestViewModel = RequestViewModel()
    @State private var showingNewRequestView = false
    @State private var showingProfile = false
    var dormitoryID: DormitoryIDs
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(notificationViewModel.notifications.filter { $0.dormitoryID == dormitoryID.rawValue }, id: \.notificationID) { notification in
                    NotificationRow(
                        notification: notification,
                        formattedDate: authViewModel.formatDate(from: notification.date),
                        isAdmin: false
                    ) {
                        Task {
                            await notificationViewModel.deleteNotification(notificationID: notification.notificationID)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Оголошення")
        .overlay(alignment: .bottomTrailing) {
            AddButton {
                showingNewRequestView = true
            }
        }
        .sheet(isPresented: $showingNewRequestView) {
            NewRequestView(requestViewModel: requestViewModel)
        }
        .sheet(isPresented: $showingProfile) {
            NavigationStack {
                ProfileView(requestViewModel: requestViewModel)
            }
        }
        .task {
            try? await loadInitialData()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ProfileButton(showingProfile: $showingProfile)
            }
        }
    }
    
    private func loadInitialData() async throws {
        await notificationViewModel.loadNotifications()
        try await requestViewModel.loadCurrentUser()
        try await requestViewModel.loadRequests()
    }
}

#Preview {
    NavigationStack {
        UserNotificationView(dormitoryID: .dormitory1)
    }
}
