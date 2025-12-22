//
//  SequenceGenerator.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

struct SequenceGenerator {
    static func makeTrials(length: Int, n: Int, targetRate: Double) -> [Trial] {
        precondition(length > n, "Length must exceed n")

        var positions = (0..<length).map { _ in GridPos.random() }
        var sounds    = (0..<length).map { _ in SoundToken.random() }

        var posTargets = Array(repeating: false, count: length)
        var soundTargets = Array(repeating: false, count: length)

        for i in n..<length {
            posTargets[i]   = Double.random(in: 0...1) < targetRate
            soundTargets[i] = Double.random(in: 0...1) < targetRate
        }

        for i in n..<length {
            if posTargets[i]   { positions[i] = positions[i - n] }
            if soundTargets[i] { sounds[i]    = sounds[i - n]    }
        }

        return (0..<length).map { i in
            Trial(
                stimulus: Stimulus(position: positions[i], sound: sounds[i]),
                isPosTarget: posTargets[i],
                isSoundTarget: soundTargets[i]
            )
        }
    }
}

