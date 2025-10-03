//
//  OrdersSearchView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import SwiftUI
import CoreData

struct OrdersSearchView: View {
    @StateObject private var viewModel: OrderSearchViewModel
    @FocusState private var inputFocused: Bool
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: OrderSearchViewModel(context: context))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        TextField("Enter Order ID", text: $viewModel.query)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.asciiCapable)
                            .focused($inputFocused)

                        Button("Submit") {
                            viewModel.submit()
                            inputFocused = false
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    if let err = viewModel.lastError {
                        Text(err).foregroundStyle(.red)
                    }
                }

                if let order = viewModel.foundOrder {
                    OrderDetailView(order: order)
                }
            }
            .padding()
        }
        .navigationTitle("Track orders")
    }
}
