//
//  CartView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUI
import CoreData
import MessageUI

struct CartView: View {
    @ObservedObject private var viewModel: CartViewModel
    @State private var showingAlert = false
    @State private var purchaseComplete = false
    @State private var lastOrderID: String?
    @Binding var selectedTab: ShopTabs
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var emailDraft: EmailDraft?
    @State private var showEmailSheet = false
    
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
            Spacer()
            if !viewModel.items.isEmpty {
                List {
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
                        .onDelete { indexSet in
                            for index in indexSet {
                                let item = viewModel.items[index]
                                viewModel.removeItem(item)
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
                
                Button("Purchase") {
                    showingAlert = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .alert("Confirm Purchase", isPresented: $showingAlert) {
                    Button("Confirm", role: .destructive) {
                        if let order = viewModel.purchaseItems() {
                            lastOrderID = order.orderId
                            if let email = ProfileStore.fetchEmail(in: viewContext), !email.isEmpty {
                                emailDraft = EmailDraft(to: email, order: order)
                            } else {
                                // prompt for email or just show a success alert without email
                            }
                            purchaseComplete = true
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Do you want to complete your purchase?")
                }
            } else {
                Text("Add items to your cart.").italic()
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Shop")
        .sheet(item: $emailDraft) { draft in
            OrderEmailSheet(to: draft.to, order: draft.order)
        }
    }
}
