//
//  UserManager.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userID: String
    let email: String?
    let name: String?
    let lastName: String?
    let roomNumber: String?
    let dormitoryID: String
    let isAdmin: Bool

    init(userID: String, email: String? = nil, name: String? = nil, lastName: String? = nil, roomNumber: String? = nil, dormitoryID: String, isAdmin: Bool) {
        self.userID = userID
        self.email = email
        self.name = name
        self.lastName = lastName
        self.roomNumber = roomNumber
        self.dormitoryID = dormitoryID
        self.isAdmin = isAdmin
    }
    
    enum CodingKeys: String, CodingKey {
        case userID
        case email
        case name
        case lastName
        case roomNumber
        case dormitoryID
        case isAdmin
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(String.self, forKey: .userID)
        email = try? container.decode(String?.self, forKey: .email) ?? ""
        name = try? container.decode(String?.self, forKey: .name) ?? ""
        lastName = try? container.decode(String?.self, forKey: .lastName) ?? ""
        roomNumber = try? container.decode(String?.self, forKey: .roomNumber) ?? ""
        dormitoryID = try container.decode(String.self, forKey: .dormitoryID)
        isAdmin = try container.decode(Bool.self, forKey: .isAdmin)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(roomNumber, forKey: .roomNumber)
        try container.encode(dormitoryID, forKey: .dormitoryID)
        try container.encode(isAdmin, forKey: .isAdmin)
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userID: String) async throws -> DBUser {
        try await userDocument(userID: userID).getDocument(as: DBUser.self)
    }
}
