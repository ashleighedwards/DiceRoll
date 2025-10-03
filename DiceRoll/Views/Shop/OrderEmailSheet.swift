//
//  OrderEmailSheet.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import SwiftUI

struct OrderEmailSheet: View {
    @StateObject private var vm: OrderEmailViewModel

    init(to: String, order: Order) {
        _vm = StateObject(wrappedValue: OrderEmailViewModel(to: to, order: order))
    }

    var body: some View {
        MailComposerView(
            to: [vm.to],
            subject: vm.subject,
            body: vm.body
        )
    }
}

