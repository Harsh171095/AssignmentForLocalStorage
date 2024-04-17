//
//  CoreDataStackProtocol.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import Foundation
import CoreData

protocol CreateProtocol {
    associatedtype T: NSManagedObject
    func createObject() -> T?
}

protocol ReadProtocol {
    associatedtype T: NSManagedObject
    func fetchObjects(predicates: [NSPredicate]?, sortDescriptors: [NSSortDescriptor]?) -> [T]?
}

protocol UpdateProtocol {
    associatedtype T: NSManagedObject
    func updateObject(object: T)
}

protocol DeleteProtocol {
    associatedtype T: NSManagedObject
    func deleteObject(object: T)
}
