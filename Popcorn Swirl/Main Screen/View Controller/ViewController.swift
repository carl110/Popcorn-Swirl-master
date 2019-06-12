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
    
    private var filmDataSource = DataManager.shared.filmList
    private let filmSearch = "2019"
    private let watchedURL = "https://img.icons8.com/office/50/000000/accuracy.png"
    private let favouritetURL = "https://img.icons8.com/color/50/000000/hearts.png"
    private let myTitle = "Film List"
    
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
        self.title = myTitle
    }
    
    //Delegate function
    func cellWasSelected(id: Int) {
        mainFlowController.showDetailedScreen(with: id)
    }
    
    func loadData(movieSearch: String) {
        //get list of films from term
        GetRequests.getFilmList(term: movieSearch) { (success, list) in
            if success, let list = list {
                DataManager.shared.filmList = list
                DispatchQueue.main.async { [weak self] in
                    self?.filmCollectionView.reloadData()
                }
            } else { 
                self.alert(message: "Could not load data as not found")
            }
        }
    }

    func loadDataFromID(filmID: [Int]) {
        //get list of films from specified ID Array
        GetRequests.getFilmListFromID(filmIDArray: filmID) { (success, list) in
            if success, let list = list {
                DataManager.shared.filmList = list
                DispatchQueue.main.async { [weak self] in
                    self?.filmCollectionView.reloadData()
                }
            } else {
                self.alert(message: "Could not load data as not found")
            }
        }
    }
    
    func selectButton(button: UIButton, buttonIamgeSelectedSate: String, otherButton: UIButton, otherButtonSelectedSate: String, buttonCase: String, otherButtonCase: String, pictureURL: String) {
        //Set Button image and title
        button.setImage(UIImage(named: buttonIamgeSelectedSate), for: .normal)
        button.setTitle("View All", for: .normal)
        
        //if other button already selected
        if(otherButton.currentImage?.isEqual(UIImage(named: otherButtonSelectedSate)))! {
            print ("selecte and other button selected")
            
            //combine IDs from favourites and watched and show only those that are both
            let joinedArray = Array(Set(createIDArray(object: buttonCase)).intersection(createIDArray(object: otherButtonCase)))
            //if no films both watched and favourite
            if joinedArray.isEmpty {
                DataManager.shared.filmList = [FilmModel(
                    id: 0,
                    title: "List Empty",
                    catagory: "There are currently no films in this list",
                    yearOfRelease: "",
                    artworkURL: pictureURL)]
                filmCollectionView.reloadData()
            } else {
                //Show filtered list
                loadDataFromID(filmID: Array(Set(createIDArray(object: buttonCase)).intersection((createIDArray(object: otherButtonCase)))))
            }
            self.title = "Watched and Favourites List"
        } else {
            filmArrayIsEmpty(object: buttonCase, idArray: createIDArray(object: buttonCase), pictureURL: pictureURL)
            
            self.title = "\(buttonCase) List"
        }
    }
    
    func unSelectButton(button: UIButton, buttonImageCurrentState: String, otherButton: UIButton, otherButtonSelectedSate: String, otherButtonCase: String, buttonTitleUnselected: String, pictureURL: String, buttonCase: String) {
        button.setImage(UIImage(named: buttonImageCurrentState), for: .normal)
        button.setTitle(buttonTitleUnselected, for: .normal)
        
        //if other button selected
        if(otherButton.currentImage?.isEqual(UIImage(named: otherButtonSelectedSate)))! {
            print ("unselect and other butoon selected")
            //show all other button items
            filmArrayIsEmpty(object: otherButtonCase, idArray: createIDArray(object: otherButtonCase), pictureURL: pictureURL)
            
            self.title = "\(otherButtonCase) List"
        } else {
            //show full list
            loadData(movieSearch: filmSearch)
            
            self.title = myTitle
        }
    }
    
    func filmArrayIsEmpty(object: String, idArray: [Int], pictureURL: String) {

        //if button array is empty
        if createIDArray(object: object).isEmpty {
            DataManager.shared.filmList = [FilmModel(
                id: 0,
                title: "List Empty",
                catagory: "There are currently no films in this list",
                yearOfRelease: "",
                artworkURL: pictureURL)]
            
            filmCollectionView.reloadData()
        } else {
            loadDataFromID(filmID: idArray)
        }
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        
        if (favouriteButton.currentImage?.isEqual(UIImage(named: Images.redHeart.name())))! {
            selectButton(button: favouriteButton,
                         buttonIamgeSelectedSate: Images.emptyHeart.name(),
                         otherButton: watchedButton,
                         otherButtonSelectedSate: Images.notWatched.name(),
                         buttonCase: ButtonCase.favourite.name(),
                         otherButtonCase: ButtonCase.watched.name(),
                         pictureURL: favouritetURL)
        } else {
            unSelectButton(button: favouriteButton,
                           buttonImageCurrentState: Images.redHeart.name(),
                           otherButton: watchedButton,
                           otherButtonSelectedSate: Images.notWatched.name(),
                           otherButtonCase: ButtonCase.watched.name(),
                           buttonTitleUnselected: "Favourites",
                           pictureURL: favouritetURL,
                           buttonCase: ButtonCase.favourite.name())
        }
    }
    
    @IBAction func watchedButton(_ sender: Any) {
        
        if (watchedButton.currentImage?.isEqual(UIImage(named: Images.watched.name())))! {
            selectButton(button: watchedButton,
                         buttonIamgeSelectedSate: Images.notWatched.name(),
                         otherButton: favouriteButton,
                         otherButtonSelectedSate: Images.emptyHeart.name(),
                         buttonCase: ButtonCase.watched.name(),
                         otherButtonCase: ButtonCase.favourite.name(),
                         pictureURL: watchedURL)
        } else {
            unSelectButton(button: watchedButton,
                           buttonImageCurrentState: Images.watched.name(),
                           otherButton: favouriteButton,
                           otherButtonSelectedSate: Images.emptyHeart.name(),
                           otherButtonCase: ButtonCase.favourite.name(),
                           buttonTitleUnselected: "Watched",
                           pictureURL: watchedURL,
                           buttonCase: ButtonCase.watched.name())
        }
    }
}
