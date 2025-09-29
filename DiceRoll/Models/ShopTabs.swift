//
//  ShopTabs.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

enum ShopTabs: String, CaseIterable, Identifiable {
    case products = "Products"
    case cart = "Cart"
    
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .products: return "bag"
        case .cart: return "cart"
        }
    }
}
