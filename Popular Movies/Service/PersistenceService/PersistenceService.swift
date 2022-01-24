//
//  PersistenceService.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import Foundation
import CoreData

final class PersistentService {
    static let shared = PersistentService()
    var context: NSManagedObjectContext {
        let viewContext = container.viewContext
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return viewContext
    }
    
    lazy var container: NSPersistentContainer = {
        let persistentContatiner = NSPersistentContainer(name: "MoviePersistentData")
        persistentContatiner.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContatiner
    }()
    
    private init() {}
    
    func fetchObjects<T: NSManagedObject>(entity: T.Type) -> [T] {
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>.init(entityName: entityName)
        do {
            let list = try context.fetch(fetchRequest)
            return list
        } catch {
            return []
        }
    }
    
    func save() {
        do {
        try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
