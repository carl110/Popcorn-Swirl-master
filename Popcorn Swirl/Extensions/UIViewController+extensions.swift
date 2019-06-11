//
//  UIViewController+extensions.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 30/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //hide device keyboard when tapped outside of keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // open URL for amazon with film title
    func amazonSearch(filmTitle : String) {
        let filmName = filmTitle
        let formattedString = filmName.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "https://www.amazon.co.uk/s?k=\(formattedString)&i=dvd&crid=1OT46CWJ8DIJT&sprefix=red+%2Cdvd%2C140&ref=nb_sb_ss_i_4_4") else { return }
        UIApplication.shared.open(url)
    }
    
    // open URL for ebuzz with film title
    func ebaySearch(filmTitle : String) {
        let filmName = filmTitle
        let formattedString = filmName.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "https://ebuzz.ie/pages/search-results-page?q=\(formattedString)") else { return }
        UIApplication.shared.open(url)
    }
    
    // open URL for hollyWoodMemorabila with film title
    func hollywoodSearch(filmTitle : String) {
        let filmName = filmTitle
        let formattedString = filmName.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "https://www.hollywoodmemorabilia.com/search2.php?Ntt=\(formattedString)") else { return }
        UIApplication.shared.open(url)
    }
    
    //Create array to do multi lookup
    func createIDArray(object: String) -> [Int] {
        let buttonFilmIDs = CoreDataManager.shared.fetchIndividualButton(object: object)
        var buttonFilmIDArray: [Int] = []
        for details in buttonFilmIDs! {
            buttonFilmIDArray.append(Int(details.filmID))
        }
        return buttonFilmIDArray
    }
}

