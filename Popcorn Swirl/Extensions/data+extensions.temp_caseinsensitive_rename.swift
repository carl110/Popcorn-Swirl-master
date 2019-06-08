//
//  data+extensions.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 23/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
    func prettyJSON() -> String {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            
            do {
                let json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                return json.jsonDataToString()
            } catch let error as NSError {
                print (error)
            }
        } catch let error as NSError {
            print (error)
        }
        return jsonDataToString()
    }
    
    func jsonDataToString() -> String {
    return String(data: self, encoding: String.Encoding.utf8) ?? ""
    }
}
