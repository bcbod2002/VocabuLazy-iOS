//
//  WCIntroduceCollectionViewFlowLayout
//  Swallow
//
//  Created by Goston on 2016/11/1.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCIntroduceCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not n=been implemented")
    }
    
    required override init() {
        super.init()
        self.minimumLineSpacing = 2
        self.minimumInteritemSpacing = 0
        self.scrollDirection = UICollectionViewScrollDirection.vertical
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Override functions
    override func prepare() {
        self.itemSize = CGSize(width: (collectionView?.bounds.width)! / 4 * 3, height: (collectionView?.bounds.width)!)
    }
}
