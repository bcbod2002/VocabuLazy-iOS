//
//  WCWordPlayCollectionViewLayoutAttributes.swift
//  Swallow
//
//  Created by Goston on 2016/10/1.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCWordPlayCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // BackgroundColor of content view
    var backgroundColor = UIColor.wcGreenOneColor()
    
    // Shadow of cell
    var shadowPath: CGPath = UIBezierPath().cgPath
    var shadowColor: CGColor = UIColor.clear.cgColor
    var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    var shadowOpacity: Float = 0.0
    
    var isHighlight: HighlightStatus = .unHighlightCell
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Override UICollectionViewLayoutAttributes methods
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! WCWordPlayCollectionViewLayoutAttributes
        
        // BackgroundColor of content view
        copy.backgroundColor = self.backgroundColor
        
        // Shadow off cell
        copy.shadowPath = self.shadowPath
        copy.shadowColor = self.shadowColor
        copy.shadowOffset = self.shadowOffset
        copy.shadowOpacity = self.shadowOpacity
        
        copy.isHighlight = self.isHighlight
        
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? WCWordPlayCollectionViewLayoutAttributes {
            
            guard backgroundColor != rhs.backgroundColor else {
                return false
            }
            
            return super.isEqual(object)
        }
        else {
            return false
        }
    }
}
