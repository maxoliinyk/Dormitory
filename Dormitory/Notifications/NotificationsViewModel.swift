//
//  NotificationsViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [DBNotification] = []
    
    func sortNotifications() {
        notifications.sort { $0.date.dateValue() > $1.date.dateValue() }
    }

    private func convertDateStringToTimestamp(dateString: String, format: String = "yyyy-MM-dd") -> Timestamp? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format for date string: \(dateString)")
            return nil
        }
        return Timestamp(date: date)
    }
    
    func formatDate(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    func addNewNotification(dormitoryID: String, title: String, content: String, postedBy: String) {
        let newNotification = generateNotification(dormitoryID: dormitoryID, title: title, content: content, postedBy: postedBy)

        notifications.append(newNotification)

        // Upload the new notification to Firestore
        Task {
            do {
                try await NotificationManager.shared.uploadNotification(notification: newNotification)
                print("Successfully uploaded new notification")
            } catch {
                print("Error uploading new notification: \(error)")
            }
        }
    }

    private func generateNotification(dormitoryID: String, title: String, content: String, postedBy: String) -> DBNotification {
        let notificationID = UUID().uuidString  // Automatically generate a unique notification ID
        let currentDate = Date()  // Get the current date

        return DBNotification(
            notificationID: notificationID,
            dormitoryID: dormitoryID,
            title: title,
            content: content,
            postedBy: postedBy,
            date: Timestamp(date: currentDate)
        )
    }

    func loadNotifications() async {
        do {
            let fetchedNotifications = try await NotificationManager.shared.fetchAllNotifications()
            DispatchQueue.main.async {
                self.notifications = fetchedNotifications
                self.sortNotifications()

            }
        } catch {
            print("Failed to fetch notifications: \(error)")
        }
    }
    
    func deleteNotification(notificationID: String) {
        // Remove the notification from the local list
        if let index = notifications.firstIndex(where: { $0.notificationID == notificationID }) {
            notifications.remove(at: index)
        }
        
        // Delete the notification from Firestore
        Task {
            do {
                try await NotificationManager.shared.deleteNotification(notificationID: notificationID)
                print("Successfully deleted notification")
            } catch {
                print("Error deleting notification: \(error)")
            }
        }
    }
}
