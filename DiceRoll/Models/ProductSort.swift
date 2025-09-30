//
//  ProductSort.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 30/09/2025.
//

import Foundation

enum ProductSort: String, CaseIterable, Identifiable {
    case nameAsc = "Name ↑"
    case nameDesc = "Name ↓"
    case priceAsc = "Price ↑"
    case priceDesc = "Price ↓"
    
    var id: String { rawValue }
    
    var sortDescriptor: SortDescriptor<Product> {
        switch self {
        case .nameAsc:
            SortDescriptor(\.productName, order: .forward)
        case .nameDesc:
            SortDescriptor(\.productName, order: .reverse)
        case .priceAsc:
            SortDescriptor(\.price, order: .forward)
        case .priceDesc:
            SortDescriptor(\.price, order: .reverse)
        }
    }
}
