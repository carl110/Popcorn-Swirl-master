//
//  FavouriteButton.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 29/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class FavouriteButton: UIButton {
    
    let emptyHeart = UIImage(named: Images.emptyHeart.name())! as UIImage
    let redHeart = UIImage(named: Images.redHeart.name())! as UIImage
    
    var isFavourite: Bool = false {
        didSet {
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
                
//                CoreDataManager.shared.saveFilmID(filmID: <#T##Int32#>)
            } else {
                isFavourite = true
            }
        }
    }
    
}
