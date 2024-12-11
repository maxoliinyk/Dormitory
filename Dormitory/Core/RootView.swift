//
//  RootView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 16.05.2024.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                NavigationStack {
                    Group {
                        if viewModel.isAdmin {
                            AdminNotificationView(rootViewModel: viewModel)
                        } else {
                            UserNotificationView(rootViewModel: viewModel, dormitoryID: viewModel.dormitoryID ?? "dormitory1")
                        }
                    }
                }
            } else {
                NavigationStack {
                    LogInEmailView(rootViewModel: viewModel)
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            }
        }
    }
}

#Preview {
    RootView()
}

