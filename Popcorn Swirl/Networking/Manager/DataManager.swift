//
//  DataManager.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 27/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {
    }
//
    lazy var filmList: [FilmModel] = {
        var list = [FilmModel]()


            let media = FilmModel(
                id: 1458414924,
                title: "Please wait",
                catagory: "while",
                yearOfRelease: "List Loads",
                artworkURL: "https://is4-ssl.mzstatic.com/image/thumb/Video3/v4/84/b3/18/84b31872-c3ab-fd22-e1a6-3873b1f32849/source/100x100bb.jpg")
            list.append(media)
        
        return list
    } ()
}
