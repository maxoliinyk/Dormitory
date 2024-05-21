//
//  UserManager.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userID: String
    let email: String?
    let name: String?
    let lastName: String?
    let roomNumber: String?
    let dormitoryNumber: String?
    let isAdmin: Bool?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel, name: String, lastName: String, roomNumber: String, dormitoryNumber: String, isAdmin: Bool) async throws {
        
        var userData: [String:Any] = [
            "userID" : auth.uid,
            "name" : name,
            "lastName" : lastName,
            "roomNumber" : roomNumber,
            "dormitoryNumber" : dormitoryNumber
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
        
    }
    
    func getUser(userID: String) async throws -> DBUser  {
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        
        guard let data = snapshot.data(), let userID = data["userID"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let name = data["name"] as? String
        let lastName = data["lastName"] as? String
        let roomNumber = data["roomNumber"] as? String
        let dormitoryNumber = data["dormitoryNumber"] as? String
        let isAdmin = data["isAdmin"] as? Bool
        
        return DBUser(userID: userID, email: email, name: name, lastName: lastName, roomNumber: roomNumber, dormitoryNumber: dormitoryNumber, isAdmin: isAdmin)
    }
    
}
