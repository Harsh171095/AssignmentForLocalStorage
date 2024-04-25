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
    private var viewmodel = RegisterViewModel()
    
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
        let userModel = RegisterRequestModel(
            fullName: txtFullName.text ?? "",
            email: txtEmail.text ?? "",
            password: txtPassword.text ?? "",
            confirmPassword: txtPassword.text ?? "")
        
        do {
            try viewmodel.isUserValid(userModel: userModel)
            try viewmodel.register()
            self.dismiss(animated: true)
        } catch(let error) {
            showAlert(title: (error as NSError).domain ,message: error.localizedDescription)
        }
    }
    
}
