//
//  LanguageViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 24/09/2025.
//

import Foundation
import CoreData
import SwiftUI
import Combine
import PhotosUI

@MainActor
class LanguageViewModel: ObservableObject {
    @Published var language: String = "en"
    @Published var region: String = "GB"
    
    @Published var availableLanguages: [LanguageOptions] = []
    @Published var availableRegions: [RegionOptions] = []
        
    private var languageModel: Language?
    private var viewContext: NSManagedObjectContext
    
    private let debounceDelay: TimeInterval = 0.5
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadLanguage()
        loadLanguageOptions()
        loadRegions()
    }
    
    func loadLanguage() {
        let request: NSFetchRequest<Language> = Language.fetchRequest()
        request.fetchLimit = 1

        do {
            if let existing = try viewContext.fetch(request).first {
                languageModel = existing
                language = existing.language ?? "en"
                region = existing.region ?? region
            } else {
                language = "en"
                region = "GB"
            }
        } catch {
            print("Failed to fetch profile: \(error.localizedDescription)")
        }
    }
    
    func loadLanguageOptions() {
        let locale = Locale.current
        let codes = Set(Locale.availableIdentifiers.compactMap {
            Locale(identifier: $0).language.languageCode?.identifier
        })

        let options = codes.compactMap { code -> LanguageOptions? in
            if let name = locale.localizedString(forLanguageCode: code) {
                return LanguageOptions(code: code, name: name)
            }
            return nil
        }

        self.availableLanguages = options.sorted { $0.name < $1.name }
    }
    
    func loadRegions() {
        let locale = Locale.current

        self.availableRegions = Locale.Region.isoRegions.compactMap { region in
            if let name = locale.localizedString(forRegionCode: region.identifier) {
                return RegionOptions(id: region.identifier, name: name)
            }
            return nil
        }
        .sorted { $0.name < $1.name }
    }
    
    func saveLanguageAndRegion() {
        if languageModel == nil {
            languageModel = Language(context: viewContext)
        }
        
        languageModel?.language = language
        languageModel?.region = region
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
}
