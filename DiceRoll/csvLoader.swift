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
            let rows = data.components(separatedBy: "\n").dropFirst()
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 5 {
                    let product = Product(context: context)
                    product.id = UUID()
                    product.productName = columns[1]
                    product.price = Double(columns[2]) ?? 0.0
                    product.imageName = columns[3]
                    product.availability = Int16(columns[4]) ?? 0
                }
            }
            
            try context.save()
        } catch {
            print("Failed to load CSV")
        }
    }
}
