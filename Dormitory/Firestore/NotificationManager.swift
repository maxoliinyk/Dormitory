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
}
