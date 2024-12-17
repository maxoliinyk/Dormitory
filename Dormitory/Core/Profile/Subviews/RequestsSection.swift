//
//  RequestsSection.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct RequestsSection: View {
    let requests: [DBRequest]
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.horizontal)
            
            Text("Запити мого гуртожитку")
                .font(.title2.bold())
                .padding(.leading)
            
            Divider()
                .padding(.bottom)
                .padding(.horizontal)
            
            if requests.isEmpty {
                Text("Не знайдено жодного запиту.")
                    .font(.subheadline)
                    .padding()
            } else {
                ForEach(requests) { request in
                    ProfileRequestRow(request: request)
                }
            }
        }
    }
}
