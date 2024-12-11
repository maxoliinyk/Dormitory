//
//  ProfileView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingSettings = false
    @State private var showingNewRequestView = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if let user = viewModel.user,
               let dormitory = viewModel.dormitory,
               let dormitoryID = DormitoryIDs(rawValue: user.dormitoryID) { // Use the unified DormitoryIDs enum
                
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
                        Text("\(dormitoryID.displayName) • \(String(user.roomNumber ?? "")) кімната") // Use displayName from DormitoryIDs
                            .font(.footnote)
                            .padding(.bottom, 15)
                        

                    }
                    .padding(.bottom, 10)
                    
                    Divider()
                        .padding(.horizontal)
                    
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
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Requests (if not admin)
                    if !viewModel.isAdmin {
                        VStack(alignment: .leading) {
                            Text("Запити мого гуртожитку")
                                .font(.title2.bold())
                                .padding(.leading)
                            
                            Divider()
                                .padding(.bottom)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.requests) { request in
                                
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(request.title)
                                            .font(.title2.bold())
                                        Text(request.content)
                                            .font(.callout)
                                    }
                                    .padding()
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .background(.ultraThickMaterial)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                            }
                            
                            if viewModel.requests.isEmpty {
                                Text("Не знайдено жодного запиту.")
                                    .font(.subheadline)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Профіль")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button("Settings", systemImage: "gear") {
                    showingSettings = true
                }
                .font(.headline)
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Готово") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                SettingsView()
            }
        }
        .sheet(isPresented: $showingNewRequestView) {
            NewRequestView(addRequestAction: { dormitoryID, title, content, roomNumber in
                do {
                    // Make sure user is loaded
                    guard let user = viewModel.user else {
                        print("User not loaded")
                        return
                    }
                    
                    // Combine name and lastName to form postedBy string
                    let postedBy = "\(user.name ?? "Студент") \(user.lastName ?? "")"
                    
                    // Create a new DBRequest object
                    let request = DBRequest(
                        requestID: UUID().uuidString,
                        dormitoryID: dormitoryID,
                        title: title,
                        content: content,
                        postedBy: postedBy, // Use combined name and last name
                        roomNumber: roomNumber,
                        date: Timestamp(date: Date())
                    )
                    
                    // Upload the request
                    try await RequestManager.shared.uploadRequest(request: request)
                    
                    // Refresh the data
                    try await viewModel.loadCurrentUser()
                } catch {
                    // Handle the error appropriately (e.g., show an alert)
                    print("Failed to add request or load current user: \(error)")
                }
            })
        }

    }
}


//#Preview {
//    NavigationStack {
//        ProfileView(showSignUpView: .constant(false))
//    }
//}
