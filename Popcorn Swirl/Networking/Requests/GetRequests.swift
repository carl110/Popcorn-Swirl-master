//
//  GetRequests.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 30/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
class GetRequests {
    
    static func getFilmList(term: String, completion: @escaping (Bool, [FilmModel]?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let request = RequestBuilder.createSearchRequest(term: term)
        
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
    
    static func getFilmListFromID(filmIDArray: [Int], completion: @escaping (Bool, [FilmModel]?) -> Void) {
        
        let session = URLSession(configuration: .default)
        var list = [FilmModel]()
        
        for filmID in filmIDArray {
        let request = RequestBuilder.createLookupRequest(id: filmID)
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
                            let filmModel = FilmModel(id: id, title: title, catagory: catagory, yearOfRelease: yearOfRelease, artworkURL: artworkURL)
                            
                            list.append(filmModel)
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
        }}
    
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
        let request = RequestBuilder.createLookupRequest(id: id)
        
        
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
                        let artworkURL = film["artworkUrl100"] as? String{
                        
                        let filmData = IndividualFilmModel(id: id, title: title, catagory: catagory, yearOfRelease: yearOfRelease, artworkURL: artworkURL)
                        filmData.plot = film["longDescription"] as? String
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
