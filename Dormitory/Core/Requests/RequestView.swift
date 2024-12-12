//
//  RequestView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RequestView: View {
    @ObservedObject var viewModel: RequestViewModel
    @State private var showingNewRequestView = false
    @State private var showingProfile = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(viewModel.requests, id: \.requestID) { request in
                        if let dormitoryID = DormitoryIDs(rawValue: request.dormitoryID) { // Ensure dormitoryID is valid
                            RequestRow(
                                request: request,
                                formattedDate: viewModel.formatDate(from: request.date),
                                isAdmin: viewModel.currentUser?.isAdmin ?? false,
                                dormitoryID: dormitoryID // Pass the valid dormitoryID
                            ) {
                                Task {
                                    await viewModel.deleteRequest(requestID: request.requestID)
                                }
                            }
                        } else {
                            // Handle invalid dormitoryID if needed
                            Text("Invalid dormitory ID")
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Запити")
        .onAppear {
            Task {
                await viewModel.loadCurrentUser()
                await viewModel.loadRequests()
            }
        }
    }
}

//#Preview {
//    RequestView()
//}
