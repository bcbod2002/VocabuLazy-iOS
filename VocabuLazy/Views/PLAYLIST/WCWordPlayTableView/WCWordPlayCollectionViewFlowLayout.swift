//
//  WCWordPlayCollectionViewFlowLayout.swift
//  Swallow
//
//  Created by Goston on 2015/8/24.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

class WCWordPlayCollectionViewFlowLayout: UICollectionViewFlowLayout {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // Define
    let UI_Design_Item_Height_Ratio: CGFloat = 245.0 / 1920.0
    let UI_Design_Item_Width_Ratio: CGFloat = 904.0 / 1080.0
    let Highlight_Color = UIColor(red: (254.0 / 255.0), green: (206.0 / 255.0), blue: (85.0 / 255.0), alpha: 1.0)
    let UnHighlight_Color = UIColor(red: (165.0 / 255.0), green: (228.0 / 255.0), blue: (215.0 / 255.0), alpha: 1.0)
    let ZOOM_FACTOR: CGFloat = 0.09
    var selectedAttribute: UICollectionViewLayoutAttributes?

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }

    required override init() {
        super.init()
        self.minimumLineSpacing = 2
        self.minimumInteritemSpacing = 0
        self.scrollDirection = UICollectionViewScrollDirection.vertical
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Other functions
    /**
     Set Item size with collectionView Size
     
     - parameter collectionViewSize: UICollectionView Size
     
     */
    func setCollectionViewSize(_ collectionViewSize : CGSize) {
        self.itemSize = CGSize(width: collectionViewSize.width * UI_Design_Item_Width_Ratio, height: collectionViewSize.height / 5)
        self.sectionInset = UIEdgeInsetsMake((collectionViewSize.height / 2) - (self.itemSize.height / 2), 0, 0, 0)
    }
    

    // ---------------------------------------------------------------------------------------------
    // MARK: - Override functions
    override class var layoutAttributesClass : AnyClass {
        return WCWordPlayCollectionViewLayoutAttributes.self
    }
    
    override var collectionViewContentSize : CGSize {
        let itemNumber = self.collectionView!.numberOfItems(inSection: 0)

        let totalItemHeight = ((CGFloat(itemNumber) - 1) * self.itemSize.height)
        let totalLineSpacingHeight = ((CGFloat(itemNumber) - 1) * self.minimumLineSpacing)

        return CGSize(width: self.collectionView!.frame.size.width, height: totalItemHeight + totalLineSpacingHeight + self.collectionView!.frame.size.height)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superArray = super.layoutAttributesForElements(in: rect)!
        let visibleRect = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
        
        var attributesArray = [UICollectionViewLayoutAttributes]()

        for superAttribute : UICollectionViewLayoutAttributes in superArray {
            let attributes = superAttribute.copy() as! WCWordPlayCollectionViewLayoutAttributes
            if attributes.frame.intersects(rect) {
                let distance = visibleRect.midY - attributes.center.y
                let normalizeDistance = distance / (self.itemSize.height / 2)
                
                if abs(distance) < self.itemSize.height / 2 {
                    // Highlight Attribute
                    let zoom = 1.0 + ZOOM_FACTOR * (1.0 - abs(normalizeDistance))
                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attributes.zIndex = 1
                    attributes.alpha = 1.0

                    attributes.backgroundColor = Highlight_Color
                    attributes.isHighlight = .highlightCell
                    
                    let shadowPath = UIBezierPath(roundedRect: attributes.bounds, cornerRadius: 1.0)
                    attributes.shadowPath = shadowPath.cgPath
                    attributes.shadowColor = UIColor(white: 0.5, alpha: 1.0).cgColor
                    attributes.shadowOffset = CGSize(width: 0.0, height: 5.0)
                    attributes.shadowOpacity = 1.0
                    
                    selectedAttribute = attributes
                }
                else {
                    // UnhighLight Attribute
                    let testRatio = abs(distance) / (abs(self.collectionView!.frame.size.height) / 2)
                    
                    attributes.backgroundColor = UnHighlight_Color
                    attributes.isHighlight = .unHighlightCell

                    // Alpha will smaller the farther away from the center
                    if((1 / testRatio > 1)) {
                        attributes.alpha = 1.0
                    }
                    else {
                        attributes.alpha = (1 / testRatio)
                    }
                }
            }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }

    // 此 function override 之後可以做到吸附效果，類似 AppStore 中的
//    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        var offsetAdjustment = MAXFLOAT
//        let verticalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView!.bounds) / 2.0)
//        let targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
//        let array = super.layoutAttributesForElementsInRect(targetRect)
//        for layoutAttributes : UICollectionViewLayoutAttributes in array! {
//            layoutAttributes.frame = CGRectMake(layoutAttributes.frame.origin.x, layoutAttributes.frame.origin.y + self.collectionView!.frame.size.height / 2, layoutAttributes.size.width, layoutAttributes.size.height)
//            let itemVertiaclCenter = layoutAttributes.center.x
//
//            if abs(itemVertiaclCenter - verticalCenter) < CGFloat(abs(offsetAdjustment)) {
//                offsetAdjustment = Float(itemVertiaclCenter - verticalCenter)
//            }
//        }
//
//        return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + CGFloat(offsetAdjustment))
//    }
}
