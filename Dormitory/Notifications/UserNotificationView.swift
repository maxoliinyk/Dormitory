//
//  UserNotificationView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import SwiftUI
import FirebaseFirestore

struct UserNotificationView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @State private var showingProfile = false
    @Binding var showSignUpView: Bool

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.notifications, id: \.notificationID) { notification in
                    NotificationRow(notification: notification, formattedDate: viewModel.formatDate(timestamp: notification.date), isAdmin: false) {
                        viewModel.deleteNotification(notificationID: notification.notificationID)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Notifications")
        .onAppear {
            Task {
                await viewModel.loadNotifications()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Profile", systemImage: "person.circle") {
                    showingProfile = true
                }
                .font(.headline)
                .sheet(isPresented: $showingProfile) {
                    NavigationStack {
                        ProfileView(showSignUpView: $showSignUpView)
                    }
                }
            }
        }
    }
}

#Preview {
    UserNotificationView(showSignUpView: .constant(false))
}
