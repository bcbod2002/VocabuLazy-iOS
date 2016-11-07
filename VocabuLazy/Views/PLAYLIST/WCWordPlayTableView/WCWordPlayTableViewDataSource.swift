//
//  WCWordPlayTableViewDataSource.swift
//  Swallow
//
//  Created by Goston on 2016/5/14.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCWordPlayTableViewDataSource: NSObject, UICollectionViewDataSource {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var itemOfNumber = 0
    var cellOfIdentifier = ""
    
    
    required init(numberOfItems itemNumber: Int, cellIdentifier: String) {
        super.init()
        itemOfNumber = itemNumber
        cellOfIdentifier = cellIdentifier
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemOfNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellOfIdentifier, for: indexPath) as! WCWordPlayCollectionViewCell
        
        return cell
    }
}
