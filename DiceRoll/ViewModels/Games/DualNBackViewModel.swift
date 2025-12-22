//
//  GameState.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

import Foundation
import Combine
import AVFoundation
import UIKit
import SwiftUI

enum DNBGameState { case idle, running, paused, finished }

final class DualNBackViewModel: ObservableObject {
    @Published private(set) var config: GameConfig
    @Published private(set) var state: DNBGameState = .idle

    @Published private(set) var trials: [Trial] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var currentStimulus: Stimulus?

    @Published private(set) var canRespond: Bool = false
    @Published private(set) var posResponded: Bool = false
    @Published private(set) var soundResponded: Bool = false

    @Published private(set) var results: [TrialResult] = []
    @Published private(set) var posAccuracy: Double = 0.0
    @Published private(set) var soundAccuracy: Double = 0.0
    @Published private(set) var score: Int = 0
    
    @Published var feedbackColor: Color? = nil

    private let audio = AudioService()
    private var tickCancellable: AnyCancellable?
    private var trialStartTime: Date?
    private let feedbackDuration: TimeInterval = 0.35

    init(config: GameConfig) {
        self.config = config
    }

    func start() {
        trials = SequenceGenerator.makeTrials(length: config.length, n: config.n, targetRate: config.targetRate)
        currentIndex = 0
        results = []
        score = 0
        state = .running
        advanceToCurrent()
        scheduleTimer()
    }

    func pause() {
        tickCancellable?.cancel()
        state = .paused
    }

    func resume() {
        guard state == .paused else { return }
        state = .running
        scheduleTimer()
    }

    func stop() {
        tickCancellable?.cancel()
        state = .finished
        computeAccuracy()
        adaptNIfNeeded()
    }

    private func scheduleTimer() {
        tickCancellable?.cancel()

        tickCancellable = Timer
            .publish(every: config.trialDuration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.endTrialAndAdvance()
            }
    }

    private func advanceToCurrent() {
        guard currentIndex < trials.count else {
            stop()
            return
        }
        let t = trials[currentIndex]
        currentStimulus = t.stimulus
        posResponded = false
        soundResponded = false
        canRespond = true
        trialStartTime = Date()
        
        feedbackColor = nil

        audio.play(t.stimulus.sound)
    }

    private func endTrialAndAdvance() {
        guard currentIndex < trials.count else { return }

        let t = trials[currentIndex]
        canRespond = false

        // compute correctness
        let posCorrect = (t.isPosTarget == posResponded)
        let soundCorrect = (t.isSoundTarget == soundResponded)
        results.append(TrialResult(
            posResponse: posResponded,
            soundResponse: soundResponded,
            posCorrect: posCorrect,
            soundCorrect: soundCorrect
        ))
        if posCorrect { score += 1 }
        if soundCorrect { score += 1 }

        currentIndex += 1
        advanceToCurrent()
    }

    func respondPositionMatch() {
        guard canRespond, !posResponded else { return }
        posResponded = true
        
        let t = trials[currentIndex]
        let correct = t.isPosTarget == true
        flashFeedback(correct: correct)
    }

    func respondSoundMatch() {
        guard canRespond, !soundResponded else { return }
        soundResponded = true
        let t = trials[currentIndex]
        let correct = t.isSoundTarget == true
        flashFeedback(correct: correct)
    }
    
    private func flashFeedback(correct: Bool) {
        feedbackColor = correct ? .green.opacity(0.45) : .red.opacity(0.45)
        doHaptic(correct: correct)
        // Auto-clear after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + feedbackDuration) { [weak self] in
            // Only clear if we haven't moved to next trial with a new flash
            self?.feedbackColor = nil
        }
    }
    
    private func doHaptic(correct: Bool) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(correct ? .success : .error)
    }

    private func computeAccuracy() {
        guard !results.isEmpty else { return }
        let posCorrectCount = results.filter { $0.posCorrect }.count
        let soundCorrectCount = results.filter { $0.soundCorrect }.count
        posAccuracy = Double(posCorrectCount) / Double(results.count)
        soundAccuracy = Double(soundCorrectCount) / Double(results.count)
    }

    private func adaptNIfNeeded() {
        let avgAcc = (posAccuracy + soundAccuracy) / 2.0
        if avgAcc >= 0.80 { config.n += 1 }
        else if avgAcc <= 0.50 && config.n > 1 { config.n -= 1 }
    }
}

