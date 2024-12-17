//
//  AdminNotificationView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 22.05.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AdminNotificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var notificationViewModel = NotificationViewModel()
    @StateObject private var requestViewModel = RequestViewModel()
    @State private var showingNewNotificationView = false
    @State private var showingProfile = false
    @State private var showingAdminRequestView = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(notificationViewModel.notifications, id: \.notificationID) { notification in
                        NotificationRow(
                            notification: notification,
                            formattedDate: authViewModel.formatDate(from: notification.date),
                            isAdmin: true
                        ) {
                            Task {
                                await notificationViewModel.deleteNotification(notificationID: notification.notificationID)
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .overlay(alignment: .bottomTrailing) {
                AddButton {
                    showingNewNotificationView = true
                }
            }
        }
        .navigationTitle("Оголошення")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Requests", systemImage: "list.bullet") {
                    showingAdminRequestView = true
                }.font(.headline)
                Button("Profile", systemImage: "person.circle") {
                    showingProfile = true
                }.font(.headline)
            }
        }
        .sheet(isPresented: $showingAdminRequestView) {
            NavigationStack {
                RequestView(requestViewModel: requestViewModel)
            }
        }
        .sheet(isPresented: $showingProfile) {
            NavigationStack {
                ProfileView(requestViewModel: requestViewModel)
            }
        }
        .sheet(isPresented: $showingNewNotificationView) {
            NewNotificationView(notificationViewModel: notificationViewModel)
        }
        .task {
            await notificationViewModel.loadNotifications()
            try? await requestViewModel.loadCurrentUser()
            try? await requestViewModel.loadRequests()
        }

    }
}

#Preview {
    NavigationStack {
        AdminNotificationView()
    }
}
