//
//  DormitoriesManager.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBDormitory: Codable {
    let dormitoryID: String
    let title: String
    let address: String
    let number: String
}

final class DormitoriesManager {
    
    static let shared = DormitoriesManager()
    private init() { }
    
    private let dormitoriesCollection = Firestore.firestore().collection("dormitories")
    
    private func dormitoryDocument(id: String) -> DocumentReference {
        dormitoriesCollection.document(id)
    }
    
    func uploadDormitory(dormitory: Dormitory) async throws {
        try dormitoryDocument(id: dormitory.dormitoryID).setData(from: dormitory, merge: false)
    }
    
    func getDormitory(id: String) async throws -> DBDormitory {
        try await dormitoryDocument(id: id).getDocument(as: DBDormitory.self)
    }
}
