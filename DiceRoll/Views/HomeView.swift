//
//  HomeView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//


import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var productViewModel: ProductViewModel
    @StateObject private var cartViewModel: CartViewModel
    
    @State private var selectedTab: ShopTabs = .products
    
    init(context: NSManagedObjectContext) {
        _productViewModel = StateObject(wrappedValue: ProductViewModel(context: context))
        _cartViewModel = StateObject(wrappedValue: CartViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch selectedTab {
                case .products:
                    ProductsView(viewModel: productViewModel, selectedTab: $selectedTab)
                case .cart:
                    CartView(viewModel: cartViewModel, selectedTab: $selectedTab)
                }
            }
            .onAppear {
                productViewModel.seedProductsIfNeeded()
                productViewModel.clearExpiredCartItems()
            }
        }
    }
}

#Preview {
    HomeView(context: PersistenceController.preview.container.viewContext)
}
