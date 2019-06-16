//
//  MainFactory.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 22/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class MainFactory {
    
    static func showIn(window: UIWindow) {
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.backgroundColor = UIColor.Shades.standardBlack
        navigationController.navigationBar.tintColor = UIColor.Shades.standardBlack
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.Shades.standardBlack]
        
        let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        
        let mainFlowController = MainFlowController(navigationController: navigationController)
        
        mainController.assignDependancies(mainFlowController: mainFlowController)
        
        navigationController.setViewControllers([mainController], animated: false)
        window.rootViewController = navigationController
        
    }
    
    static func PushIn(navigationController: UINavigationController) {
        
        let mainEditor = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        let mainFlowController = MainFlowController(navigationController: navigationController)
        mainEditor.assignDependancies(mainFlowController: mainFlowController)
        navigationController.pushViewController(mainEditor, animated: true)
        
    }
}
