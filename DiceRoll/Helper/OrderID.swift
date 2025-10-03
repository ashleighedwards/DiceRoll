//
//  OrderID.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import Foundation

enum OrderID {
    static func make(prefix: String = "DR") -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        let date = df.string(from: Date())
        let rand = UUID().uuidString
            .replacingOccurrences(of: "-", with: "")
            .prefix(6)
            .uppercased()
        return "\(prefix)-\(date)-\(rand)"
    }
}
