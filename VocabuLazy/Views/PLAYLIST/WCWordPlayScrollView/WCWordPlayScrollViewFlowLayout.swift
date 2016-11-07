//
//  WCWordPlayScrollViewFlowLayout.swift
//  Swallow
//
//  Created by Goston on 2015/11/9.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

class WCWordPlayScrollViewFlowLayout: UICollectionViewFlowLayout
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!;
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init()
    {
        super.init()
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirection.horizontal;
    }
    
    override func prepare()
    {
        super.prepare();
        self.itemSize = CGSize(width: (self.collectionView?.bounds.width)!, height: (self.collectionView?.bounds.height)!);
        self.sectionInset = UIEdgeInsets.zero;
    }

}
