//
//  Validater.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import Foundation

extension String {
    
    var isValidFullName: ValidaterStruct {
        if (self.isEmptyStr) {
            return ValidaterStruct(status: false, message: "Full Name Should Not Empty")
        }
        
        return ValidaterStruct(status: true, message: "Success")
    }
    
    var isValidEmail: ValidaterStruct {
        if (self.isEmptyStr) {
            return ValidaterStruct(status: false, message: "Email Should Not Empty")
        }
        else if (self.matchRegEx(with: AppRegEx.emailRegEx) == false) {
            return ValidaterStruct(status: false, message: "Invalid Email Address")
        }
        
        return ValidaterStruct(status: true, message: "Success")
    }
    
    var isValidPassword: ValidaterStruct {
        if (self.isEmptyStr) {
            return ValidaterStruct(status: false, message: "Password Should Not Empty")
        }
        else if (self.count < 7) {
            return ValidaterStruct(status: false, message: "Password Must Be More Then 7 Digits.")
        }
        
        return ValidaterStruct(status: true, message: "Success")
    }
    
    func isValidConfirmPassword(old password: String)-> ValidaterStruct {
        if (self.isEmptyStr) {
            return ValidaterStruct(status: false, message: "Confirm Password Should Not Empty")
        }
        else if (self.count < 7) {
            return ValidaterStruct(status: false, message: "Confirm Password Must Be More Then 7 Digits.")
        }
        else if (self != password) {
            return ValidaterStruct(status: false, message: "Confirm Password Could Not Match With Password.")
        }
        
        return ValidaterStruct(status: true, message: "Success")
    }
    
    var isValidPostTitle: ValidaterStruct {
        if (self.isEmptyStr) {
            return ValidaterStruct(status: false, message: "Post Title Should Not Empty")
        }
        
        return ValidaterStruct(status: true, message: "Success")
    }
    
    var isValidCommentText: ValidaterStruct {
        if (self.isEmptyStr) {
            return ValidaterStruct(status: false, message: "Comment Should Not Empty")
        }
        
        return ValidaterStruct(status: true, message: "Success")
    }
    
}
