//
//  IndividualFilmModel.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 29/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class IndividualFilmModel: FilmModel {
    
    var plot: String?
    
    override init(id: Int, title: String, catagory: String, yearOfRelease: String, artworkURL: String) {
        super.init(id: id, title: title, catagory: catagory, yearOfRelease: yearOfRelease, artworkURL: artworkURL)
    }
    
}
