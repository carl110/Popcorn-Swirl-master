//
//  MainModel.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 24/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation

class FilmModel {
    var id: Int
    var title: String
    var catagory: String
    var yearOfRelease: String
    var artworkURL: String
    
    var artworkData: Data?
    
    init(id: Int, title: String, catagory: String, yearOfRelease: String, artworkURL: String) {
        self.id = id
        self.title = title
        self.catagory = catagory
        self.yearOfRelease = yearOfRelease
        self.artworkURL = artworkURL
    }
}
