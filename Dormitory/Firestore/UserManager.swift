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
