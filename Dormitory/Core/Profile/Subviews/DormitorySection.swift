//
//  DormitorySection.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct DormitorySection: View {
    let dormitory: DBDormitory
    
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal)
            
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
                
                Text(dormitory.number)
                    .font(.largeTitle)
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

//#Preview {
//    DormitorySection()
//}
