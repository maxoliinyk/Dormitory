//
//  NewNotificationView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 23.05.2024.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class NewNotificationViewModel: ObservableObject {
    @Published var dormitoryID: DormitoryIDs = .dormitory1 // Updated to use Dormitory enum
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var postedBy: String = ""
    
    func setCurrentUserName(_ userName: String) {
        self.postedBy = userName
    }
    
    func resetFields() {
        dormitoryID = .dormitory1
        title = ""
        content = ""
        postedBy = ""
    }
}

struct NewNotificationView: View {
    @StateObject private var viewModel = NewNotificationViewModel()
    var onSave: (DormitoryIDs, String, String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Деталі")) {
                    Picker("Гуртожиток", selection: $viewModel.dormitoryID) {
                        ForEach(DormitoryIDs.allCases, id: \.self) { dormitory in
                            Text(dormitory.displayName).tag(dormitory)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Заголовок...", text: $viewModel.title)
                }
                Section(header: Text("Повідомлення")) {
                    ZStack(alignment: .topLeading) {
                        if viewModel.content.isEmpty {
                            Text("Введіть ваше повідомлення...")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(5)
                        }
                        TextEditor(text: $viewModel.content)
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
                        onSave(viewModel.dormitoryID, viewModel.title, viewModel.content, viewModel.postedBy)
                        dismiss()
                    }
                    .disabled(viewModel.title.isEmpty || viewModel.content.isEmpty)
                }
            }
            .onAppear {
                Task {
                    if let userID = Auth.auth().currentUser?.uid {
                        do {
                            let user = try await UserManager.shared.getUser(userID: userID)
                            if let userName = user.name, let userLastName = user.lastName {
                                viewModel.setCurrentUserName("\(userName) \(userLastName)")
                            } else {
                                // Handle case where user name or last name is not available
                                viewModel.setCurrentUserName("Unknown User")
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

#Preview {
    NewNotificationView { dormitoryID, title, content, postedBy in
        print("Dormitory ID: \(dormitoryID)")
        print("Title: \(title)")
        print("Content: \(content)")
        print("Posted By: \(postedBy)")
    }
}
