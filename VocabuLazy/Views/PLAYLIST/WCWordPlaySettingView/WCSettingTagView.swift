//
//  WCSettingTagView.swift
//  Swallow
//
//  Created by Goston on 2015/10/31.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

class WCSettingTagView: UIView {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
     Initial WCSettingTagView frame, backgroundColor, name
     
     - parameter frame:           CGRect
     - parameter backgroundColor: WCSettingTagView backgroundColor
     - parameter tagName:         WCSettingTagView name
     
     - returns: WCSettingTagView
     */
    convenience init(frame: CGRect, backgroundColor: UIColor, tagName: String) {
        self.init(frame: frame)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 5))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = backgroundColor.cgColor
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
        
        self.layer.shadowPath = path.cgPath
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.initialTagLabelWithString(tagName)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Content components tinitial
    fileprivate func initialTagLabelWithString(_ labelString : String) {
        let tagLabel = UILabel(frame: CGRect(x: 0, y: self.bounds.height / 5, width: self.bounds.width, height: self.bounds.height * 4 / 5))
        tagLabel.textAlignment = NSTextAlignment.center
        tagLabel.text = labelString
        tagLabel.textColor = UIColor.white
        self.addSubview(tagLabel)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Layer position
    /**
    Pull self forward
    */
    func pullTagForward() {
        self.layer.zPosition = 0.0
    }
    
    /**
     Push self backward
     */
    func pushTagBackward() {
        self.layer.zPosition = -1.0
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
