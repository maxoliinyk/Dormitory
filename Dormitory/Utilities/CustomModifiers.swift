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
    }
}

extension View {
    func modifiedField() -> some View {
        modifier(ModifiedTextField())
    }
}
