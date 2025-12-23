//
//  DualNBack+Mapping.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

import CoreData

extension DualNBackGame {
    func toModel() -> GameConfig {
        GameConfig(
            nth: Int(nth),
            length: Int(length),
            trialDuration: trialDuration,
            targetRate: targetRate
        )
    }

    func update(from config: GameConfig) {
        nth = Int16(config.nth)
        length = Int16(config.length)
        trialDuration = config.trialDuration
        targetRate = config.targetRate
    }
}
