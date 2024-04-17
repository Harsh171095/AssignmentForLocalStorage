//
//  LoginVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet private weak var txtEmail : UITextField!
    @IBOutlet private weak var txtPassword : UITextField!
    @IBOutlet private weak var btnRemember : UIButton!
    @IBOutlet private weak var lblRemember : UILabel!
    @IBOutlet private weak var btnFotgotPassword : UIButton!
    @IBOutlet private weak var btnLogin : UIButton!
    @IBOutlet private weak var btnRegister : UIButton!
    
    private var coreDataManager: CoreDataManager  {
        return CoreDataManager.insatnce
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRemember.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }

    
    // Actions
    @IBAction private func clickOn_remember() {
        if (btnRemember.isSelected) {
            btnRemember.isSelected = true
            btnRemember.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            btnRemember.isSelected = false
            btnRemember.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    @IBAction private func clickOn_fotgotPassword() {
        let vc = ForgotPasswordVC()
        vc.modalPresentationStyle = .pageSheet
            // Keep animated value as false
            // Custom Modal presentation animation will be handled in VC itself
        self.present(vc, animated: true)
    }
    
    @IBAction private func clickOn_login() {
       let emailValid =  txtEmail.text?.isValidEmail
        let passwordValid =  txtPassword.text?.isValidPassword
        
        if ((emailValid?.status ?? false) == false) {
            showAlert(title: "Validation" ,message: emailValid?.message ?? "")
        }
        else if ((passwordValid?.status ?? false) == false) {
            showAlert(title: "Validation" ,message: emailValid?.message ?? "")
        }
        else {
            login()
        }
    }
    
    @IBAction private func clickOn_register() {
        let vc = RegisterVC()
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    
    // DB Methods
    private func login() {
        
        let predicate1 = NSPredicate(format: "email == %@", txtEmail.text ?? "")
        if let useData: [Users] = coreDataManager.fetchObjects(predicates: [predicate1], sortDescriptors: nil) {
            if (useData.isEmpty) {
                showAlert(message: "You Are Not Register. Please Register First.")
            } else if ((useData.first?.password ?? "") != (txtPassword.text ?? "")) {
                showAlert(message: "Invalid Password. Please Enter valid Password.")
            } else {
                AuthUser.updateUserSession(useData.first!)
                
                let tabBarController = TabBarVC()
                let navigationController = UINavigationController(rootViewController: tabBarController)
                navigationController.isNavigationBarHidden = true
                rootWindow?.rootViewController = navigationController
                rootWindow?.makeKeyAndVisible()
            }
        } else {
            showAlert(message: "You Are Not Register. Please Register First.")
        }
    }
}

