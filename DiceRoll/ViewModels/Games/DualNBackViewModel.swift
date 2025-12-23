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
import CoreData

final class DualNBackViewModel: ObservableObject {
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
    
    @Published private(set) var config: GameConfig
    private let context: NSManagedObjectContext
    
    private let audio = AudioService()
    private var tickCancellable: AnyCancellable?
    private let feedbackDuration: TimeInterval = 0.35
        
    init(context: NSManagedObjectContext) {
        self.context = context
        self.config = Self.loadConfig(from: context)
    }

    private static func loadConfig(from context: NSManagedObjectContext) -> GameConfig {
        let request: NSFetchRequest<DualNBackGame> = DualNBackGame.fetchRequest()
        if let saved = try? context.fetch(request).first {
            return GameConfig(
                nth: Int(saved.nth),
                length: Int(saved.length),
                trialDuration: saved.trialDuration,
                targetRate: saved.targetRate
            )
        }
        
        return GameConfig(nth: 2, length: 30, trialDuration: 3.0, targetRate: 0.3)
    }
    
    func reloadConfig(context: NSManagedObjectContext) {
        self.config = Self.loadConfig(from: context)
    }

    func start() {
        config = Self.loadConfig(from: context)
        trials = SequenceGenerator.makeTrials(
            length: config.length,
            n: config.nth,
            targetRate: config.targetRate
        )
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
        feedbackColor = nil

        audio.play(t.stimulus.sound)
    }

    private func endTrialAndAdvance() {
        guard currentIndex < trials.count else { return }
        let t = trials[currentIndex]
        canRespond = false

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
        
        flashFeedback(correct: trials[currentIndex].isPosTarget)
    }

    func respondSoundMatch() {
        guard canRespond, !soundResponded else { return }
        soundResponded = true
        
        flashFeedback(correct: trials[currentIndex].isSoundTarget)
    }
    
    private func flashFeedback(correct: Bool) {
        feedbackColor = correct ? .green.opacity(0.45) : .red.opacity(0.45)
        doHaptic(correct: correct)
        DispatchQueue.main.asyncAfter(deadline: .now() + feedbackDuration) {[weak self] in
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

        posAccuracy = Double(results.filter { $0.posCorrect }.count) / Double(results.count)
        soundAccuracy = Double(results.filter { $0.soundCorrect }.count) / Double(results.count)
    }

//    private func adaptNIfNeeded() {
//        let avgAcc = (posAccuracy + soundAccuracy) / 2.0
//        var newConfig = config
//
//        if avgAcc >= 0.80 {
//            newConfig.nth += 1
//        } else if avgAcc <= 0.50 && newConfig.nth > 1 {
//            newConfig.nth -= 1
//        }
//
//        if newConfig.nth != config.nth {
//            updateConfig(newConfig)
//        }
//    }

}
