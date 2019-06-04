//
//  FavouriteButton.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 29/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

protocol FavouriteButtonDelegate {
    func favouriteButtonWasSelected(state: Bool)
}

extension FavouriteButtonDelegate {
    func favouriteButtonWasSelected(state: Bool) {}
}


class FavouriteButton: UIButton {
    
    let emptyHeart = UIImage(named: "emptyHeart")! as UIImage
    let redHeart = UIImage(named: "redHeart")! as UIImage
    
    var favouriteButtonDelegate: FavouriteButtonDelegate? = nil
    
    var isFavourite: Bool = false {
        didSet {
            favouriteButtonDelegate?.favouriteButtonWasSelected(state: isFavourite)
            if isFavourite == true {
                self.setImage(redHeart, for: .normal)
            } else {
                self.setImage(emptyHeart, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(heartClicked(sender: )), for: UIControl.Event.touchUpInside)
        self.isFavourite = false
    }
    
    @objc func heartClicked(sender: UIButton) {
        if sender == self {
            if isFavourite == true {
                isFavourite = false
            } else {
                isFavourite = true
            }
        }
    }
    
}
