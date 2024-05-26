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

    func uploadRequest(request: DBRequest) async throws {
        try await requestCollection.addDocument(from: request)
    }
    
    func getRequest(id: String) async throws -> DBRequest {
        try await requestDocument(id: id).getDocument(as: DBRequest.self)
    }

    func fetchAllRequests() async throws -> [DBRequest] {
        var requests: [DBRequest] = []
        
        do {
            let querySnapshot = try await requestCollection.getDocuments()
            requests = try querySnapshot.documents.compactMap { document in
                try document.data(as: DBRequest.self)
            }
        } catch {
            print("Error fetching requests: \(error)")
            throw error
        }
        
        return requests
    }
    
    func deleteRequest(requestID: String) async throws {
        try await requestDocument(id: requestID).delete()
    }

    // New function to fetch requests for a specific dormitory ID
    func getRequests(forDormitoryID dormitoryID: String) async throws -> [DBRequest] {
        var requests: [DBRequest] = []
        
        do {
            let querySnapshot = try await requestCollection.whereField("dormitoryID", isEqualTo: dormitoryID).getDocuments()
            requests = try querySnapshot.documents.compactMap { document in
                try document.data(as: DBRequest.self)
            }
        } catch {
            print("Error fetching requests for dormitory ID \(dormitoryID): \(error)")
            throw error
        }
        
        return requests
    }

    private func convertDateStringToTimestamp(dateString: String) -> Timestamp? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            return Timestamp(date: date)
        }
        return nil
    }
}
