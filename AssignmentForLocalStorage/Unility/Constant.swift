//
//  Constant.swift
//  AssignmentForLocalStorage
//
//  Created by admin on 16/04/24.
//

import UIKit

func showAlert(title: String = "App Title", message: String, buttons: [String] = ["Okay"], handler: ((String)->())? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    for i in 0..<buttons.count {
        alert.addAction(UIAlertAction(title: buttons[i], style: .default, handler: { action in
            handler?(action.title ?? buttons[i])
        }))
    }
    
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)

}

extension UIApplication {
    
    static func topViewController(_ baseController: UIViewController? = nil) -> UIViewController? {
        let base: UIViewController? = baseController ?? UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }?.rootViewController
        
        if let nav = base as? UINavigationController {
            return topViewController( nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}
