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
    @StateObject private var viewModel = NotificationsViewModel()
    @StateObject private var requestViewModel = RequestViewModel()
    @ObservedObject var rootViewModel: RootViewModel
    @State private var showingNewRequestView = false
    @State private var showingAdminRequestView = false
    @State private var showingProfile = false
    var dormitoryID: String
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.notifications.filter { $0.dormitoryID == dormitoryID }, id: \.notificationID) { notification in
                    NotificationRow(
                        notification: notification,
                        formattedDate: viewModel.formatDate(from: notification.date),
                        isAdmin: false
                    ) {
                        viewModel.deleteNotification(notificationID: notification.notificationID)
                    }
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
                NewRequestView(addRequestAction: requestViewModel.addNewRequest)
            }
        }
        .task {
            await viewModel.loadNotifications()
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
                ProfileView(rootViewModel: rootViewModel)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        UserNotificationView(showSignUpView: .constant(false), dormitoryID: "dormitory1")
//    }
//}
