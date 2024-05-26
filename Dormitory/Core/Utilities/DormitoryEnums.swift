//
//  DormitoryEnums.swift
//  Dormitory
//
//  Created by Max Oliinyk on 26.05.2024.
//

import Foundation

enum DormitoryIDs: String, CaseIterable, Identifiable {
    case dormitory1 = "dormitory1"
    case dormitory2 = "dormitory2"
    case dormitory3 = "dormitory3"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .dormitory1:
            return "Гуртожиток 1"
        case .dormitory2:
            return "Гуртожиток 2"
        case .dormitory3:
            return "Гуртожиток 3"
        }
    }
}

