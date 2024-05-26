//
//  OldFunctions-Unused.swift
//  Dormitory
//
//  Created by Max Oliinyk on 24.05.2024.
//

import Foundation


// Functions from NotificationView to read local json and then upload it to Firestore
// They do the same thing, but a bit refactored.
//
//private func readLocalNotificationsFile() throws -> [DBNotification] {
//    guard let fileUrl = Bundle.main.url(forResource: "notifications", withExtension: "json") else {
//        throw NSError(domain: "FileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to locate the JSON file in the bundle."])
//    }
//
//    let data = try Data(contentsOf: fileUrl)
//    let notifications = try JSONDecoder().decode(NotificationsArray.self, from: data)
//    return notifications.notifications.map { notification in
//        guard let timestamp = convertDateStringToTimestamp(dateString: notification.date) else {
//            fatalError("Invalid date format for notification: \(notification.notificationID)")
//        }
//
//        return DBNotification(
//            notificationID: notification.notificationID,
//            dormitoryID: notification.dormitoryID,
//            title: notification.title,
//            content: notification.content,
//            postedBy: notification.postedBy,
//            date: timestamp
//        )
//    }
//}
//
//func loadNotificationsFromLocalFileAndUploadToFirebase() {
//    Task {
//        do {
//            let notifications = try readLocalNotificationsFile()
//            for notification in notifications {
//                try await NotificationManager.shared.uploadNotification(notification: notification)
//            }
//            print("SUCCESS: Notifications uploaded")
//        } catch {
//            print("Error loading or processing JSON file: \(error)")
//        }
//    }
//}


// from RequestViewModel
//private func readLocalRequestsFile() throws -> [DBRequest] {
//    guard let fileUrl = Bundle.main.url(forResource: "requests", withExtension: "json") else {
//        throw NSError(domain: "FileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to locate the JSON file in the bundle."])
//    }
//
//    let data = try Data(contentsOf: fileUrl)
//    let requests = try JSONDecoder().decode(RequestsArray.self, from: data)
//    return requests.requests.map { request in
//        guard let timestamp = convertDateStringToTimestamp(dateString: request.date) else {
//            fatalError("Invalid date format for request: \(request.title)")
//        }
//
//        return DBRequest(
//            requestID: request.requestID,
//            dormitoryID: request.dormitoryID,
//            title: request.title,
//            content: request.content,
//            postedBy: request.postedBy,
//            roomNumber: request.roomNumber,
//            date: timestamp
//        )
//    }
//}
//
//func loadRequestsFromLocalFileAndUploadToFirebase() {
//    Task {
//        do {
//            let requests = try readLocalRequestsFile()
//            for request in requests {
//                try await uploadRequest(request: request)
//            }
//            print("SUCCESS: Requests uploaded")
//        } catch {
//            print("Error loading or processing JSON file: \(error)")
//        }
//    }
//}
