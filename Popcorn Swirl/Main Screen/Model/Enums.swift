//
//  enums.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 06/06/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

public enum ButtonCase: String {
    case watched
    case favourite
    
    func name() -> String {
        return self.rawValue
    }
}

public enum Images: String {
    case notWatched
    case watched
    case redHeart
    case emptyHeart
    case noFilmImage
    case hollywood
    case ebay
    case amazon
    
    func name() -> String {
        return self.rawValue
    }
}
