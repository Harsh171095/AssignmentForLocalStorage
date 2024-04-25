//
//  LoginViewModel.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import Foundation

class LoginViewModel {
    
    private var coreDataManager: CoreDataManager  {
        return CoreDataManager.insatnce
    }
    private var email = ""
    private var password = ""
    
    func isUserValid(email: String, password: String )-> String? {
        self.email = email
        self.password = password
        let emailValid =  email.isValidEmail
        let passwordValid =  password.isValidPassword
        
        if emailValid.status == false {
            return emailValid.message
        }
        else if passwordValid.status == false {
            return emailValid.message
        }
        return nil
    }
    
    
    func login() throws {
        do {
            let predicate1 = NSPredicate(format: "email == %@", email)
            if let useData: [Users] = coreDataManager.fetchObjects(predicates: [predicate1], sortDescriptors: nil) {
                if (useData.isEmpty) {
                    throw NSError(domain: "Login Fauile", code: 205, userInfo: [NSLocalizedDescriptionKey : "You Are Not Register. Please Register First."])
                } else if ((useData.first?.password ?? "") != password) {
                    throw NSError(domain: "Login Fauile", code: 205, userInfo: [NSLocalizedDescriptionKey : "Invalid Password. Please Enter valid Password."])
                } else {
                    AuthUser.updateUserSession(useData.first!)
                   
                }
            } else {
                throw NSError(domain: "Login Fauile", code: 205, userInfo: [NSLocalizedDescriptionKey : "You Are Not Register. Please Register First."])
            }
        }
    }
}
