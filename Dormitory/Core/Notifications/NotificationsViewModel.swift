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
    @Published var notifications: [DBNotification] = []

    func loadNotifications() async {
        do {
            let snapshot = try await Firestore.firestore().collection("notifications").getDocuments()
            self.notifications = snapshot.documents.compactMap { document in
                try? document.data(as: DBNotification.self)
            }
        } catch {
            print("Error loading notifications: \(error)")
        }
    }

    func sortNotifications() {
        notifications.sort { $0.date.dateValue() > $1.date.dateValue() }
    }

    func formatDate(from timestamp: Timestamp) -> String {
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
        DBNotification(
            notificationID: UUID().uuidString,  // Automatically generate a unique notification ID
            dormitoryID: dormitoryID,
            title: title,
            content: content,
            postedBy: postedBy,
            date: Timestamp(date: Date())  // Get the current date
        )
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
