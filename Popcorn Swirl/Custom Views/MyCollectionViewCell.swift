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
    
//    var filmModel: FilmModel!
    var id: Int32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if watchedButton.isWatched == true {
            self.isHidden = true
        }
    }
    
    func populate(filmModel: FilmModel) {
        filmTitle.text = filmModel.title
        filmTitle.text = filmModel.title
        yearOfRelease.text = String (filmModel.yearOfRelease.prefix(4))
        genre.text = filmModel.catagory
        id =  Int32(filmModel.id)
        setButtonSate()
        setImageForFilmPoster(filmModel: filmModel)
    }
    
    func setButtonSate() {
        
        //Load list of films in coredata
        let filmList = CoreDataManager.shared.fetchFilmIDs()
        //if favourite or watched are true in core data update cell buttons
        for film in filmList! {
            if self.id == film.filmID {
                if film.favourite == true {
                    self.favouriteButton.isFavourite = true
                }
                if film.watched == true {
                    self.watchedButton.isWatched = true
                }
            }
        }
    }
    
    func setImageForFilmPoster(filmModel: FilmModel) {
        //if artwork already present use that otherwise load URL image
        if let artWorkData = filmModel.artworkData,
            let artwork = UIImage(data: artWorkData) {
            self.setImage(image: artwork)
        } else if let imageURL = URL(string: filmModel.artworkURL) {
            GetRequests.getImage(imageUrl: imageURL, completion: { [weak self] (sucess, imageData) in
                if sucess, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    self?.setImage(image: artwork)
                    
                    //set image in model to save redownloading on next view
                    filmModel.artworkData = try? Data(contentsOf: URL(string: filmModel.artworkURL)!)
                }
            })
        }
    }
    
    func setImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.artWorkImage.image = image
        }
    }
    
    override func prepareForReuse() {
        artWorkImage.image = Images.noFilmImage.image
        favouriteButton.isFavourite = false
        watchedButton.isWatched = false
        
        //Disable buttons and detailed view when id is 0 as set by no favourite/watched list
        DispatchQueue.main.async { [weak self] in
            if self?.id == 0 {
                self?.favouriteButton.disableButton()
                self?.watchedButton.disableButton()
                self?.isUserInteractionEnabled = false
            } else {
                self?.favouriteButton.enableButton()
                self?.watchedButton.enableButton()
                self?.isUserInteractionEnabled = true
            }
        }
    }
    
    func buttonSelected(object: String, filmID: Int32!) {
        let favouriteIDList = CoreDataManager.shared.fetchIndividualID(filmID: filmID)
        
        //filmID stored
        if favouriteIDList!.count > 0 {
            
            //updated just the button marker
            CoreDataManager.shared.updateButtonBool(object: object, updatedEntry: true, filmID: filmID)
        } else {
            
            //if not add filmID Object to popcorn swirl entity
            CoreDataManager.shared.saveFilmID(filmID: filmID, object: object)
        }
    }
    
    func favouriteButtonUnselected(filmID: Int32!) {
        let favouriteIDList = CoreDataManager.shared.fetchIndividualID(filmID: filmID)
        
        //if watched data is true
        for data in favouriteIDList! {
            if data.watched == true {
                
                //set favourite to false
                CoreDataManager.shared.updateButtonBool(object: ButtonCase.favourite.name(), updatedEntry: false, filmID: filmID)
            } else {
                CoreDataManager.shared.deleteFilmID(filmID: filmID)
            }
        }
    }
    
    func watchedButtonUnselected(filmID: Int32!) {
        let favouriteIDList = CoreDataManager.shared.fetchIndividualID(filmID: filmID)
        
        //if favourite data is true
        for data in favouriteIDList! {
            if data.favourite == true {
                
                //set watched to false
                CoreDataManager.shared.updateButtonBool(object: ButtonCase.watched.name(), updatedEntry: false, filmID: filmID)
            } else {
                CoreDataManager.shared.deleteFilmID(filmID: filmID)
            }
        }
    }
    
    func addCommentAlert() {
        //show alertbox to add comments for watched films
        findViewController()?.showWatchedCommentsAlert(comments: "Add comments here...",
                                                       actionHandler: { (commentInput:String?) in
                                                        
                                                        if commentInput!.isEmpty {
                                                            //Alert to confirm no comments
                                                            self.findViewController()?.alertBoxWithAction(
                                                                title: "Watched Film Comment",
                                                                message: "Are you sure you wish to proceed without saving a comment?",
                                                                options: "Add a comment", "Proceed without a comment") { (option) in
                                                                    switch(option) {
                                                                    case 0:
                                                                        self.addCommentAlert()
                                                                    default:
                                                                        break
                                                                    }
                                                            }
                                                        } else {
                                                            CoreDataManager.shared.updateWatchedComment(commentToAdd: commentInput!, filmID: self.id!)
                                                        }
                                                        
        })
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        if (favouriteButton.currentImage?.isEqual( Images.emptyHeart.image))! {
            
            //function for selecting button
            buttonSelected(object: ButtonCase.favourite.name(), filmID: id)
        } else {
            
            //function for unselecting button
            favouriteButtonUnselected(filmID: id)
        }
    }
    
    @IBAction func watchedButton(_ sender: Any) {
        if (watchedButton.currentImage?.isEqual(Images.notWatched.image))! {
            
            //function for selecting button
            buttonSelected(object: ButtonCase.watched.name(), filmID: id)
            addCommentAlert()
            
        } else {
            CoreDataManager.shared.removeWatchedComment(filmID: id!)
            //function for unselecting button
            watchedButtonUnselected(filmID: id)
        }
    }
}
