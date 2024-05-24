//
//  CustomModifiers.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation
import SwiftUI

struct ModifiedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .autocorrectionDisabled()
    }
}

struct ProfileCell: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color(.systemGray5))
            .shadow(radius: 15)
            .cornerRadius(10)
            .font(.title3)
    }
}

extension View {
    func modifiedField() -> some View {
        modifier(ModifiedTextField())
    }
    
    func profileText() -> some View {
        modifier(ProfileCell())
    }
}
