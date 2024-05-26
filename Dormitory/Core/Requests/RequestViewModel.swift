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
    @Published var requests: [DBRequest] = []
    @Published var currentUser: DBUser?
    @Published var content: String = "" // Add this line

    private let requestCollection = Firestore.firestore().collection("requests")

    func loadRequests() async {
        do {
            let snapshot = try await requestCollection.getDocuments()
            self.requests = snapshot.documents.compactMap { document in
                try? document.data(as: DBRequest.self)
            }
        } catch {
            print("Error loading requests: \(error)")
        }
    }

    func formatDate(from timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short // You can use .medium or .long for different time formats
        return formatter.string(from: date)
    }

    func addNewRequest(dormitoryID: String, title: String, content: String, roomNumber: String) async {
        guard let currentUser = currentUser else { return }

        let newRequest = generateRequest(dormitoryID: currentUser.dormitoryID, title: title, content: content, roomNumber: currentUser.roomNumber ?? "nan")

        do {
            try requestCollection.document(newRequest.requestID).setData(from: newRequest)
            await loadRequests()
        } catch {
            print("Error adding request: \(error)")
        }
    }

    private func generateRequest(dormitoryID: String, title: String, content: String, roomNumber: String) -> DBRequest {
        DBRequest(
            requestID: UUID().uuidString,
            dormitoryID: dormitoryID,
            title: title,
            content: content,
            postedBy: "\(currentUser?.name ?? "") \(currentUser?.lastName ?? "")",
            roomNumber: roomNumber,
            date: Timestamp(date: Date())
        )
    }

    func deleteRequest(requestID: String) async {
        do {
            try await requestCollection.document(requestID).delete()
            await loadRequests() // Refresh the list of requests after deletion
        } catch {
            print("Error deleting request: \(error)")
        }
    }

    func loadCurrentUser() async {
        guard let firebaseUser = Auth.auth().currentUser else {
            print("No user signed in")
            return
        }

        do {
            self.currentUser = try await UserManager.shared.getUser(userID: firebaseUser.uid)
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
}
