//
//  CoreDataStack.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import Foundation
import CoreData

struct CoreDataManager: CreateProtocol ,ReadProtocol, UpdateProtocol, DeleteProtocol {
    typealias T = NSManagedObject
    
    static let insatnce = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "AssignmentForLocalStorage")
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        })
    }
    
    func createObject<T: NSManagedObject>() -> T? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self), in: persistentContainer.viewContext) else {
            return nil
        }
        return T(entity: entityDescription, insertInto: persistentContainer.viewContext)
    }
    
    func fetchObjects<T: NSManagedObject>(predicates: [NSPredicate]?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        if let predicates = predicates {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching objects: \(error)")
            return nil
        }
    }
    
    func fetchObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        self.fetchObjects(predicates: predicate == nil ? nil : [predicate!], sortDescriptors: sortDescriptors)
    }
    
    func updateObject<T: NSManagedObject>(object: T) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error updating object: \(error)")
        }
    }
    
    func deleteObject<T: NSManagedObject>(object: T) {
        persistentContainer.viewContext.delete(object)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
}
