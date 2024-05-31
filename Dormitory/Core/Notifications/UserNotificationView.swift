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
    @State private var showingNewRequestView = false
    @State private var showingAdminRequestView = false
    @State private var showingProfile = false
    @Binding var showSignUpView: Bool
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
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 70, height: 70)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 10)

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
                .sheet(isPresented: $showingProfile) {
                    NavigationView {
                        ProfileView(showSignUpView: $showSignUpView)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        UserNotificationView(showSignUpView: .constant(false), dormitoryID: "dormitory1")
    }
}
