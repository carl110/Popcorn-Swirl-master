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

    @IBOutlet weak var filmCollectionView: FilmCollectionView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var watchedButton: UIButton!
    
    
    func assignDependancies(mainFlowController: MainFlowController) {
        self.mainFlowController = mainFlowController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmCollectionView.cellDelegate = self
        loadData(movieSearch: "2019")
        setUp()
    }
    
    func setUp() {
        favouriteButton.setImage(UIImage(named: Images.redHeart.name()), for: .normal)
        watchedButton.setImage(UIImage(named: Images.redHeart.name()), for: .normal)
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

    @IBAction func favouriteButton(_ sender: Any) {
    }
    
    @IBAction func watchedButton(_ sender: Any) {
    }
}

