//
//  ProductDetailView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 01/10/2025.
//

import SwiftUI
import CoreData

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageName = product.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            Text(product.productName ?? "Unknown")
                .font(.title)
                .fontWeight(.bold)
            
            Text(product.productDescription ?? "Unknown")
                .font(.body)
                .fontWeight(.bold)
            
            Text("£\(product.price, specifier: "%.2f")")
                .font(.title2)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text("Stock available: \(product.availability)")
                .font(.subheadline)
                .foregroundStyle(product.availability > 0 ? .green : .red)
            
        }
        .padding()
        .navigationTitle("Product details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
