//
//  OrdersView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import Foundation
import SwiftUICore

struct OrdersView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        OrdersSearchView(context: viewContext)
    }
}
