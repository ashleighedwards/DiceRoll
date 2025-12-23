//
//  GameConfigForm.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

import SwiftUI

struct GameConfigForm: View {
    @Binding var config: GameConfig

    var body: some View {
        Section(header: Text("Difficulty")) {
            Stepper {
                Text("N-Back: \(config.nth)")
            } onIncrement: {
                config.nth += 1
            } onDecrement: {
                if config.nth > 1 {
                    config.nth -= 1
                }
            }
        }

        Section(header: Text("Trials")) {
            Stepper(
                "Trial count: \(config.length)",
                value: $config.length,
                in: (config.nth + 5)...120,
                step: 5
            )

            VStack(alignment: .leading, spacing: 6) {
                Text("Trial duration: \(config.trialDuration, specifier: "%.1f") s")
                Slider(
                    value: $config.trialDuration,
                    in: 1.0...4.0,
                    step: 0.25
                )
            }
        }

        Section(header: Text("Target Rate")) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Target probability: \(Int(config.targetRate * 100))%")
                Slider(
                    value: $config.targetRate,
                    in: 0.1...0.6,
                    step: 0.05
                )
            }
        }
    }
}
