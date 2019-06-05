//
//  CollectionView.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 24/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit


protocol FilmCellSelectedDelegate {
    func cellWasSelected(id: Int)
}

class FilmCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cellDelegate: FilmCellSelectedDelegate?

    func registerCell() {
        self.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.filmList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        //reversed to show the newest films first
        let filmModel = DataManager.shared.filmList.reversed()[indexPath.item]
        cell.populate(filmModel: filmModel)
        if let artWorkData = filmModel.artworkData,
            let artwork = UIImage(data: artWorkData) {
            cell.setImage(image: artwork)
        } else if let imageURL = URL(string: filmModel.artworkURL) {
            GetRequests.getImage(imageUrl: imageURL, completion: { (sucess, imageData) in
                if sucess, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.setImage(image: artwork)
                    }
                }
            })
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filmModel = DataManager.shared.filmList[indexPath.item]
        let id = filmModel.id
        print ("Cell selected")
        cellDelegate?.cellWasSelected(id: id)
        
    }
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        registerCell()

    }
    
    //set layout for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.size.width
        return CGSize(width: (w - 20), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
