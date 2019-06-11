//
//  detailedScreenViewController.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 23/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class DetailedScreenViewController: UIViewController {
    
    fileprivate var detailedScreenViewModel: DetailedScreenViewModel!
    fileprivate var detailedScreenFlowController: DetailedScreenFlowController!
    fileprivate var individualFilmModel: IndividualFilmModel?
    
    let loadingIcon = LoadingView(text: "Loading Film Data")
    
    private var filmID = Int()
    
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmPoster: UIImageView!
    @IBOutlet weak var filmYearOfRelease: UILabel!
    @IBOutlet weak var filmGenre: UILabel!
    @IBOutlet weak var filmPlot: UILabel!
    @IBOutlet weak var searchURLButton: UIButton!
    

    
    func assignDependancies(detailedScreenFlowController: DetailedScreenFlowController, detailedScreenViewModel: DetailedScreenViewModel){
        self.detailedScreenFlowController = detailedScreenFlowController
        self.detailedScreenViewModel = detailedScreenViewModel
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        

        
        setUp()
        loadIndividualFilmData()
        self.title = "Detailed View"
        
        // remove blur and loading ciews
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            for subview in self.view.subviews {
                if subview is UIVisualEffectView {
                    subview.removeFromSuperview()
                }
            }
        }
        
    }
    
    func setUp() {
        filmID = detailedScreenViewModel.filmID
        self.view.backgroundColor = UIColor.Shades.standardBlack
        searchURLButtonSetUp()
        //add blurview with loading spinner
        self.view.blurView(style: .regular)
        self.view.addSubview(loadingIcon)
    }
    
    func searchURLButtonSetUp() {
        searchURLButton.setTitle("Search Amazon", for: .normal)
        searchURLButton.tintColor = UIColor.Shades.standardBlack
        searchURLButton.backgroundColor = UIColor.Yellows.mustardYellow
        DispatchQueue.main.async { [weak self] in
            self?.searchURLButton.roundCorners(for: .allCorners, cornerRadius: 8)
        }
        
    }
    
    func loadIndividualFilmData() {
        
        GetRequests.getIndividualFilm(id: filmID) { (success, filmMedia) in
            if success, let filmMedia = filmMedia {
                self.individualFilmModel = filmMedia as? IndividualFilmModel
                DispatchQueue.main.async { [weak self] in
                    self?.populateFilmData()
                }
            } else {
                self.alert(message: "Unable to load film data")
            }
        }
    }
    
    func populateFilmData() {
        guard let filmMedia = self.individualFilmModel else {
            return
        }
        
        filmTitle.text = filmMedia.title
        filmYearOfRelease.text = String(filmMedia.yearOfRelease.prefix(10))
        filmGenre.text  = filmMedia.catagory
        filmPlot.text = filmMedia.plot
        
        if filmPlot.text == nil {
            print ("no data")
        }
        
        if let imageURL = URL(string: filmMedia.artworkURL) {
            GetRequests.getImage(imageUrl: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artWork = UIImage(data: imageData) {
                    DispatchQueue.main.async { [weak self] in
                        self?.filmPoster.image = artWork
                    }
                }
            })
        }
    }
    
    @IBAction func searchURLButton(_ sender: Any) {
        //Open amazon to search film
        amazonSearch(filmTitle: individualFilmModel!.title)
        
    }
}
