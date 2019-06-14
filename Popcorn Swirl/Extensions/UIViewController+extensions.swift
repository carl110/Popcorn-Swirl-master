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
    
    //custom aler message
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
    func ebuzzSearch(filmTitle : String) {
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
    
    func showWatchedCommentsAlert(title: String? = "Watched Item",
                            subtitle: String? = "Add your comments frothis film in the box below.",
                            actionTitle: String? = "Save Comment",
                            comments: String? = nil,
                            actionHandler: ((_ comment: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addTextField { (comment:UITextField) in
            comment.placeholder = comments
        }
        
        let actionButton = UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let commentField =  alert.textFields?[0] else {
                actionHandler?(nil)
                return
            }
         
            actionHandler?(commentField.text)
        })
        alert.addAction(actionButton)
        self.present(alert, animated: true, completion: nil)
    }
    //alert box with switch to show options per button set up
    func alertBoxWithAction(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    

}

