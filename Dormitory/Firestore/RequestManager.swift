//
//  RequestManager.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBRequest: Codable, Equatable, Identifiable {
    let requestID: String
    let dormitoryID: String
    let title: String
    let content: String
    let postedBy: String
    let roomNumber: String
    let date: Timestamp
    
    var id: String {
        return requestID
    }
}

final class RequestManager {
    static let shared = RequestManager()
    private init() { }

    private let requestCollection = Firestore.firestore().collection("requests")

    private func requestDocument(id: String) -> DocumentReference {
        requestCollection.document(id)
    }

    // MARK: - Upload
    func uploadRequest(request: DBRequest) async throws {
        try requestCollection.addDocument(from: request)
    }
    
    // MARK: - Get
    func getRequest(id: String) async throws -> DBRequest {
        try await requestDocument(id: id).getDocument(as: DBRequest.self)
    }
    
    func getRequests() async throws -> [DBRequest] {
        try await fetchAllRequests()
    }
    
    func getRequests(forDormitoryID dormitoryID: String) async throws -> [DBRequest] {
        let snapshot = try await requestCollection
            .whereField("dormitoryID", isEqualTo: dormitoryID)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: DBRequest.self) }
    }

    func fetchAllRequests() async throws -> [DBRequest] {
        let snapshot = try await requestCollection.getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: DBRequest.self) }
    }
    
    // MARK: - Delete
    func deleteRequest(requestID: String) async throws {
        try await requestDocument(id: requestID).delete()
    }

    // MARK: - Helpers
    func convertDateStringToTimestamp(dateString: String) -> Timestamp? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            return Timestamp(date: date)
        }
        return nil
    }
}
