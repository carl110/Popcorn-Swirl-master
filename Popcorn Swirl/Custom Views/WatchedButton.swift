//
//  WatchedButton.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 04/06/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class WatchedButton: UIButton {
    
    let notWatched = UIImage(named: Images.notWatched.name())! as UIImage
    let watched = UIImage(named: Images.watched.name())! as UIImage
    
    var isWatched: Bool = false {
        didSet {
            if isWatched == true {
                self.setImage(watched, for: .normal)
            } else {
                self.setImage(notWatched, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(targetClicked(sender: )), for: UIControl.Event.touchUpInside)
        self.isWatched = false
    }
    
    //when button clicked change image
    @objc func targetClicked(sender: UIButton) {
        if sender == self {
            if isWatched == true {
                isWatched = false
            } else {
                isWatched = true
            }
        }
    }
}
