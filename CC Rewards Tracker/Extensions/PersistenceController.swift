//
//  PersistenceController.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/24.
//

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Optionally, add some mock data here for the preview
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Rewards")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.danielluo.CCRT")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func loadPersistentStore(container: NSPersistentContainer, completion: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                // Check if error is migration/incompatibility error
                let isMigrationError = (error.domain == NSCocoaErrorDomain) &&
                    (error.code == NSPersistentStoreIncompatibleVersionHashError || error.code == NSMigrationMissingSourceModelError)
                
                if isMigrationError {
                    // Delete incompatible store
                    if let url = description.url {
                        do {
                            try container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
                            print("Deleted incompatible store at \(url). Retrying load...")
                            
                            // Retry loading store after deletion
                            container.loadPersistentStores(completionHandler: completion)
                            return
                        } catch {
                            print("Failed to delete incompatible store: \(error)")
                        }
                    }
                }
            }
            completion(description, error)
        }
    }
}
