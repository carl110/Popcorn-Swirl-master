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
        loadData()
        setUp()
    }
    
    func setUp() {
        favouriteButton.setImage(UIImage(named: "redHeart"), for: .normal)
        watchedButton.setImage(UIImage(named: "watched"), for: .normal)
    }
    
    //Delegate function
    func cellWasSelected(id: Int) {
        print ("This is the id \(id)")
        mainFlowController.showDetailedScreen(with: id)
    }
    
    func loadData() {
        GetRequests.getFilmList(term: "red") { (success, list) in
            
            if success, let list = list {
                DataManager.shared.filmList = list
              
                DispatchQueue.main.async {
                    self.filmCollectionView.reloadData()

                }
            } else {
                self.presentNoDataAlert(title: "Error 404", message: "Could not load data as not found")
            }
        }
    }
    
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
        
        let dismissAction = UIAlertAction(title: "Got It", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }

    @IBAction func favouriteButton(_ sender: Any) {
    }
    
    @IBAction func watchedButton(_ sender: Any) {
    }
}

