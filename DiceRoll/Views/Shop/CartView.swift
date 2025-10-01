//
//  CartView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUI
import CoreData

struct CartView: View {
    @ObservedObject private var viewModel: CartViewModel
    @State private var showingAlert = false
    @State private var purchaseComplete = false
    @Binding var selectedTab: ShopTabs
    
    init(viewModel: CartViewModel, selectedTab: Binding<ShopTabs>) {
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
                if !viewModel.items.isEmpty {
                    Section(header:
                        HStack {
                            Text("Item")
                                .font(.headline)
                            Spacer()
                            Text("Quantity")
                                .font(.headline)
                            Spacer()
                            Text("Price")
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    ) {
                        ForEach(viewModel.items, id: \.objectID) { item in
                            HStack {
                                Text(item.product?.productName ?? "Unknown")
                                    .frame(width: 80, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Text("\(item.quantity)")
                                Spacer()
                                let price = item.product?.price ?? 0.0
                                Text("£\(Double(item.quantity) * price, specifier: "%.2f")")
                                    .bold()
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Total: £\(viewModel.totalPrice, specifier: "%.2f")")
                            .bold()
                    }
                    .padding()
                }
            }
                
            if !viewModel.items.isEmpty {
                Button("Purchase") {
                    showingAlert = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .alert("Confirm Purchase", isPresented: $showingAlert) {
                    Button("Confirm", role: .destructive) {
                        viewModel.purchaseItems()
                        purchaseComplete = true
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Do you want to complete your purchase?")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Shop")
    }
}
