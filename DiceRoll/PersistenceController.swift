//
//  PersistenceController.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("💥 Core Data store failed to load: \(error), \(error.userInfo)")
            } else {
                print("✅ Core Data store loaded: \(description)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
