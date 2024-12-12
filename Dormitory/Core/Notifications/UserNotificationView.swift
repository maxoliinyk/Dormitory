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
    @State private var showingAdminRequestView = false
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
                        }                    }
                }
            }
            .padding()
        }
        .navigationTitle("Оголошення")
        .overlay(alignment: .bottomTrailing) {
            Button {
                showingNewRequestView = true
            } label: {
                Image(systemName: "plus")
                    .circleButton
                
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingNewRequestView) {
                NewRequestView(requestViewModel: requestViewModel, addRequestAction: requestViewModel.addNewRequest)
            }
        }
        .task {
            await notificationViewModel.loadNotifications()
            await requestViewModel.loadCurrentUser()
            await requestViewModel.loadRequests()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button ("Profile", systemImage: "person.circle") {
                    showingProfile = true
                }
                .font(.headline)
            }
        }
        .sheet(isPresented: $showingProfile) {
            NavigationStack {
                ProfileView(requestViewModel: requestViewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserNotificationView(dormitoryID: .dormitory1)
    }
}
