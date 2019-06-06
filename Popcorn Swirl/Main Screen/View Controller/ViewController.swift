//
//  ViewController.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 22/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FilmCellSelectedDelegate {
    
    fileprivate var mainFlowController: MainFlowController!
    fileprivate var individualFilmModel: [IndividualFilmModel]?
    var filmDataSource = DataManager.shared.filmList
    
    let filmSearch = "2019"
    
    @IBOutlet weak var filmCollectionView: FilmCollectionView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var watchedButton: UIButton!
    
    
    func assignDependancies(mainFlowController: MainFlowController) {
        self.mainFlowController = mainFlowController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmCollectionView.cellDelegate = self
        loadData(movieSearch: filmSearch)
        setUp()
    }
    
    func setUp() {
        favouriteButton.setImage(UIImage(named: Images.redHeart.name()), for: .normal)
        watchedButton.setImage(UIImage(named: Images.watched.name()), for: .normal)
    }
    
    //Delegate function
    func cellWasSelected(id: Int) {
        mainFlowController.showDetailedScreen(with: id)
    }
    
    func loadData(movieSearch: String) {
        GetRequests.getFilmList(term: movieSearch) { (success, list) in
            
            if success, let list = list {
                DataManager.shared.filmList = list
                
                DispatchQueue.main.async {
                    self.filmCollectionView.reloadData()
                    
                }
            } else {
                self.alert(message: "Could not load data as not found")
            }
        }
    }
    
    func loadDataFromID(filmID: [Int]) {
        
        GetRequests.getFilmListFromID(filmIDArray: filmID) { (success, list) in
            if success, let list = list {
                DataManager.shared.filmList = list
                DispatchQueue.main.async {
                    self.filmCollectionView.reloadData()
                }
            } else {
                self.alert(message: "Could not load data as not found")
            }
        }
    }
    
    func createIDArray(object: String) -> [Int] {
        let buttonFilmIDs = CoreDataManager.shared.fetchIndividualButton(object: object)
        var buttonFilmIDArray: [Int] = []
        for details in buttonFilmIDs! {
            buttonFilmIDArray.append(Int(details.filmID))
        }
        return buttonFilmIDArray
    }
    
    
    @IBAction func favouriteButton(_ sender: Any) {
        
        if (favouriteButton.currentImage?.isEqual(UIImage(named: Images.redHeart.name())))! {
            
            favouriteButton.setImage(UIImage(named: Images.emptyHeart.name()), for: .normal)
            favouriteButton.setTitle("View All", for: .normal)

            //show only favourite films
            loadDataFromID(filmID: createIDArray(object: ButtonCase.favourite.name()))
        } else {
            favouriteButton.setImage(UIImage(named: Images.redHeart.name()), for: .normal)
            favouriteButton.setTitle("Favourites", for: .normal)
            //show full list
            loadData(movieSearch: filmSearch)
        }

        
    }
    
    @IBAction func watchedButton(_ sender: Any) {
        if (watchedButton.currentImage?.isEqual(UIImage(named: Images.watched.name())))! {
            
            watchedButton.setTitle("View All", for: .normal)
            watchedButton.setImage(UIImage(named: Images.notWatched.name()), for: .normal)
            
            //Create array of watched IDs
            let watchedFilmIDs = CoreDataManager.shared.fetchIndividualButton(object: ButtonCase.watched.name())
            var watchedFilmIDArray: [Int] = []
            for details in watchedFilmIDs! {
                watchedFilmIDArray.append(Int(details.filmID))
            }
            
            loadDataFromID(filmID: watchedFilmIDArray)
        } else {
            watchedButton.setTitle("Watched", for: .normal)
            watchedButton.setImage(UIImage(named: ButtonCase.watched.name()), for: .normal)
            loadData(movieSearch: filmSearch)
        }
    }
}

