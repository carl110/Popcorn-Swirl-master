//
//  detailedScreenFactory.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 23/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class DetailedScreenFactory {
    
    static func PushIn(navigationController: UINavigationController, filmID: Int) {
        
        let detailedScreen = UIStoryboard(name: "DetailedScreen", bundle: nil).instantiateInitialViewController() as! DetailedScreenViewController
        let detailedScreenFlowController = DetailedScreenFlowController(navigationController: navigationController)
        let detailedScreenViewModel = DetailedScreenViewModel(filmID: filmID)
        
        detailedScreen.assignDependancies(detailedScreenFlowController: detailedScreenFlowController, detailedScreenViewModel: detailedScreenViewModel)
        
        navigationController.pushViewController(detailedScreen, animated: true)
        
    }
    
}
