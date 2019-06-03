//
//  DataForFilms.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 31/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavouriteFilmModel {
    var filmID: Int
    
    init(object: NSManagedObject) {
        self.filmID = object.value(forKey: "filmID") as! Int
    }
}
