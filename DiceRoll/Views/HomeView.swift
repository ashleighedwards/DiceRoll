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
    @StateObject private var viewModel: ProductViewModel
    
    @State private var selectedTab: ShopTabs = .products
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ProductViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Tabs", selection: $selectedTab) {
                    ForEach(ShopTabs.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                            .font(.subheadline)
                            .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 8)
                
                switch selectedTab {
                case .products:
                    ProductsView(viewModel: viewModel)
                case .cart:
                    CartView()
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.seedProductsIfNeeded()
                viewModel.clearExpiredCartItems()
            }
        }
    }
}

#Preview {
    HomeView(context: PersistenceController.preview.container.viewContext)
}
