//
//  UIImageView+extension.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 19/06/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFilmImage(filmModel: FilmModel) {
        
        //check if image is present in model and load from there
        if let artWorkData = filmModel.artworkData,
            let artwork = UIImage(data: artWorkData) {
            self.image = artwork
            
            //if not fetch via URL
        } else if let imageURL = URL(string: filmModel.artworkURL) {
            //run in background
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageURL) {
                    if let artwork = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = artwork
                        }
                    }
                }
                
                //save artwork to maodel to save fetching each time cell is visable
                filmModel.artworkData = try? Data(contentsOf: URL(string: filmModel.artworkURL)!)
            }
            
        }
    }
}

