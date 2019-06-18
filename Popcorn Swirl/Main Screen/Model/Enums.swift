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


// list of custom images
public enum Images: String {
    case notWatched
    case watched
    case redHeart
    case emptyHeart
    case noFilmImage
    case hollywood
    case ebuzz
    case amazon

    var image: UIImage {
        switch self {
        case .amazon: return UIImage(named: "amazon")!
        case .ebuzz: return UIImage(named: "ebuz")!
        case .emptyHeart: return UIImage(named: "emptyHeart")!
        case .hollywood: return UIImage(named: "hollywood")!
        case .noFilmImage: return UIImage(named: "noFilmImage")!
        case .notWatched: return UIImage(named: "notWatched")!
        case .redHeart: return UIImage(named: "redHeart")!
        case .watched: return UIImage(named: "watched")!
        }
    }
}
