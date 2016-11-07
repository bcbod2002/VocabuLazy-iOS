//
//  WCWordPlayScrollCollectionViewCell.swift
//  Swallow
//
//  Created by Goston on 2015/11/10.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

class WCWordPlayScrollCollectionViewCell: UICollectionViewCell
{
    // Private variable
    
    
    // Public variable
    var indexPath : IndexPath!;
    var wordPlayTableView : WCWordPlayTableView!;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        wordPlayTableView = WCWordPlayTableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height));
        self.contentView.addSubview(wordPlayTableView!);
    }
    
    override func prepareForReuse()
    {
        wordPlayTableView.tableViewScrolltoItem(0, animated: false, callDelegate: false)
        wordPlayTableView.minifyAllCell();
    }
}
