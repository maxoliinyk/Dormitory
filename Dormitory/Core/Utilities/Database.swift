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

final class NotificationsDatabase {
    static let notifications: [Notification] = [
        Notification(
            notificationID: "notification1",
            dormitoryID: "dormitory1",
            title: "Оголошення 1",
            content: "Тестове оголошення",
            postedBy: "Admin",
            date: "2023-10-01" // Example date string
        ),
        Notification(
            notificationID: "notification2",
            dormitoryID: "dormitory2",
            title: "Оголошення 2",
            content: "Тестове оголошення",
            postedBy: "Admin",
            date: "2023-10-02" // Example date string
        ),
        Notification(
            notificationID: "notification3",
            dormitoryID: "dormitory3",
            title: "Оголошення 3",
            content: "Тестове оголошення",
            postedBy: "Admin",
            date: "2023-10-03" // Example date string
        )
    ]
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

final class DormitoriesDatabase {
    static let dormitories: [Dormitory] = [
        Dormitory(
            dormitoryID: "Dormitory1",
            title: "Гуртожиток №1",
            address: "вул. Ніжинська, 1",
            number: "#1",
            users: Optional([])
        ),
        Dormitory(
            dormitoryID: "Dormitory2",
            title: "Гуртожиток №2",
            address: "вул. Ніжинська, 2",
            number: "#2",
            users: Optional([])
        ),
        Dormitory(
            dormitoryID: "Dormitory3",
            title: "Гуртожиток №3",
            address: "вул. Ніжинська, 3",
            number: "#3",
            users: Optional([])
        ),
    ]
}
