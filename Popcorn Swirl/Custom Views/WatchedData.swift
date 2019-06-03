//
//  WatchedData.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 31/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class WatchedData {
    
    var state: Bool
    var title: String
    
    init(state: Bool, title: String) {
        self.state = state
        self.title = title
    }
}
