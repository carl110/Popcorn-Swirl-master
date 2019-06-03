//
//  RequestBuilder.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 30/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    let services = Services()

    
    static func createRequest(url: URL, params: [String: Any]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = params.map{ "\($0)=\($1)" }
            .joined(separator: "&")
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
   static func createSearchRequest(term: String) -> URLRequest {
        let params = ["term": term, "entity": "movie"]
        return createRequest(url: Services.API.searchURL, params: params)
    }
    static func createLookupRequest(id: Int) -> URLRequest {
        let params = ["id": id]
        return createRequest(url: Services.API.lookupURL, params: params)
    }
}
