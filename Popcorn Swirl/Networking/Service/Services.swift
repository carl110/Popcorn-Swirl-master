//
//  API.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 30/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation

class Services {
    
     struct API {
        private static let base = "https://itunes.apple.com/"
        private static let search = API.base + "search"
        private static let lookup = API.base + "lookup"
        
        static let searchURL = URL(string: API.search)!
        static let lookupURL = URL(string: API.lookup)!
    }
    
}


