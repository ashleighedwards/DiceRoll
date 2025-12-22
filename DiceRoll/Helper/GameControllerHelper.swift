//
//  ButtonHelper.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//

import Foundation

func pauseResumeTitle(for state: DNBGameState) -> String {
    switch state {
    case .running:  
        return "Pause"
    case .paused:   
        return "Resume"
    default:        
        return "Pause"
    }
}

func startStopTitle(for state: DNBGameState) -> String {
    switch state {
    case .idle, .finished: 
        return "Start"
    case .running, .paused: 
        return "Stop"
    }
}

func performPauseResume(state: DNBGameState, vm: DualNBackViewModel) {
    switch state {
    case .running:
        vm.pause()
    case .paused:
        vm.resume()
    default:
        break
    }
}

func performStartStop(state: DNBGameState, vm: DualNBackViewModel) {
    switch state {
    case .idle, .finished:
        vm.start()
    case .running, .paused:
        vm.stop()
    }
}

func isPauseResumeEnabled(for state: DNBGameState) -> Bool {
    state == .running || state == .paused
}

func isStartStopEnabled(for state: DNBGameState) -> Bool {
    true
}



