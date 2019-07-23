//
//  UIViewController+Extension.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    fileprivate static var window: UIWindow? {
        return UIApplication.shared.delegate?.window as? UIWindow
    }
    
    static func setRoot(_ controller: UIViewController) {
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    static func change(to controller: UIViewController, animation: Bool, animationType: UIView.AnimationOptions = .transitionCrossDissolve) {
        
        guard let window = UIViewController.window else {
            fatalError("GET WINDOW ERROR")
        }
        
        guard let rootVC = window.rootViewController else {
            UIViewController.setRoot(controller)
            return
        }
        
        if !animation {
            UIViewController.setRoot(controller)
            return
        }
        
        DispatchQueue.main.async {
            UIView.transition(from: rootVC.view, to: controller.view,
                              duration: 0.3,
                              options: animationType) { (finished) in
                                UIViewController.setRoot(controller)
            }
        }
    }
}

extension UIViewController {
    
    func dismiss(animated: Bool = true) {
        DispatchQueue.main.async {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    func pushViewController(controller: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    func presentControllerAfter(delay: Double, controller: UIViewController, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
            self?.present(controller, animated: true, completion: nil)
        })
    }
    
    func presentWithNavBar(_ controller: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let navController = UINavigationController()
            navController.addChild(controller)
            self.present(navController, animated: animated, completion: completion)
        }
    }
}

extension UIViewController {
    
    //MARK: Get top ViewController
    static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = base as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let tabBarController = base as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presentedViewController = base?.presentedViewController {
            return topViewController(presentedViewController)
        }
        
        if base == nil {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
        return base
    }
}
