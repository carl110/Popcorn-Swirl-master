//
//  MainFlowController.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 22/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class MainFlowController {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetailedScreen(with filmID: Int) {
        DetailedScreenFactory.PushIn(navigationController: navigationController, filmID: filmID)
        
    }
    
}
