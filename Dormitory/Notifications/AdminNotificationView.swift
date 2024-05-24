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
    @StateObject private var viewModel = NotificationsViewModel()
    @State private var showingNewNotificationView = false
    @State private var showingProfile = false
    @Binding var showSignUpView: Bool
    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(viewModel.notifications, id: \.notificationID) { notification in
                        NotificationRow(notification: notification, formattedDate: viewModel.formatDate(timestamp: notification.date), isAdmin: true) {
                            viewModel.deleteNotification(notificationID: notification.notificationID)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button {
                        showingNewNotificationView = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .font(.largeTitle)
                    .sheet(isPresented: $showingNewNotificationView) {
                        NewNotificationView { dormitoryID, title, content, postedBy in
                            viewModel.addNewNotification(dormitoryID: dormitoryID.rawValue, title: title, content: content, postedBy: postedBy)
                        }
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .onAppear {
            Task {
                //                viewModel.loadNotificationsFromLocalFileAndUploadToFirebase()
                await viewModel.loadNotifications()
            }
        }
        .onChange(of: viewModel.notifications) { viewModel.sortNotifications() }
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
    NavigationStack {
        AdminNotificationView(showSignUpView: .constant(false))
    }
}
