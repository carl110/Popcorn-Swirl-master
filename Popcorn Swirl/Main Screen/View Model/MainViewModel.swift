//
//  File.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 27/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation

class MainViewModel {
    
    private struct API {
        private static let base = "https://itunes.apple.com/"
        private static let search = API.base + "search"
        private static let lookup = API.base + "lookup"
        
        static let searchURL = URL(string: API.search)!
        static let lookupURL = URL(string: API.lookup)!
    }
    
    private static func createRequest(url: URL, params: [String: Any]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = params.map{ "\($0)=\($1)" }
            .joined(separator: "&")
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    private static func createSearchRequest(term: String) -> URLRequest {
        let params = ["term": term, "entity": "movie"]
        return createRequest(url: API.searchURL, params: params)
    }
    private static func createLookupRequest(id: Int) -> URLRequest {
        let params = ["id": id]
        return createRequest(url: API.lookupURL, params: params)
    }
    
    
    static func getFilmList(term: String, completion: @escaping (Bool, [FilmModel]?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let request = createSearchRequest(term: term)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let results = responseJSON["results"] as? [AnyObject] {
                    
                    var list = [FilmModel]()
                    for i in 0 ..< results.count {
                        guard let film = results[i] as? [String: Any] else {
                            continue
                        }
                        
                        if let id = film["trackId"] as? Int,
                            let title = film["trackName"] as? String,
                            let catagory = film["primaryGenreName"] as? String,
                            let yearOfRelease = film["releaseDate"] as? String,
                            let artworkURL = film["artworkUrl100"] as? String {
                            let filmModel = FilmModel(id: id, title: title, catagory: catagory, yearOfRelease: yearOfRelease, artworkURL: artworkURL)
                            
                            list.append(filmModel)
                        }
                    }
                    
                    completion(true, list)
                }
                else {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    static func getImage(imageUrl: URL, completion: @escaping (Bool, Data?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data, error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true, data)
            }
            else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    static func getIndividualFilm(id: Int, complettion: @escaping (Bool, FilmModel?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createLookupRequest(id: id)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let results = responseJSON["results"] as? [AnyObject] {
                    
                    if results.count > 0,
                        let film = results[0] as? [String: Any],
                        let id = film["trackId"] as? Int,
                        let title = film["trackName"] as? String,
                        let catagory = film["primaryGenreName"] as? String,
                        let yearOfRelease = film["releaseDate"] as? String,
                        let artworkURL = film["artworkUrl100"] as? String {
                        
                        let filmData = IndividualFilmModel(id: id, title: title, catagory: catagory, yearOfRelease: yearOfRelease, artworkURL: artworkURL)
                        filmData.plot = film["shortDescription"] as? String
                        complettion(true, filmData)
                    } else {
                        complettion(false, nil)
                    }
                } else {
                    complettion(false, nil)
                }
            } else {
                complettion(false, nil)
            }
        }
        task.resume()
        
    }
}
