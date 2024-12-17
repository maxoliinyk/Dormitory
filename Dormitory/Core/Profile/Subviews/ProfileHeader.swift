//
//  ProfileHeader.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct ProfileHeader: View {
    let user: DBUser
    let dormitoryID: DormitoryIDs
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .font(.caption2)
                .padding(.horizontal, 100)
                .shadow(radius: 10)
            
            Text("\(user.name ?? "") \(user.lastName ?? "")")
                .font(.title.bold())
            
            Text("\(dormitoryID.displayName) • \(user.roomNumber ?? "") кімната")
                .font(.footnote)
                .padding(.bottom, 15)
        }
        .padding(.bottom, 10)
    }
}

//#Preview {
//    ProfileHeader()
//}
