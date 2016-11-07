//
//  WCWordPlayScrollView.swift
//  Swallow
//
//  Created by Goston on 2015/11/9.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

//MARK: - WCWordPlayScrollViewDelegate
@objc protocol WCWordPlayScrollViewDelegate {
    
    /**
     WCWordPlayScrollView will display cell page number
     
     - parameter scrollView: WCWordPlayScrollView
     - parameter cell:       WCWordPlayScrollCollectionViewCell
     - parameter pageNumber: Will display page
     */
    @objc optional func scrollView(_ scrollView: WCWordPlayScrollView, willDisplayCell cell: WCWordPlayScrollCollectionViewCell, pageNumber: Int)
    
    /**
     WCWordPlayScrollView did end display cell page number
     
     - parameter scrollView: WCWordPlayScrollView
     - parameter cell:       WCWordPlayScrollCollectionViewCell
     - parameter pageNumber: Did end display page
     */
    @objc optional func scrollView(_ scrollView: WCWordPlayScrollView, didEndDisplayCell cell: WCWordPlayScrollCollectionViewCell, pageNumber: Int)
    
    /**
     WCWordPlayScrollView did end scroll decelerating to page
     
     - parameter scrollView: WCWordPlayScrollView
     - parameter pageNumber: End scroll decelerating to page
     */
    @objc optional func scrollView(_ scrollView: WCWordPlayScrollView, didEndScrollDeceleratingToPage pageNumber: Int)
    
    /**
     WCWordPlayScrollView begin scroll with finger
     
     - parameter scrollView: WCWordPlayScrollView
     */
    @objc optional func scrollViewBeginScrollWithFinger(_ scrollView: WCWordPlayScrollView)
}

class WCWordPlayScrollView: UICollectionView, UICollectionViewDelegate, UIScrollViewDelegate {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var scrollViewDelegate: WCWordPlayScrollViewDelegate?;
    var totalNumber = 0;
    
    fileprivate var scrollViewDataSource: WCWordPlayScrollViewDataSource?;
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout);
    }
    
    /**
     Initial with frame, UICollectionViewLayout, number of items
     
     - parameter frame:         CGRect
     - parameter layout:        UICollectionViewLayout
     - parameter numberOfItems: Int
     
     - returns: <#return value description#>
     */
    convenience init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, numberOfItems: Int) {
        self.init(frame: frame, collectionViewLayout: layout);
        
        let cellIdentifier = "WordPlayScrollCell";
        
        scrollViewDataSource = WCWordPlayScrollViewDataSource(numberOfItems: numberOfItems, cellIdentifier: cellIdentifier);
        self.dataSource = scrollViewDataSource;
        self.delegate = self;
        self.register(WCWordPlayScrollCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier);
        self.backgroundColor = UIColor.clear;
        self.isPagingEnabled = true;
        if #available(iOS 10.0, *) {
            self.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let scrollViewCollectionViewCell = (cell as! WCWordPlayScrollCollectionViewCell);
        scrollViewDelegate?.scrollView?(self, willDisplayCell: scrollViewCollectionViewCell, pageNumber: (indexPath as NSIndexPath).row);
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let scrollViewCollectionViewCell = cell as! WCWordPlayScrollCollectionViewCell;
        scrollViewDelegate?.scrollView?(self, didEndDisplayCell: scrollViewCollectionViewCell, pageNumber: (indexPath as NSIndexPath).row);
    }
    
    func scroll(toItem itemNumber: Int, animated: Bool) {
        if itemNumber < numberOfItems(inSection: 0)
        {
            let itemIndexPath = IndexPath(row: itemNumber, section: 0);
            scrollToItem(at: itemIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: animated);
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIScrollView Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewBeginScrollWithFinger?(self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //!!!: 向第0頁滑動時，會導致crash
        // UD2
        // http://qiita.com/kunichiko/items/8fa9494c659d75e3b9a9
        // 原因 : scrollView.contentOffset.x 有一定的機率會出現負數，這樣會導致 UInt(-3)便會溢位
        scrollViewDelegate?.scrollView?(self, didEndScrollDeceleratingToPage: Int(abs(scrollView.contentOffset.x) / scrollView.bounds.width));
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollView?(self, didEndScrollDeceleratingToPage: Int(abs(scrollView.contentOffset.x) / scrollView.bounds.width));
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
