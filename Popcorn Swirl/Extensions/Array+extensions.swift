//
//  Array+extensions.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 11/06/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func pick(_ n: Int) -> [Element] {
        guard count >= n else {
            fatalError("The count has to be at least \(n)")
        }
        guard n >= 0 else {
            fatalError("The number of elements to be picked must be positive")
        }
        
        let shuffledIndices = indices.shuffled().prefix(upTo: n)
        return shuffledIndices.map {self[$0]}
    }
}
