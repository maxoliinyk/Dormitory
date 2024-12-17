//
//  DismissButton.swift
//  Dormitory
//
//  Created by Max Oliinyk on 13.12.2024.
//

import SwiftUI

struct DismissButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button("Готово") {
            dismiss()
        }
    }
}
