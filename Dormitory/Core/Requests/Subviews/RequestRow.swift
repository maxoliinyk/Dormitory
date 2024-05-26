//
//  RequestRow.swift
//  Dormitory
//
//  Created by Max Oliinyk on 25.05.2024.
//

import SwiftUI

struct RequestRow: View {
    let request: DBRequest
    let formattedDate: String
    let isAdmin: Bool
    let dormitoryID: DormitoryIDs // Ensure this is from the correct module
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(request.title)
                    .font(.headline)
                Text(request.content)
                    .font(.subheadline)
                Text("Повідомив: \(request.postedBy)")
                    .font(.caption)
                Text("Кімната №\(request.roomNumber)")
                    .font(.caption)
                
                HStack {
                    Text(dormitoryID.displayName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            
            if isAdmin {
                Button(role: .destructive, action: deleteAction) {
                    Image(systemName: "trash")
                }
                .font(.caption)
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.bottom, 5)
    }
}
