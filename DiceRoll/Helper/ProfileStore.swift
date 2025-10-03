//
//  ProfileStore.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

// ProfileStore.swift
import CoreData

enum ProfileStore {
    static func fetchEmail(in context: NSManagedObjectContext) -> String? {
        let req: NSFetchRequest<Profile> = Profile.fetchRequest()
        req.fetchLimit = 1
        return (try? context.fetch(req).first?.email) ?? nil
    }
}
