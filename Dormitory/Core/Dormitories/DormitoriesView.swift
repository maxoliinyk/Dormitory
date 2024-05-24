//
//  DormitoriesView.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import SwiftUI

@MainActor
final class DormitoriesViewModel: ObservableObject {
    func loadDormitoriesFromLocalFileAndUploadToFirebase() {
        guard let fileUrl = Bundle.main.url(forResource: "dormitories", withExtension: "json") else {
            print("Failed to locate the JSON file in the bundle.")
            return
        }
        Task {
            do {
                let data = try Data(contentsOf: fileUrl)
                
                let dormitories = try JSONDecoder().decode(DormitoriesArray.self, from: data)
                let dormitoryArray = dormitories.dormitories
                
                for dormitory in dormitoryArray {
                    try? await DormitoriesManager.shared.uploadDormitory(dormitory: dormitory)
                }
                
                print("SUCCESS")
                print(dormitories.dormitories.count)
            } catch {
                print("Error loading or processing JSON file: \(error)")
            }
        }
    }
}

struct DormitoriesView: View {
    @StateObject private var viewModel = DormitoriesViewModel()
    var body: some View {
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle("Dormitories")
        .onAppear() {
            viewModel.loadDormitoriesFromLocalFileAndUploadToFirebase()
        }
    }
}

#Preview {
    NavigationStack {
        DormitoriesView()
    }
}
