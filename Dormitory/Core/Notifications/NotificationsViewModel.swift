//
//  NotificationsViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published private(set) var notifications: [DBNotification] = []
    
    private func sortNotifications() {
        notifications.sort { $0.date.dateValue() > $1.date.dateValue() }
    }
    
    func loadNotifications() async {
        do {
            notifications = try await NotificationManager.shared.fetchAllNotifications()
            sortNotifications()
        } catch {
            print("Error loading notifications: \(error)")
        }
    }
    
    func addNewNotification(dormitoryID: String, title: String, content: String, postedBy: String) {
        let newNotification = DBNotification(
            notificationID: UUID().uuidString,
            dormitoryID: dormitoryID,
            title: title,
            content: content,
            postedBy: postedBy,
            date: Timestamp(date: Date())
        )
        
        Task {
            do {
                try await NotificationManager.shared.uploadNotification(notification: newNotification)
                notifications.append(newNotification)
                sortNotifications()
            } catch {
                print("Error uploading notification: \(error)")
            }
        }
    }
    
    func deleteNotification(notificationID: String) {
        Task {
            do {
                try await NotificationManager.shared.deleteNotification(notificationID: notificationID)
                notifications.removeAll { $0.notificationID == notificationID }
            } catch {
                print("Error deleting notification: \(error)")
            }
        }
    }
    
    func formatDate(from timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
