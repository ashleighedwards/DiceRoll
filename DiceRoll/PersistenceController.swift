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
                fatalError("Core Data store failed to load: \(error), \(error.userInfo)")
            } else {
                print("Core Data store loaded: \(description)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func purgeOldOrders(olderThan days: Int = 5) {
        let bgContext = container.newBackgroundContext()
        bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        bgContext.perform {
            let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
            
            let fetch: NSFetchRequest<NSFetchRequestResult> = Order.fetchRequest()
            fetch.predicate = NSPredicate(format: "createdAt < %@", cutoff as NSDate)

            let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
            deleteReq.resultType = .resultTypeObjectIDs
            
            do {
                if let result = try bgContext.execute(deleteReq) as? NSBatchDeleteResult,
                   let deletedIDs = result.result as? [NSManagedObjectID],
                   !deletedIDs.isEmpty {
                    let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: deletedIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.container.viewContext])
                }
            } catch {
                #if DEBUG
                print("Failed to purge old orders:", error)
                #endif
            }
        }
    }
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved preview error \(nsError)")
        }

        return controller
    }()
}
