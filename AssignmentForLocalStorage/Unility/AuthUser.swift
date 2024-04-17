//
//  AuthUser.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import Foundation

class AuthUser {
    
    static var user: Users?
    
    static func updateUserSession(_ user: Users) {
        AuthUser.user = user
        UserDefaults.standard.set(user.email, forKey: "userSession")
    }
    
    static func clearSession() {
        AuthUser.user = nil
        UserDefaults.standard.removeObject(forKey: "userSession")
    }
    
    static func isSessionActive() -> Bool{
        if let emailAddress = UserDefaults.standard.string(forKey: "userSession")  {
            let predicate1 = NSPredicate(format: "email == %@", emailAddress)
            if let useData: [Users] = CoreDataManager.insatnce.fetchObjects(predicates: [predicate1], sortDescriptors: nil) {
                if (useData[0].id == nil) {
                    useData[0].id = UUID().uuidString
                    CoreDataManager.insatnce.updateObject(object: useData[0])
                }
                AuthUser.updateUserSession(useData[0])
            }
            return true
        }
        return false
    }
}
