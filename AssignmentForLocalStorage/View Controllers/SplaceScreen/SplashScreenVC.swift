//
//  SplashScreenVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

class SplashScreenVC: UIViewController {

    // Create UI Layout
    private lazy var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AuthUser.isSessionActive() {
            let tabBarController = TabBarVC()
            let navigationController = UINavigationController(rootViewController: tabBarController)
            navigationController.isNavigationBarHidden = true
            rootWindow?.rootViewController = navigationController
            rootWindow?.makeKeyAndVisible()
            
        }
        else {
            let rootViewController = LoginVC()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.isNavigationBarHidden = true
            rootWindow?.rootViewController = navigationController
            rootWindow?.makeKeyAndVisible()
        }
    }
}

