//
//  NewRequestView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import SwiftUI
import Firebase

struct NewRequestView: View {
    @ObservedObject var requestViewModel: RequestViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var content = ""
    
    
    let addRequestAction: (String, String, String, String) async -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Заголовок")) {
                    TextField("Введіть заголовок...", text: $title)
                }
                Section(header: Text("Зміст")) {
                    TextField("Введіть ваше повідомлення...", text: $content, axis: .vertical)
                }
            }
            .navigationTitle("Новий запит")
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Надіслати") {
                        Task {
                            let dormitoryID = requestViewModel.currentUser?.dormitoryID ?? "err"
                            let roomNumber = requestViewModel.currentUser?.roomNumber ?? "err"
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
