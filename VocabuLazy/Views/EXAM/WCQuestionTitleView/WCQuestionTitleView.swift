//
//  WCQuestionTitleView.swift
//  Swallow
//
//  Created by Goston on 2016/4/9.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

// Define Color
private let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0);

class WCQuestionTitleView: UIView {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var titleLabel: UILabel?
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialTitleLine()
        initialTitleLabel("")
    }
    
    
    /// Initial mutiplie variables
    ///
    /// - Parameters:
    ///   - frame: CGRect
    ///   - titleString: String of title
    convenience init(frame: CGRect, titleString: String) {
        self.init(frame: frame)
        self.initialTitleLine()
        self.initialTitleLabel(titleString)
    }
    
    fileprivate func initialTitleLine() {
        let titleLine = CALayer()
        titleLine.frame = CGRect(x: 0, y: self.bounds.height / 2 - 2, width: self.bounds.width, height: 4)
        titleLine.backgroundColor = WC_Green_Color.cgColor
        self.layer.addSublayer(titleLine)
    }
    
    fileprivate func initialTitleLabel(_ titleString: String) {
        titleLabel = UILabel(frame: CGRect(x: (self.bounds.width - 50) / 2, y: (self.bounds.height - 21) / 2, width: 50, height: 21))
        titleLabel!.text = titleString
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.backgroundColor = UIColor.white
        titleLabel!.font = UIFont (name: "DFHeiStd-W7", size: 17)
        self.addSubview(titleLabel!)
    }
    
    /**
     設定 Title 的字串
     
     - parameter titleString: UILable text
     */
    func setTitleString(_ titleString: String) {
        titleLabel?.text = titleString
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
