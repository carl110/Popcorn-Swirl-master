//
//  MyCollectionViewCell.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 24/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import UIKit
import CoreData


class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artWorkImage: UIImageView!
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var yearOfRelease: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var watchedButton: UIButton!
    
    var filmID: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(filmModel: FilmModel) {
        filmTitle.text = filmModel.title
        yearOfRelease.text = String (filmModel.yearOfRelease)
        genre.text = filmModel.catagory
        filmID = filmModel.id
    }
    
    func setImage(image: UIImage) {
        artWorkImage.image = image
    }
    
    @IBAction func watchedButton(_ sender: Any) {
        if watchedButton.image(for: .normal) == UIImage(named: "notWatched") {
           watchedButton.setImage(UIImage(named: "watched"), for: .normal)
            watchedButton.backgroundColor = UIColor.Shades.standardBlack
        } else {
            watchedButton.setImage(UIImage(named: "notWatched"), for: .normal)
            watchedButton.backgroundColor = UIColor.Shades.standardGrey
        }
    }
    @IBAction func favouriteButton(_ sender: Any) {
        if favouriteButton.image(for: .normal) == UIImage(named: "emptyHeart") {
            favouriteButton.setImage(UIImage(named: "redHeart"), for: .normal)
            favouriteButton.backgroundColor = UIColor.Shades.standardBlack
            //svae the filmID
            CoreDataManager.shared.saveFilmID(filmID: Int32(filmID))

        } else {
            favouriteButton.setImage(UIImage(named: "emptyHeart"), for: .normal)
            favouriteButton.backgroundColor = UIColor.Shades.standardGrey
        }
    }
    
    func addToFavouriteArray(filmModel: FilmModel) {
        print (filmModel.title)
    }
    
    override func prepareForReuse() {
        
        favouriteButton.isHidden = false

    }
}
