//
//  WCMaterialButton.swift
//  Swallow
//
//  Created by Goston on 2015/9/19.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

// MARK: - Enumerate
enum AnimationType: UInt {
    case materialType = 0
    case examType
}

class WCMaterialButton: UIButton {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Public variables
    var materialAnimation: AnimationType = .materialType
    var touchBeganColor: UIColor? = UIColor.white
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if (self.frame.size.width == self.frame.size.height) {
            self.layer.cornerRadius = self.frame.size.width / 2
        }
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 1.0)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
//        self.layer.shadowOffset = CGSizeMake(0.0, 0.5)
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)

        self.titleLabel?.font = UIFont (name: "DFHeiMedium-B5", size: 20.0)
        self.titleLabel?.textColor = UIColor (white: 1.0, alpha: 1.0)
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.titleLabel?.numberOfLines = 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        if (frame.size.width == frame.size.height) {
            self.layer.cornerRadius = frame.size.width / 2
        }
//        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: frame.width / 2)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
//        self.layer.shadowPath = shadowPath.CGPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        self.titleLabel?.font = UIFont (name: "DFHeiMedium-B5", size: 20.0)
        self.titleLabel?.textColor = UIColor (white: 1.0, alpha: 1.0)
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.titleLabel?.numberOfLines = 2
    }

    /**
     Initial with frame and button cornet radious
     
     :param: frame              CGRect
     :param: cornerRadious      Button corner radious
     
     :returns: WCMaterialButton
     */
    convenience init(frame: CGRect, cornerRadious: CGFloat) {
        self.init(frame: frame)
        self.layer.cornerRadius = cornerRadious
//        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadious)
//        self.layer.shadowPath = shadowPath.CGPath
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Override Touch Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        switch materialAnimation {
            case .materialType:
                printLog("MaterialType")
            case .examType:
                printLog("ExamType")
                examAnimationTouchBegan()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        switch materialAnimation {
            case .materialType:
                printLog("MaterialType")
            case .examType:
                printLog("ExamType")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        switch materialAnimation {
            case .materialType:
                printLog("MaterialType")
            case .examType:
                printLog("ExamType")
                examAnimationTouchEnded()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        switch materialAnimation {
            case .materialType:
                printLog("MaterialType")
            case .examType:
                printLog("ExamType")
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Material animation type
    /**
     Material button do animation after do touch began
     */
    fileprivate func materialAnimationTouchBegan() {
        
    }
    
    /**
     Material button do animation after do touch began
     */
    fileprivate func materialAnimationEnded() {
        
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Exam animation type
    /**
     Exam button do animation after do touch began
     */
    fileprivate func examAnimationTouchBegan() {
        let afterWidth = self.bounds.width * 0.93
        let afterHeight = self.bounds.height * 0.93
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = self.touchBeganColor
            self.bounds = CGRect(x: 0, y: 0, width: afterWidth, height: afterHeight)
            }, completion: nil)
    }
    
    /**
     Exam button do animation after do toch ended
     */
    fileprivate func examAnimationTouchEnded() {
        let afterWidth = self.bounds.width / 0.93
        let afterHeight = self.bounds.height / 0.93
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.bounds = CGRect(x: 0, y: 0, width: afterWidth, height: afterHeight)
            }, completion: nil)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
