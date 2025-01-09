//
//  AddButton.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        ZStack {
            VariableBlurView(maxBlurRadius: 10, direction: .blurredBottomClearTop)
                .shadow(radius: 5)
            
            Button(action: action) {
                Image(systemName: "plus")
                    .circleButton
            }
            .padding(.vertical)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .frame(height: 35)
    }
}
