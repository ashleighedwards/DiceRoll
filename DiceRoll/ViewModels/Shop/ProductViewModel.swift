//
//  ProductViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import Foundation
import CoreData

@MainActor
class ProductViewModel: ObservableObject {
    private var context: NSManagedObjectContext
    @Published var errorMessage: String?
    @Published var products: [Product] = []
    @Published var selectedSort: ProductSort = .nameAsc
    
//    private(set) var currentSort: ProductSort = .nameAsc
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadProducts()
    }
    
    func loadProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [selectedSort.nsSort]
        products = (try? context.fetch(request)) ?? []
    }
    
    func cartItem(for product: Product) -> CartItem? {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "product == %@", product)
        return try? context.fetch(request).first
    }
    
    func seedProductsIfNeeded() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        if (try? context.count(for: request)) == 0 {
            CSVLoader.loadProductsFromCSV(into: context)
        }
    }
    
    func addToCart(product: Product) {
        if let existing = cartItem(for: product) {
            existing.quantity += 1
            existing.timestamp = Date()
        } else {
            let newItem = CartItem(context: context)
            newItem.id = UUID()
            newItem.quantity = 1
            newItem.product = product
            newItem.timestamp = Date()
        }
        saveContext()
        loadProducts()
    }
    
    func fetchProducts(sortedBy sort: ProductSort) -> [Product] {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [sort.nsSort]
        return (try? context.fetch(request)) ?? []
    }
    
    func incrementCartItem(_ item: CartItem) {
        guard let product = item.product, product.availability > 0 else {
            errorMessage = "Out of stock"
            return
        }
        
        item.quantity += 1
        item.timestamp = Date()
        saveContext()
        loadProducts()
    }
    
    func decrementCartItem(_ item: CartItem) {
        if item.quantity > 1 {
            item.quantity -= 1
        } else {
            context.delete(item)
        }
        saveContext()
        loadProducts()
    }
    
    func clearExpiredCartItems() {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        let expiryDate = Date().addingTimeInterval(-3600)
        
        request.predicate = NSPredicate(format: "timestamp < %@", expiryDate as NSDate)
        
        do {
            let expiredItems = try context.fetch(request)
            for item in expiredItems {
                context.delete(item)
            }
            try context.save()
        } catch {
            errorMessage = "Failed to clear items"
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            context.rollback()
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}

extension ProductViewModel {
    var cartItems: [CartItem] {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.sortDescriptors = []
        return (try? context.fetch(request)) ?? []
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.product?.price ?? 0) * Double($1.quantity) }
    }
}

extension ProductViewModel {
    func reloadProductsFromCSV() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        if let products = try? context.fetch(request) {
            for product in products {
                context.delete(product)
            }
        }
        
        CSVLoader.loadProductsFromCSV(into: context)
    }
}
