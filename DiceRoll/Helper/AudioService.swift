//
//  AudioService.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

import AVFoundation


final class AudioService {
    private var players: [SoundToken: AVAudioPlayer] = [:]

    init() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, options: [.mixWithOthers])
        try? session.setActive(true, options: [])

        preload()
    }

    private func preload() {
        for token in SoundToken.allCases {
            guard let url = Bundle.main.url(forResource: token.rawValue, withExtension: "wav") else {
                #if DEBUG
                print("⚠️ Missing audio clip: \(token.rawValue).wav")
                #endif
                continue
            }
            do {
                let p = try AVAudioPlayer(contentsOf: url)
                p.volume = 1.0
                p.prepareToPlay()
                players[token] = p
            } catch {
                #if DEBUG
                print("⚠️ Failed to load \(token.rawValue).wav: \(error)")
                #endif
            }
        }
    }

    func play(_ token: SoundToken) {
        guard let p = players[token] else { return }
        p.currentTime = 0
        DispatchQueue.global(qos: .userInitiated).async {
            _ = p.play()
        }
    }
}
