//
//  WCIntroduceCollectionViewCell.swift
//  Swallow
//
//  Created by Goston on 2016/11/1.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCIntroduceCollectionViewCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variable
    var pictureImageView: UIImageView?
    var pictureLabel: UILabel?
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialPictureRelate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialPictureRelate()
    }
    
    func initialPictureRelate() {
        pictureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.width))
        
        pictureLabel = UILabel(frame: CGRect(x: 0, y: (pictureImageView?.frame.maxY)!, width: (pictureImageView?.bounds.width)!, height: self.contentView.bounds.height - self.contentView.bounds.width))
        pictureLabel?.font = UIFont.systemFont(ofSize: 16)
        pictureLabel?.textAlignment = .center
        
        self.contentView.addSubview(pictureImageView!)
        self.contentView.addSubview(pictureLabel!)
    }
}
