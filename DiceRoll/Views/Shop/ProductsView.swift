//
//  ProductsView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUI
import CoreData

struct ProductsView: View {
    @ObservedObject var viewModel: ProductViewModel
    @State private var selectedSort: ProductSort = .nameAsc
    @State private var products: [Product] = []
    @Binding var selectedTab: ShopTabs
    
    init(viewModel: ProductViewModel, selectedTab: Binding<ShopTabs>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _selectedTab = selectedTab
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Tabs", selection: $selectedTab) {
                ForEach(ShopTabs.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.top, 8)
            
            List {
                ForEach(products, id: \.objectID) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.productName ?? "Unknown")
                                Text("£\(product.price, specifier: "%.2f")")
                                    .foregroundColor(.gray)
                                Text("Stock: \(product.availability)")
                                    .font(.caption)
                                    .foregroundColor(product.availability > 0 ? .secondary : .red)
                            }
                            Spacer()
                            if let item = viewModel.cartItem(for: product) {
                                QuantityControl(
                                    item: item,
                                    onIncrement: { viewModel.incrementCartItem(item) },
                                    onDecrement: { viewModel.decrementCartItem(item) }
                                )
                            } else {
                                Button {
                                    viewModel.addToCart(product: product)
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                }
                                .buttonStyle(.plain)
                                .disabled(product.availability <= 0)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(ProductSort.allCases) { sort in
                            Button {
                                selectedSort = sort
                                $products.sort = [sort.swiftUISort]
                            } label: {
                                Text(sort.rawValue)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Sort")
                            Image(systemName: "arrow.up.arrow.down")
                        }.font(.caption)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Shop")
        .onAppear {
            products = viewModel.fetchProducts(sortedBy: selectedSort)
        }
        .onChange(of: selectedSort) { newSort in
            products = viewModel.fetchProducts(sortedBy: newSort)
        }
    }
}
