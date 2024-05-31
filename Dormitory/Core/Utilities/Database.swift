//
//  Database.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RequestsArray: Codable {
    let requests: [Request]
}

struct Request: Codable, Equatable {
    let requestID: String
    let dormitoryID: String
    let title: String
    let content: String
    let postedBy: String
    let roomNumber: String
    let date: String
}

struct NotificationsArray: Codable {
    let notifications: [Notification]
}

struct Notification: Codable, Equatable {
    let notificationID: String
    let dormitoryID: String
    let title: String
    let content: String
    let postedBy: String
    let date: String
}

struct DormitoriesArray: Codable {
    let dormitories: [Dormitory]
}

struct Dormitory: Codable, Equatable {
    let dormitoryID: String
    let title: String
    let address: String
    let number: String
    let users: [String]?
}
