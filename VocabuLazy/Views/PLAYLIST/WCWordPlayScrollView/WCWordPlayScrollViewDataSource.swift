//
//  WCWordPlayScrollViewDataSource.swift
//  Swallow
//
//  Created by Goston on 2016/5/12.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCWordPlayScrollViewDataSource: NSObject , UICollectionViewDataSource {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var itemOfNumber = 0
    var cellOfIdentifier = ""
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init(numberOfItems itemNumber: Int, cellIdentifier: String) {
        super.init()
        itemOfNumber = itemNumber
        cellOfIdentifier = cellIdentifier
    }

    
    // ---------------------------------------------------------------------------------------------
    // Mark: - WCWordPlayScrollView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemOfNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellOfIdentifier, for: indexPath) as! WCWordPlayScrollCollectionViewCell
        
        return cell
    }
}
