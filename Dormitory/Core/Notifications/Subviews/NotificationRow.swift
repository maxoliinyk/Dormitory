//
//  NotificationRow.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import SwiftUI
import FirebaseFirestore

struct NotificationRow: View {
    let notification: DBNotification
    let formattedDate: String
    let isAdmin: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(notification.title)
                    .font(.headline)
                
                Text(notification.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Повідомив \(notification.postedBy) від \(formattedDate)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            if isAdmin {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.bottom, 5)
    }
}

//#Preview {
//    NotificationRow()
//}
