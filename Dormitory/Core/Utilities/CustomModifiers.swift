//
//  CustomModifiers.swift
//  Dormitory
//
//  Created by Max Oliinyk on 21.05.2024.
//

import Foundation
import SwiftUI

struct CircleButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 70, height: 70)
            .background(Color.blue)
            .clipShape(Circle())
            .shadow(radius: 10)
            .padding(.bottom)
    }
}

struct ProceedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct ModifiedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .autocorrectionDisabled(true)
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
    var modifiedField: some View {
        modifier(ModifiedTextField())
    }
    
    var profileText: some View {
        modifier(ProfileCell())
    }
    
    var proceedButton: some View {
        modifier(ProceedButton())
    }
    
    var circleButton: some View {
        modifier(CircleButton())
    }
}
