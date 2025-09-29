//
//  ProductViewModelTests.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import XCTest
import CoreData
@testable import DiceRoll

@MainActor
final class ProductViewModelTests: XCTestCase {
    
    var persistenceContainer: NSPersistentContainer!
    var context: NSManagedObjectContext!
    var viewModel: ProductViewModel!
    
    override func setUp() {
        super.setUp()
        
        persistenceContainer = NSPersistentContainer(name: "Model")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistenceContainer.persistentStoreDescriptions = [description]
        
        persistenceContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        
        context = persistenceContainer.viewContext
        viewModel = ProductViewModel(context: context)
    }
    
    override func tearDown() {
        viewModel = nil
        context = nil
        persistenceContainer = nil
        super.tearDown()
    }
    
    private func makeProduct(name: String = "TestProduct") -> Product {
        let product = Product(context: context)
        product.id = UUID()
        product.productName = name
        product.price = 10.0
        product.imageName = "bag"
        product.availability = 5
        return product
    }
    
    func testAddToCartCreatesNewItem() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        
        let items = try? context.fetch(CartItem.fetchRequest())
        XCTAssertEqual(items?.count, 1)
        XCTAssertEqual(items?.first?.quantity, 1)
    }

    func testAddToCartTwiceIncrementsQuantity() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        viewModel.addToCart(product: product)
        
        let items = try? context.fetch(CartItem.fetchRequest())
        XCTAssertEqual(items?.first?.quantity, 2)
    }
    
    func testIncrementCartItem() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        
        let item = viewModel.cartItem(for: product)!
        viewModel.incrementCartItem(item)
        
        XCTAssertEqual(item.quantity, 2)
    }
    
    func testDecrementCartItem() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        let item = viewModel.cartItem(for: product)!
        
        viewModel.incrementCartItem(item)
        viewModel.decrementCartItem(item)
        
        XCTAssertEqual(item.quantity, 1)
    }
    
    func testDecrementRemovesItemWhenQuantityIsOne() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        let item = viewModel.cartItem(for: product)!
        
        viewModel.decrementCartItem(item)
        
        let items = try? context.fetch(CartItem.fetchRequest())
        XCTAssertEqual(items?.count, 0)
    }
    
    func testClearExpiredCartItemsRemovesOldItems() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        
        let item = viewModel.cartItem(for: product)!
        item.timestamp = Date().addingTimeInterval(-7200)
        try? context.save()
        
        viewModel.clearExpiredCartItems()
        
        let items = try? context.fetch(CartItem.fetchRequest())
        XCTAssertEqual(items?.count, 0)
    }
    
    func testIncrementUpdatesTimestamp() {
        let product = makeProduct()
        viewModel.addToCart(product: product)
        
        let item = viewModel.cartItem(for: product)!
        let oldTimestamp = item.timestamp
        
        sleep(1) // wait a bit to ensure a difference
        viewModel.incrementCartItem(item)
        
        XCTAssertNotEqual(item.timestamp, oldTimestamp)
    }



}
