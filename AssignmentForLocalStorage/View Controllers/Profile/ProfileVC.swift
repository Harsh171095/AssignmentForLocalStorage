//
//  ProfileVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

class ProfileVC: UIViewController {

        // UI Outlets
    @IBOutlet private weak var txtFullName : UITextField!
    @IBOutlet private weak var txtEmail : UITextField!
    @IBOutlet private weak var txtPassword : UITextField!
    @IBOutlet private weak var txtConfirmPassword : UITextField!
    
        // Variables
    private var coreDataManager: CoreDataManager  {
        return CoreDataManager.insatnce
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
        // Actions
    @IBAction private func clickOn_register() {
        let fullNameValid =  txtFullName.text?.isValidFullName
        let emailValid =  txtEmail.text?.isValidEmail
        let passwordValid =  txtPassword.text?.isValidPassword
        let confirmPasswordValid =  txtPassword.text?.isValidConfirmPassword(old: txtPassword.text ?? "")
        
        if ((fullNameValid?.status ?? false) == false)
        {
            showAlert(title: "Validation" ,message: fullNameValid?.message ?? "")
        }
        else if ((emailValid?.status ?? false) == false)
        {
            showAlert(title: "Validation" ,message: emailValid?.message ?? "")
        }
        else if ((passwordValid?.status ?? false) == false)
        {
            showAlert(title: "Validation" ,message: passwordValid?.message ?? "")
        }
        else if ((confirmPasswordValid?.status ?? false) == false)
        {
            showAlert(title: "Validation" ,message: confirmPasswordValid?.message ?? "")
        }
        else
        {
            updateProfile()
        }
    }
    
    @IBAction private func clickOn_logout() {
        showAlert(message: "Are You Sure You Want To Logout?", buttons: ["Yes, I Want", "No, I Don't"]) { title in
            if (title == "Yes, I Want") {
                AuthUser.clearSession()
                let rootViewController = LoginVC()
                let navigationController = UINavigationController(rootViewController: rootViewController)
                navigationController.isNavigationBarHidden = true
                rootWindow?.rootViewController = navigationController
                rootWindow?.makeKeyAndVisible()
            }
        }
    }
    
        // DB Methods
    private func updateProfile() {
        
        let predicate1 = NSPredicate(format: "email == %@", txtEmail.text ?? "")
        if let useData: [Users] = coreDataManager.fetchObjects(predicates: [predicate1], sortDescriptors: nil) {
            if (useData.isEmpty == false) {
                showAlert(message: "You Are Already Register. Please Login.")
            } else {
                if let user: Users = AuthUser.user {
                    user.name = txtFullName.text ?? ""
                    user.email = txtEmail.text ?? ""
                    user.password = txtPassword.text ?? ""
                    user.createdAt = "\(Int(Date.now.timeIntervalSince1970))"
                    coreDataManager.updateObject(object: user)
                    self.dismiss(animated: true)
                    showAlert(message: "Profile Updated Successfully.")
                }
            }
        } else {
            showAlert(message: "Internal Error.")
        }
    }
}
