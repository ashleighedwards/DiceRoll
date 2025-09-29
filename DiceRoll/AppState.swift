//
//  AppState.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 28/09/2025.
//

import Foundation

class AppState: ObservableObject {
    @Published var languageUpdateID = UUID()
    
    func reloadLanguage() {
        languageUpdateID = UUID()
    }
}
