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
    
    func nearingScrollEnd(year: Int)
}

class FilmCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    

    

    
    
    private let VC = ViewController()
    //placeholder for number to remove from year for pagenation
    private var yearCount = 1
    var cellDelegate: FilmCellSelectedDelegate?
    
    func registerCell() {
        self.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.filmList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        let filmModel = DataManager.shared.filmList[indexPath.item]
        cell.populate(filmModel: filmModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filmModel = DataManager.shared.filmList[indexPath.item]
        let id = filmModel.id
        //send id to delegate for ViewController
        cellDelegate?.cellWasSelected(id: id)
    }
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
//        prefetchDataSource = self
        registerCell()
    }
    
    //set layout for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if device is iPad then have 2 cells per row - otherwise 1
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            let w = collectionView.frame.size.width
            return CGSize(width: (w / 2 - 5), height: 100)
        } else {
            let w = collectionView.frame.size.width
            return CGSize(width: (w - 20), height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //When scroll gets to 10 before the end
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == DataManager.shared.filmList.count - 25 {
            //pass number of years to remove to view controller
            cellDelegate?.nearingScrollEnd(year: yearCount)
            yearCount += 1
        }
    }
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("prefetching row of \(indexPaths)")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//         print("cancel prefetch row of \(indexPaths)")
//    }

}
