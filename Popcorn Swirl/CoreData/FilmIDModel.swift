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

class FilmIDModel {
    var filmID: Int32
    var favourite: Bool
    var watched: Bool
    
    init(object: NSManagedObject) {
        self.filmID = object.value(forKey: "filmID") as! Int32
        self.favourite = object.value(forKey: "favourite") as? Bool ?? false
        self.watched = object.value(forKey: "watched") as? Bool ?? false
    }
}
