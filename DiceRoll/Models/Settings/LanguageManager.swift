//
//  LanguageManager.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 28/09/2025.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    private init() {}
    
    private(set) var currentLanguage: String = "en"
    
    func setLanguage(_ lang: String) {
        currentLanguage = lang
        
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
