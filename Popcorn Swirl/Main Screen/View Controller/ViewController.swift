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
    private var filmSearch = Date().year
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
        setUp()
        filmCollectionView.cellDelegate = self
        loadData(movieSearch: filmSearch)
    }
    
    func setUp() {
        favouriteButton.setImage(Images.redHeart.image, for: .normal)
        watchedButton.setImage(Images.watched.image, for: .normal)
        self.title = myTitle
    }
    
    //Delegate function
    func cellWasSelected(id: Int) {
        mainFlowController.showDetailedScreen(with: id)
    }
    
    func nearingScrollEnd(year: Int) {
        addDataToArray(movieSearch: String(Int(filmSearch)! - year))
    }
    
    //creates new array
    func loadData(movieSearch: String) {
        
        //get list of films from term
        GetRequests.getFilmList(term: movieSearch) { [weak self] (success, list) in
            if success, let list = list {
                DataManager.shared.filmList = list
     self?.reloadCollectionView()
            } else { 
                self?.alert(message: "Could not load data as not found")
            }
        }
    }
    
    //appends to existing array
    func addDataToArray(movieSearch: String) {
        //get list of films from term
        GetRequests.getFilmList(term: movieSearch) { [weak self] (success, list) in
            if success, let list = list {
                DataManager.shared.filmList += list
                self?.reloadCollectionView()
                
            } else {
                self?.alert(message: "Could not load data as not found")
            }
        }
    }
    
    func loadDataFromID(filmID: [Int]) {
        //get list of films from specified ID Array
        GetRequests.getFilmListFromID(filmIDArray: filmID) { [weak self] (success, list) in
            if success, let list = list {
                DataManager.shared.filmList = list
                self?.reloadCollectionView()
            } else {
                self?.alert(message: "Could not load data as not found")
            }
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.filmCollectionView.reloadData()
        }
    }
    
    func selectButton(button: UIButton, buttonImageSelectedSate: UIImage, otherButton: UIButton, otherButtonSelectedSate: UIImage, buttonCase: String, otherButtonCase: String, pictureURL: String, buttonTitle: String) {
        
        //Set Button image and title
        button.setImage(buttonImageSelectedSate, for: .normal)
        button.setTitle("Exit \(buttonTitle) list", for: .normal)
        
        //if other button already selected
        if(otherButton.currentImage?.isEqual(otherButtonSelectedSate))! {
            
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
            
            //if other button not selected
            filmArrayIsEmpty(object: buttonCase, idArray: createIDArray(object: buttonCase), pictureURL: pictureURL)
            self.title = "\(buttonTitle) List"
        }
    }
    
    func unSelectButton(button: UIButton, buttonImageCurrentState: UIImage, otherButton: UIButton, otherButtonSelectedSate: UIImage, otherButtonCase: String, buttonTitle: String,otherButtonTitle: String, pictureURL: String, buttonCase: String) {
        button.setImage(buttonImageCurrentState, for: .normal)
        button.setTitle(buttonTitle, for: .normal)
        
        //if other button selected
        if(otherButton.currentImage?.isEqual(otherButtonSelectedSate))! {
            print ("unselect and other butoon selected")
            //show all other button items
            filmArrayIsEmpty(object: otherButtonCase, idArray: createIDArray(object: otherButtonCase), pictureURL: pictureURL)
            
            self.title = "\(otherButtonTitle) List"
        } else {
            
            //if other button not selected - show full list
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

        if (favouriteButton.currentImage?.isEqual( Images.redHeart.image))! {
            selectButton(button: favouriteButton,
                         buttonImageSelectedSate: Images.emptyHeart.image,
                         otherButton: watchedButton,
                         otherButtonSelectedSate: Images.notWatched.image,
                         buttonCase: ButtonCase.favourite.name(),
                         otherButtonCase: ButtonCase.watched.name(),
                         pictureURL: favouritetURL,
                         buttonTitle: "Favourites")
        } else {
            unSelectButton(button: favouriteButton,
                           buttonImageCurrentState: Images.redHeart.image,
                           otherButton: watchedButton,
                           otherButtonSelectedSate: Images.notWatched.image,
                           otherButtonCase: ButtonCase.watched.name(),
                           buttonTitle: "Favourites",
                           otherButtonTitle: "Watched",
                           pictureURL: watchedURL,
                           buttonCase: ButtonCase.favourite.name())
        }
    }
    
    @IBAction func watchedButton(_ sender: Any) {
        
        if (watchedButton.currentImage?.isEqual( Images.watched.image))! {
            selectButton(button: watchedButton,
                         buttonImageSelectedSate: Images.notWatched.image,
                         otherButton: favouriteButton,
                         otherButtonSelectedSate: Images.emptyHeart.image,
                         buttonCase: ButtonCase.watched.name(),
                         otherButtonCase: ButtonCase.favourite.name(),
                         pictureURL: watchedURL,
                         buttonTitle: "Watched")
        } else {
            unSelectButton(button: watchedButton,
                           buttonImageCurrentState: Images.watched.image,
                           otherButton: favouriteButton,
                           otherButtonSelectedSate: Images.emptyHeart.image,
                           otherButtonCase: ButtonCase.favourite.name(),
                           buttonTitle: "Watched",
                           otherButtonTitle: "Favourites",
                           pictureURL: favouritetURL,
                           buttonCase: ButtonCase.watched.name())
        }
    }
}
