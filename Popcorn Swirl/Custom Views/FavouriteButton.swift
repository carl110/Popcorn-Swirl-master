//
//  FavouriteButton.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 29/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit


class FavouriteButton: UIButton {
    
    let emptyHeart = UIImage(named: "emptyHeart")! as UIImage
    let redHeart = UIImage(named: "redHeart")! as UIImage
    
    var isChecked: Bool = false
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(heartClicked(sender: )), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func heartClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
    
}
