//
//  NewRequestView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

//
//  NewRequestView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import SwiftUI
import Firebase

struct NewRequestView: View {
    @StateObject private var viewModel = RequestViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var content = ""

    
    let addRequestAction: (String, String, String, String) async -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter Title", text: $title)
                }
                Section(header: Text("Content")) {
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("Enter your message here")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                        TextEditor(text: $content)
                            .frame(height: 150) // Adjust the height as needed
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("New Request")
            .toolbar {
                ToolbarItemGroup() {
                    Button("Cancel") {
                        dismiss()
                    }
                                    
                    Button("Submit") {
                        Task {
                            let dormitoryID = viewModel.currentUser?.dormitoryID ?? "err"
                            let roomNumber = viewModel.currentUser?.roomNumber ?? "err"
                            await addRequestAction(dormitoryID, title, content, roomNumber)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
                
            }
        }
    }
}

//#Preview {
//    NewRequestView {title, content in
////        print("Dormitory ID: \(dormitoryID)")
//        print("Title: \(title)")
//        print("Content: \(content)")
////        print("Room Number: \(roomNumber)")
//    }
//}
