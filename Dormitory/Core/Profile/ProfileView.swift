//
//  ProfileView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI

@MainActor final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var dormitory: DBDormitory? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
        self.dormitory = try await DormitoriesManager.shared.getDormitory(id: user?.dormitoryID ?? "")
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var dormViewModel = DormitoriesViewModel()
    @State private var showingSettings = false
    @Binding var showSignUpView: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if let user = viewModel.user,
               let dormitory = viewModel.dormitory,
               let dormitoryID = DormitoryIDs(rawValue: user.dormitoryID),
               let displayName = DormitoryDisplayNames(dormitoryID: dormitoryID) {
                
                ScrollView {
                    
                    // Profile
                    VStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .font(.caption2)
                            .padding(.horizontal, 100)
                            .shadow(radius: 10)
                        
                        Text("\(String(user.name ?? "")) \(String(user.lastName ?? ""))")
                            .font(.title.bold())
                        Text("\(String(displayName.rawValue)) • \(String(user.roomNumber ?? "")) кімната")
                            .font(.footnote)
                            .padding(.bottom, 15)
                        
                        Divider()
                    }
                    .padding(.bottom, 10)
                    
                    //                        Spacer()
                    
                    // Dormitory
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Мій гуртожиток:")
                                .font(.title2.bold())
                            Text(dormitory.address)
                                .font(.callout)
                            Text("м. Київ")
                                .font(.caption)
                        }
                        .padding()
                        
                        Spacer()
                        VStack {
                            Text(dormitory.number)
                                .font(.largeTitle)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .background(.ultraThickMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
        .task  {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                SettingsView(showSignUpView: $showSignUpView)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Settings", systemImage: "gear") {
                    showingSettings = true
                }
                .font(.headline)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

enum DormitoryDisplayNames: String, CaseIterable {
    case dormitory1 = "Гуртожиток #1"
    case dormitory2 = "Гуртожиток #2"
    case dormitory3 = "Гуртожиток #3"
    
    var dormitoryID: DormitoryIDs {
        switch self {
        case .dormitory1:
            return .dormitory1
        case .dormitory2:
            return .dormitory2
        case .dormitory3:
            return .dormitory3
        }
    }
    
    init?(dormitoryID: DormitoryIDs) {
        switch dormitoryID {
        case .dormitory1:
            self = .dormitory1
        case .dormitory2:
            self = .dormitory2
        case .dormitory3:
            self = .dormitory3
        }
    }
}


#Preview {
    NavigationStack {
        ProfileView(showSignUpView: .constant(false))
    }
}
