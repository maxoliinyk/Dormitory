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
    @StateObject private var viewModel = NotificationsViewModel()
    @StateObject private var requestViewModel = RequestViewModel()
    @State private var showingNewNotificationView = false
    @State private var showingProfile = false
    @State private var showingAdminRequestView = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(viewModel.notifications, id: \.notificationID) { notification in
                        NotificationRow(
                            notification: notification,
                            formattedDate: viewModel.formatDate(from: notification.date),
                            isAdmin: true
                        ) {
                            viewModel.deleteNotification(notificationID: notification.notificationID)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingNewNotificationView = true
                } label: {
                    Image(systemName: "plus")
                        .circleButton
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingNewNotificationView) {
                    NewNotificationView {
                        dormitoryID,
                        title,
                        content,
                        postedBy in
                        viewModel.addNewNotification(dormitoryID: dormitoryID.rawValue, title: title, content: content, postedBy: postedBy)
                    }
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
                RequestView()
            }
        }
        .sheet(isPresented: $showingProfile) {
            NavigationStack {
                ProfileView()
            }
        }
        .task {
            await viewModel.loadNotifications()
            await requestViewModel.loadCurrentUser()
            await requestViewModel.loadRequests()
        }
    }
}

#Preview {
    NavigationStack {
        AdminNotificationView()
    }
}
