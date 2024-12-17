//
//  ProfileRequestRow.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct ProfileRequestRow: View {
    let request: DBRequest
    
    var body: some View {
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
}

//#Preview {
//    ProfileRequestRow()
//}
