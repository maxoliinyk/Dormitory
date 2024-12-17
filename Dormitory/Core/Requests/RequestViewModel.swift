//
//  RequestViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class RequestViewModel: ObservableObject {
    @Published private(set) var requests: [DBRequest] = []
    @Published private(set) var currentUser: DBUser?
    
    private let requestManager = RequestManager.shared
    private let userManager = UserManager.shared
    
    func loadRequests() async throws {
        requests = try await requestManager.getRequests()
    }
    
    func formatDate(from timestamp: Timestamp) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp.dateValue())
    }
    
    func addRequest(title: String, content: String) async throws {
        guard let user = currentUser else { return }
        
        let request = DBRequest(
            requestID: UUID().uuidString,
            dormitoryID: user.dormitoryID,
            title: title,
            content: content,
            postedBy: "\(user.name ?? "") \(user.lastName ?? "")",
            roomNumber: user.roomNumber ?? "н/д",
            date: Timestamp(date: Date())
        )
        
        try await requestManager.uploadRequest(request: request)
        try await loadRequests()
    }
    
    func deleteRequest(requestID: String) async throws {
        try await requestManager.deleteRequest(requestID: requestID)
        try await loadRequests()
    }
    
    func loadCurrentUser() async throws {
        let authUser = try AuthManager.shared.getAuthenticatedUser()
        currentUser = try await userManager.getUser(userID: authUser.uid)
    }
}
