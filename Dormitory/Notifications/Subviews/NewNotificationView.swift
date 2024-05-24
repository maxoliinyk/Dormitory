//
//  NewNotificationView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 23.05.2024.
//

import SwiftUI

@MainActor
final class NewNotificationViewModel: ObservableObject {
    @Published var dormitoryID: DormitoryIDs = .dormitory1 // Updated to use Dormitory enum
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var postedBy: String = ""
    
    func resetFields() {
        dormitoryID = .dormitory1
        title = ""
        content = ""
        postedBy = ""
    }
}

struct NewNotificationView: View {
    @StateObject private var viewModel = NewNotificationViewModel()
    var onSave: (DormitoryIDs, String, String, String) -> Void // Updated to use DormitoryIDs
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Notification Details")) {
                    Picker("Гуртожиток", selection: $viewModel.dormitoryID) {
                        ForEach(DormitoryIDs.allCases, id: \.self) { dormitory in
                            Text(dormitory.displayName).tag(dormitory)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Title", text: $viewModel.title)
                    
                    ZStack(alignment: .topLeading) {
                        if viewModel.content.isEmpty {
                            Text("Enter your message here")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                        TextEditor(text: $viewModel.content)
                            .frame(height: 150) // Adjust the height as needed
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.top, 8)
                    }
                    
                    TextField("Posted By", text: $viewModel.postedBy)
                }
            }
            .navigationTitle("New Notification")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(viewModel.dormitoryID, viewModel.title, viewModel.content, viewModel.postedBy)
                        dismiss()
                    }
                    .disabled(viewModel.title.isEmpty || viewModel.content.isEmpty || viewModel.postedBy.isEmpty)
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
