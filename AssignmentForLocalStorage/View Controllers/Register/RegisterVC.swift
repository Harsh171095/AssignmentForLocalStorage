//
//  RegisterVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

class RegisterVC: UIViewController {

    // UI Outlets
    
    @IBOutlet private weak var containerView : UIView!
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

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            // Do any additional setup after loading the view.
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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
            register()
        }
    }
    
    
        // DB Methods
    private func register() {
        
        let predicate1 = NSPredicate(format: "email == %@", txtEmail.text ?? "")
        if let useData: [Users] = coreDataManager.fetchObjects(predicates: [predicate1], sortDescriptors: nil) {
            if (useData.isEmpty == false) {
                showAlert(message: "You Are Already Register. Please Login.")
            } else {
                if let user: Users = coreDataManager.createObject() {
                    user.id = UUID().uuidString
                    user.name = txtFullName.text ?? ""
                    user.email = txtEmail.text ?? ""
                    user.password = txtPassword.text ?? ""
                    user.createdAt = "\(Int(Date.now.timeIntervalSince1970))"
                    coreDataManager.updateObject(object: user)
                    self.dismiss(animated: true)
                    showAlert(message: "You Are Register Successfully.")
                } else {
                    showAlert(message: "Internal Error.")
                }
            }
        } else {
            showAlert(message: "Internal Error.")
        }
    }
}
