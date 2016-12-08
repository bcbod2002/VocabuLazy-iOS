//
//  WCLessonChooseCell.swift
//  Swallow
//
//  Created by Goston on 2015/9/22.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

class WCLessonChooseCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    let Button_Size_Ratio = CGFloat(72.0 / 960.0)
    let Font_Ratio = CGFloat(UIScreen.main.bounds.size.height / 960.0)

    let screenSize : CGSize = UIScreen.main.bounds.size

    // Private variable
    fileprivate var buttonView : UIView!
    fileprivate var buttonLabel : UILabel!

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        let buttonSize = CGSize(width: screenSize.height * Button_Size_Ratio, height: screenSize.height * Button_Size_Ratio)

        // Button View
        buttonView = UIView(frame: CGRect(x: center.x - (buttonSize.width / 2), y: center.y - (buttonSize.height / 2), width: buttonSize.width, height: buttonSize.height))
        buttonView.layer.cornerRadius = buttonSize.height / 2.0
        buttonView.backgroundColor = UIColor.black

        // Button shadow
        let shadowPath = UIBezierPath(roundedRect: buttonView.bounds, cornerRadius: buttonView.frame.size.width / 2)
        buttonView.layer.shadowColor = UIColor.gray.cgColor
        buttonView.layer.shadowPath = shadowPath.cgPath
        buttonView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        buttonView.layer.shadowOpacity = 1.0

        // Button label
        buttonLabel = UILabel (frame: CGRect(x: center.x - (buttonSize.width / 2), y: center.y - (buttonSize.height * 7 / 12), width: buttonSize.width / 2, height: buttonSize.height / 2))
        buttonLabel.text = "1"
        buttonLabel.textColor = UIColor.white
        buttonLabel.textAlignment = NSTextAlignment.center
        buttonLabel.font = UIFont(name: "DFHeiMedium-B5", size: 30 * Font_Ratio)


        buttonView.addSubview(buttonLabel)
        self.contentView.addSubview(buttonView)
    }

    func setButtonColor(_ color: UIColor) {
        buttonView.backgroundColor = color
    }

    func setButtonNumber(_ numberString: String) {
        buttonLabel.text = numberString
    }
    
}
