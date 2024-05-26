//
//  ProfileViewModel.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import Foundation

@MainActor final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var dormitory: DBDormitory? = nil
    @Published private(set) var requests: [DBRequest] = []
    @Published private(set) var isAdmin: Bool = false
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
        self.dormitory = try await DormitoriesManager.shared.getDormitory(id: user?.dormitoryID ?? "")
        self.isAdmin = user?.isAdmin ?? false
        
        if !self.isAdmin {
            self.requests = try await RequestManager.shared.getRequests(forDormitoryID: user?.dormitoryID ?? "")
        }
    }
}
