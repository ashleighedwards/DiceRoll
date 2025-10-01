//
//  CartViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 30/09/2025.
//

import Foundation
import CoreData

@MainActor
class CartViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<CartItem>
    
    @Published var items: [CartItem] = []
    @Published var errorMessage: String?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.sortDescriptors = []
        
        frc = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        frc.delegate = self
        fetchItems()
    }
    
    func fetchItems() {
        do {
            try frc.performFetch()
            items = frc.fetchedObjects ?? []
        } catch {
            errorMessage = "Failed to fetch"
        }
    }
    
    nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
                    self.items = self.frc.fetchedObjects ?? []
                }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product?.price ?? 0) * Double($1.quantity)}
    }
    
    func clearCart() {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        if let items = try? context.fetch(request) {
            for item in items {
                if let product = item.product {
                    product.availability += item.quantity
                }
                context.delete(item)
            }
            saveContext()
        }
    }
    
    func purchaseItems() {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        if let items = try? context.fetch(request) {
            for item in items {
                if let product = item.product {
                    product.availability -= item.quantity
                }
                context.delete(item)
            }
            saveContext()
        }
    }

    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            errorMessage = "Failed to save"
        }
    }
}
