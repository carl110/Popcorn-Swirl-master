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
    
    private var filmID = Int()
    private var advertURL = ["amazon", "ebuzz", "hollywood"]
    private var advertPick: [String] = []
    
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmPoster: UIImageView!
    @IBOutlet weak var filmYearOfRelease: UILabel!
    @IBOutlet weak var filmGenre: UILabel!
    @IBOutlet weak var filmPlot: UILabel!
    @IBOutlet weak var searchURLButton: UIButton!
    @IBOutlet weak var searchButton2: UIButton!
    @IBOutlet weak var watchedFilmComments: UILabel!
    @IBOutlet weak var watchedImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    
    func assignDependancies(detailedScreenFlowController: DetailedScreenFlowController, detailedScreenViewModel: DetailedScreenViewModel){
        self.detailedScreenFlowController = detailedScreenFlowController
        self.detailedScreenViewModel = detailedScreenViewModel
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setUp()
        self.title = "Detailed View"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //when view appears remove overlay loading screen
            self.view.removeBlakcOverLay()
        }
    }
    
    func setUp() {
        
        //randomly pick 1 - number of adverts from array
        advertPick = advertURL.pick(Int.random(in: 1 ..< advertURL.count))
        filmID = detailedScreenViewModel.filmID
        self.view.backgroundColor = UIColor.Shades.standardBlack
        searchURLButtonSetUp()
        //add blurview with loading spinner
        self.view.blackOverlay(loadingIconText: "Loading Film Data")
        loadIndividualFilmData()
    }
    
    func searchURLButtonSetUp() {
        searchURLButton.setImage(UIImage(named: advertPick[0]), for: .normal)
        
        //if there are 2 adverts then show
        if advertPick.count > 1 {
            searchButton2.setImage(UIImage(named: advertPick[1]), for: .normal)
        }
        DispatchQueue.main.async { [weak self] in
            self?.searchURLButton.roundCorners(for: .allCorners, cornerRadius: 8)
            self?.searchButton2.roundCorners(for: .allCorners, cornerRadius: 8)
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
        
        //if no plot from API place holder text
        if filmPlot.text == nil {
            filmPlot.text = "No Plot held for this film..."
        }
        
        //Add comment if added for favourite films
        let watchedComment = CoreDataManager.shared.fetchIndividualID(filmID: Int32(filmID))
        for data in watchedComment! {
            if data.favourite == true {
                favouriteImage.image = Images.redHeart.image
            }
            //if film marked as watched and if therte are comments
            if data.watched == true {
                watchedImage.image = Images.watched.image
                if data.watchedComment.count > 0 {
                    watchedFilmComments.text = "My comments for this film...\n\(data.watchedComment)\n"
                } else {
                    watchedFilmComments.text = "I have no comments on this film...\n"
                }
            }
        }
        
        //Get image from URL
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
        let search = "\(advertPick[0])"
        
        //set URL redirect from array
        if search == "amazon" {
            amazonSearch(filmTitle: individualFilmModel!.title)
        } else if search == "ebuzz" {
            ebuzzSearch(filmTitle: individualFilmModel!.title)
        } else if search == "hollywood" {
            hollywoodSearch(filmTitle: individualFilmModel!.title)
        }
    }
    
    @IBAction func searchButton2(_ sender: Any) {
        let search = "\(advertPick[1])"
        
        //set URL redirect from array
        if search == "amazon" {
            amazonSearch(filmTitle: individualFilmModel!.title)
        } else if search == "ebuzz" {
            ebuzzSearch(filmTitle: individualFilmModel!.title)
        } else if search == "hollywood" {
            hollywoodSearch(filmTitle: individualFilmModel!.title)
        }
    }
}
