    //
    //  RegisterViewModel.swift
    //  AssignmentForLocalStorage
    //
    //  Created by admin on 25/04/24.
    //

import Foundation

class RegisterViewModel {
    
    private var userModel: RegisterRequestModel?
    
    private var coreDataManager: CoreDataManager  {
        return CoreDataManager.insatnce
    }
        // Other way to validate
    func isUserValid(userModel: RegisterRequestModel ) throws {
            // Store User Model data
        self.userModel = userModel
        
            // Validation Response
        let fullNameValid =  userModel.fullName.isValidFullName
        let emailValid =  userModel.email.isValidEmail
        let passwordValid =  userModel.password.isValidPassword
        let confirmPasswordValid =  userModel.confirmPassword.isValidConfirmPassword(old: userModel.password)
        
        if fullNameValid.status == false
        {
            throw NSError(domain: "Register Validation", code: 400, userInfo: [NSLocalizedDescriptionKey : fullNameValid.message])
        }
        else if emailValid.status == false
        {
            throw NSError(domain: "Register Validation", code: 400, userInfo: [NSLocalizedDescriptionKey : emailValid.message])
        }
        else if passwordValid.status == false
        {
            throw NSError(domain: "Register Validation", code: 400, userInfo: [NSLocalizedDescriptionKey : passwordValid.message])
        }
        else if confirmPasswordValid.status == false
        {
            throw NSError(domain: "Register Validation", code: 400, userInfo: [NSLocalizedDescriptionKey : confirmPasswordValid.message])
        }
        
    }
    
    
    func register() throws {
        guard let userModel = self.userModel else {
            throw NSError(domain: "Register Fauile", code: 205, userInfo: [NSLocalizedDescriptionKey : "Invalid User Info."])
        }
        
        do {
            let predicate1 = NSPredicate(format: "email == %@", userModel.email)
            if let useData: [Users] = coreDataManager.fetchObjects(predicates: [predicate1], sortDescriptors: nil) {
                if (useData.isEmpty == false) {
                    throw NSError(domain: "Register Fauile", code: 205, userInfo: [NSLocalizedDescriptionKey : "You Are Already Register. Please Login."])
                } else {
                    if let user: Users = coreDataManager.createObject() {
                        user.id = UUID().uuidString
                        user.name = userModel.fullName
                        user.email = userModel.email
                        user.password = userModel.password
                        user.createdAt = "\(Int(Date.now.timeIntervalSince1970))"
                        coreDataManager.updateObject(object: user)
                        
                    } else {
                        throw NSError(domain: "Login Fauile", code: 500, userInfo: [NSLocalizedDescriptionKey : "Internal Error"])
                    }
                }
            } else {
                throw NSError(domain: "Login Fauile", code: 500, userInfo: [NSLocalizedDescriptionKey : "Internal Error"])
            }
        }
    }
}
