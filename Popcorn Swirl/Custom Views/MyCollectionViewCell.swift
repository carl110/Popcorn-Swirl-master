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
    @IBOutlet weak var favouriteButton: FavouriteButton!
    @IBOutlet weak var watchedButton: WatchedButton!
    
    var filmModel: FilmModel!
    var id: Int32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(filmModel: FilmModel) {
        filmTitle.text = filmModel.title
        filmTitle.text = filmModel.title
        yearOfRelease.text = String (filmModel.yearOfRelease.prefix(4))
        genre.text = filmModel.catagory
        id =  Int32(filmModel.id)
    }
    
    func setImage(image: UIImage) {
        artWorkImage.image = image
    }
    
    
    override func prepareForReuse() {
    }
    @IBAction func favouriteButton(_ sender: Any) {
        //when selected and unselected - add/remove from core data
        if (favouriteButton.currentImage?.isEqual(UIImage(named: "emptyHeart")))! {
            
            let favouriteCount = CoreDataManager.shared.fetchIndividualID(savedID: id!)
            if favouriteCount!.count > 0 {
                
            } else {
                CoreDataManager.shared.saveFilmID(filmID: id!)
            }
        } else {
            CoreDataManager.shared.deleteFilmID(filmID: id!)
        }
    }
    @IBAction func watchedButton(_ sender: Any) {
        if (watchedButton.currentImage?.isEqual(UIImage(named: "notWatched")))! {
            CoreDataManager.shared.saveFilmID(filmID: id!)
        } else {
            CoreDataManager.shared.deleteFilmID(filmID: id!)
        }
    }
}
