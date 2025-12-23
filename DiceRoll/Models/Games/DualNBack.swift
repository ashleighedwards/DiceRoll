//
//  DualNBack.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

import Foundation

enum GridPos: Int, CaseIterable {
    case p0, p1, p2, p3, p4, p5, p6, p7, p8
    static func random() -> GridPos { GridPos.allCases.randomElement()! }
}

enum DNBGameState {
    case idle, running, paused, finished
}

enum SoundToken: String, CaseIterable {
    case A, B, C, D, E, F, G, H
    static func random() -> SoundToken { SoundToken.allCases.randomElement()! }
}

struct Stimulus: Identifiable, Equatable {
    let id = UUID()
    let position: GridPos
    let sound: SoundToken
}

struct Trial: Identifiable {
    let id = UUID()
    let stimulus: Stimulus
    let isPosTarget: Bool
    let isSoundTarget: Bool
}

struct TrialResult {
    let posResponse: Bool
    let soundResponse: Bool
    let posCorrect: Bool
    let soundCorrect: Bool
}

struct GameConfig: Equatable {
    var nth: Int
    var length: Int
    var trialDuration: TimeInterval
    var targetRate: Double
}

extension GameConfig {
    static let `default` = GameConfig(
        nth: 2,
        length: 20,
        trialDuration: 2.5,
        targetRate: 0.35
    )
}
