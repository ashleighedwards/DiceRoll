//
//  ProductSort.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 30/09/2025.
//

import Foundation
import CoreData

enum ProductSort: String, CaseIterable, Identifiable {
    case nameAsc = "Name ↑"
    case nameDesc = "Name ↓"
    case priceAsc = "Price ↑"
    case priceDesc = "Price ↓"
    
    var id: String { rawValue }
    
    var nsSort: NSSortDescriptor {
            switch self {
            case .nameAsc:
                return NSSortDescriptor(
                    key: "productName",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            case .nameDesc:
                return NSSortDescriptor(
                    key: "productName",
                    ascending: false,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            case .priceAsc:
                return NSSortDescriptor(key: "price", ascending: true)
            case .priceDesc:
                return NSSortDescriptor(key: "price", ascending: false)
            }
        }
}
