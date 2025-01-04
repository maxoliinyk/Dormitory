//
//  NotificationManager.swift
//  Dormitory
//
//  Created by Max Oliinyk on 22.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBNotification: Codable, Equatable {
    let notificationID: String
    let dormitoryID: String
    let title: String
    let content: String
    let postedBy: String
    let date: Timestamp
}

final class NotificationManager {
    
    static let shared = NotificationManager()
    private init() { }
  
    private let notificationCollection = Firestore.firestore().collection("notifications")
    
    private func notificationDocument(id: String) -> DocumentReference { 
        notificationCollection.document(id)
    }
    
    func uploadNotification(notification: DBNotification) async throws {
        try notificationDocument(id: notification.notificationID).setData(from: notification, merge: false)
    }
    
    func getNotification(id: String) async throws -> DBNotification {
        try await notificationDocument(id: id).getDocument(as: DBNotification.self)
    }
    
    func fetchAllNotifications() async throws -> [DBNotification] {
        var notifications: [DBNotification] = []
        
        do {
            let querySnapshot = try await notificationCollection.getDocuments()
            notifications = try querySnapshot.documents.compactMap { document in
                try document.data(as: DBNotification.self)
            }
        } catch {
            print("Error fetching notifications: \(error)")
            throw error
        }
        
        return notifications
    }
    
    func deleteNotification(notificationID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("notifications").document(notificationID).delete()
    }
    
    
    // MARK: - Temp functions for testing
//    
//    private func convertDateStringToTimestamp(dateString: String) -> Timestamp? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        if let date = formatter.date(from: dateString) {
//            return Timestamp(date: date)
//        }
//        return nil
//    }
    
    func uploadTestingData(from fileName: String) async {
        do {
            // Locate the file in the app's bundle
            guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                throw NSError(
                    domain: "FileError",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to locate the JSON file named \(fileName)."]
                )
            }

            // Load the file's data
            let data = try Data(contentsOf: fileUrl)

            // Decode the JSON into a temporary array of notification objects
            let notificationsArray = try JSONDecoder().decode(NotificationsArray.self, from: data)

            // Process and upload each notification
            for notification in notificationsArray.notifications {
                guard let timestamp = RequestManager.shared.convertDateStringToTimestamp(dateString: notification.date) else {
                    print("Invalid date format for notification: \(notification.notificationID). Skipping.")
                    continue // Skip invalid notifications
                }

                // Create DBNotification object
                let dbNotification = DBNotification(
                    notificationID: notification.notificationID,
                    dormitoryID: notification.dormitoryID,
                    title: notification.title,
                    content: notification.content,
                    postedBy: notification.postedBy,
                    date: timestamp
                )

                // Upload to Firestore
                do {
                    try await NotificationManager.shared.uploadNotification(notification: dbNotification)
                    print("Uploaded notification: \(notification.notificationID)")
                } catch {
                    print("Failed to upload notification \(notification.notificationID): \(error)")
                }
            }

            print("SUCCESS: All valid notifications processed and uploaded.")
        } catch {
            print("Error during file processing or uploading: \(error)")
        }
    }
}
