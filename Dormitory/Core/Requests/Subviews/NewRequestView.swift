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
    @State private var title = ""
    @State private var content = ""
    
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
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Надіслати") {
                        Task {
                            try? await requestViewModel.addRequest(title: title, content: content)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

