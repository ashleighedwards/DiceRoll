//
//  GameConfigStore.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 22/12/2025.
//


import CoreData

final class GameConfigStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func load() -> GameConfig {
        let request: NSFetchRequest<DualNBackGame> = DualNBackGame.fetchRequest()
        request.fetchLimit = 1

        if let entity = try? context.fetch(request).first {
            return entity.toModel()
        }
        return .default
    }

    func save(_ config: GameConfig) {
        let request: NSFetchRequest<DualNBackGame> = DualNBackGame.fetchRequest()
        request.fetchLimit = 1

        let entity = (try? context.fetch(request).first)
            ?? DualNBackGame(context: context)

        entity.update(from: config)
        try? context.save()
    }
}
