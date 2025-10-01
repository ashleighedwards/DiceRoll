//
//  csvLoader.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import Foundation
import CoreData

class CSVLoader {
    static func loadProductsFromCSV(into context: NSManagedObjectContext) {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "csv") else {
            print("products.csv not found")
            return
        }
        
        do {
            let data = try String(contentsOf: url, encoding: .utf8)
            var rows = data.components(separatedBy: .newlines)
            rows.removeFirst()
            
            for row in rows where !row.isEmpty {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 6 {
                    let product = Product(context: context)
                    product.id = UUID()
                    product.productName = columns[1]
                    product.price = Double(columns[2]) ?? 0.0
                    product.imageName = columns[3]
                    product.availability = Int16(columns[4]) ?? 0
                    product.productDescription = columns[5]
                }
            }
            
            try context.save()
        } catch {
            print("Failed to load CSV")
        }
    }
}
