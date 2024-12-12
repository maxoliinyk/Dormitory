//
//  NotificationViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class NotificationViewModel: ObservableObject {
    @Published private(set) var notifications: [DBNotification] = []
    @Published var newNotification = NewNotification() // Encapsulate new notification data
    
    // Nested Types
    struct NewNotification {
        var dormitoryID: DormitoryIDs = .dormitory1
        var title: String = ""
        var content: String = ""
        var postedBy: String = ""
        
        mutating func reset() {
            dormitoryID = .dormitory1
            title = ""
            content = ""
            postedBy = ""
        }
    }
    
    func loadNotifications() async {
        do {
            notifications = try await NotificationManager.shared.fetchAllNotifications()
            sortNotifications()
        } catch {
            print("Error loading notifications: \(error)")
        }
    }
    
    func addNotification() async {
        let notification = DBNotification(
            notificationID: UUID().uuidString,
            dormitoryID: newNotification.dormitoryID.rawValue,
            title: newNotification.title,
            content: newNotification.content,
            postedBy: newNotification.postedBy,
            date: Timestamp(date: Date())
        )
        
        do {
            try await NotificationManager.shared.uploadNotification(notification: notification)
            notifications.append(notification)
            sortNotifications()
            newNotification.reset() // Reset form after successful addition
        } catch {
            print("Error uploading notification: \(error)")
        }
    }
    
    func deleteNotification(notificationID: String) async {
        do {
            try await NotificationManager.shared.deleteNotification(notificationID: notificationID)
            notifications.removeAll { $0.notificationID == notificationID }
        } catch {
            print("Error deleting notification: \(error)")
        }
    }
    
    func setCurrentUserName(_ userName: String) {
        newNotification.postedBy = userName
    }
    
    private func sortNotifications() {
        notifications.sort { $0.date.dateValue() > $1.date.dateValue() }
    }
}
