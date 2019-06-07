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
        //get list of films from term
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
        //get list of films from specified ID Array
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
    
    func selectButton(button: UIButton, buttonIamgeSelectedSate: String, otherButton: UIButton, otherButtonSelectedSate: String, ButtonCase: String, otherButtonCase: String) {
        //Set Button image and title
        button.setImage(UIImage(named: buttonIamgeSelectedSate), for: .normal)
        button.setTitle("View All", for: .normal)
        
        //if watched button already selected
        if(otherButton.currentImage?.isEqual(UIImage(named: otherButtonSelectedSate)))! {
            
            //combine IDs from favourites and watched and show only those that are both
            loadDataFromID(filmID: Array(Set(createIDArray(object: ButtonCase)).intersection((createIDArray(object: otherButtonCase)))))
        } else {
            //show only favourite films
            loadDataFromID(filmID: createIDArray(object: ButtonCase))
        }
    }
    
    func unSelectButton(button: UIButton, buttonImageCurrentState: String, otherButton: UIButton, otherButtonSelectedSate: String, otherButtonCase: String, buttonTitleUnselected: String) {
        button.setImage(UIImage(named: buttonImageCurrentState), for: .normal)
        button.setTitle(buttonTitleUnselected, for: .normal)
        
        //if watch button selected
        if(otherButton.currentImage?.isEqual(UIImage(named: otherButtonSelectedSate)))! {
            //show all watched items
            loadDataFromID(filmID: createIDArray(object: otherButtonCase))
        } else {
            //show full list
            loadData(movieSearch: filmSearch)
        }
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        
        if (favouriteButton.currentImage?.isEqual(UIImage(named: Images.redHeart.name())))! {
            print ("favourite")
            selectButton(button: favouriteButton,
                         buttonIamgeSelectedSate: Images.emptyHeart.name(),
                         otherButton: watchedButton,
                         otherButtonSelectedSate: Images.notWatched.name(),
                         ButtonCase: ButtonCase.favourite.name(),
                         otherButtonCase: ButtonCase.watched.name())
        } else {
            print ("not favourite")
            unSelectButton(button: favouriteButton,
                           buttonImageCurrentState: Images.redHeart.name(),
                           otherButton: watchedButton,
                           otherButtonSelectedSate: Images.notWatched.name(),
                           otherButtonCase: ButtonCase.watched.name(),
                           buttonTitleUnselected: "Favourites")
        }
    }
    
    @IBAction func watchedButton(_ sender: Any) {
        
        if (watchedButton.currentImage?.isEqual(UIImage(named: Images.watched.name())))! {
            print ("watched")
            selectButton(button: watchedButton,
                         buttonIamgeSelectedSate: Images.notWatched.name(),
                         otherButton: favouriteButton,
                         otherButtonSelectedSate: Images.emptyHeart.name(),
                         ButtonCase: ButtonCase.watched.name(),
                         otherButtonCase: ButtonCase.favourite.name())
        } else {
            print ("Not watched")
            unSelectButton(button: watchedButton,
                           buttonImageCurrentState: Images.watched.name(),
                           otherButton: favouriteButton,
                           otherButtonSelectedSate: Images.emptyHeart.name(),
                           otherButtonCase: ButtonCase.favourite.name(),
                           buttonTitleUnselected: "Watched")
        }
    }
}
