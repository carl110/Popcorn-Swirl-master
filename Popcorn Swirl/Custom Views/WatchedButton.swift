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
    
    let notWatched = UIImage(named: "notWatched")! as UIImage
    let watched = UIImage(named: "watched")! as UIImage
    
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
    
    @objc func targetClicked(sender: UIButton) {
        if sender == self {
            if isWatched == true {
                isWatched = false
                print ("Cell is not watched")
            } else {
                isWatched = true
                print ("Cell is now watched")
            }
        }
    }
    
}
