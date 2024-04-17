//
//  TabBarVC.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

class TabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Create view controllers for tabs
        let firstViewController = DashboardVC()
        let secondViewController = CreatePostVC()
        let thiredViewController = ProfileVC()
        firstViewController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), selectedImage: UIImage(named: "dashboard")?.withRenderingMode(.alwaysTemplate))
        secondViewController.tabBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.circle"), selectedImage: UIImage(systemName: "plus.circle"))
        thiredViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "user"), selectedImage: UIImage(named: "user")?.withRenderingMode(.alwaysTemplate))
        
        
        self.tabBar.backgroundColor = UIColor(named: "postBG")
            // Set view controllers for the tab bar controller
        self.viewControllers = [firstViewController, secondViewController, thiredViewController]
        
            // Optionally, customize the appearance of the tab bar controller
        self.tabBar.tintColor = UIColor.systemBlue
        self.selectedIndex = 0 // Set the default selected tab index
    }
}
