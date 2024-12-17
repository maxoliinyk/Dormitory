//
//  NewNotificationView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 23.05.2024.
//

import SwiftUI
import FirebaseAuth

struct NewNotificationView: View {
    @ObservedObject var notificationViewModel: NotificationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Деталі")) {
                    Picker("Гуртожиток", selection: $notificationViewModel.newNotification.dormitoryID) {
                        ForEach(DormitoryIDs.allCases, id: \.self) { dormitory in
                            Text(dormitory.displayName).tag(dormitory)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Заголовок...", text: $notificationViewModel.newNotification.title)
                }
                Section(header: Text("Повідомлення")) {
                    ZStack(alignment: .topLeading) {
                        if notificationViewModel.newNotification.content.isEmpty {
                            Text("Введіть ваше повідомлення...")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(5)
                        }
                        TextEditor(text: $notificationViewModel.newNotification.content)
                            .frame(minHeight: 150)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
                            .padding(.vertical, 3)
                    }
                }
            }
            .navigationTitle("Нове оголошення")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Надіслати") {
                        Task {
                            await notificationViewModel.addNotification()
                            dismiss()
                        }
                    }
                    .disabled(notificationViewModel.newNotification.title.isEmpty || notificationViewModel.newNotification.content.isEmpty)
                }
            }
            .onAppear {
                Task {
                    if let userID = Auth.auth().currentUser?.uid {
                        do {
                            let user = try await UserManager.shared.getUser(userID: userID)
                            if let userName = user.name, let userLastName = user.lastName {
                                notificationViewModel.setCurrentUserName("\(userName) \(userLastName)")
                            } else {
                                // Handle case where user name or last name is not available
                                notificationViewModel.setCurrentUserName("Unknown User")
                            }
                        } catch {
                            // Handle error appropriately
                            print("Failed to fetch user: \(error)")
                        }
                    } else {
                        // Handle case where user is not authenticated
                        print("No authenticated user found.")
                    }
                }
            }
        }
    }
}

//#Preview {
//    NewNotificationView { dormitoryID, title, content, postedBy in
//        print("Dormitory ID: \(dormitoryID)")
//        print("Title: \(title)")
//        print("Content: \(content)")
//        print("Posted By: \(postedBy)")
//    }
//}
