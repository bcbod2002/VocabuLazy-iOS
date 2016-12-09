//
//  WCLessonChooseCollectionViewFlowLayout.swift
//  Swallow
//
//  Created by Goston on 2015/9/22.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

class WCLessonChooseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not bee implemented")
    }
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = UICollectionViewScrollDirection.vertical
    }
    
    func setCollectionViewSize(_ collectionViewSize: CGSize) {
        self.itemSize = CGSize(width: collectionViewSize.width / 5, height: collectionViewSize.height / 7)
        self.sectionInset = UIEdgeInsets.zero
    }
    
    override func prepare() {
        super.prepare()
    }
}
