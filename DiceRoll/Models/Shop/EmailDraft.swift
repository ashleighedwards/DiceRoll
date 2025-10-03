//
//  EmailDraft.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import Foundation

struct EmailDraft: Identifiable {
    let id = UUID()
    let to: String
    let order: Order
}
