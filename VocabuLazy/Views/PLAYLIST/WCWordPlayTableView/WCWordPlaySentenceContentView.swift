//
//  WCWordPlaySentenceContentView.swift
//  Swallow
//
//  Created by Goston on 2015/12/16.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

// -------------------------------------------------------------------------------------------------
// MARK: - Define
// Define color
private let HightLight_Background_Color = UIColor(red: (254.0 / 255.0), green: (206.0 / 255.0), blue: (85.0 / 255.0), alpha: 1.0)
private let UnHighlight_Background_Color = UIColor(red: (179.0 / 255.0), green: (235.0 / 255.0), blue: (221.0 / 255.0), alpha: 1.0)
private let Sentence_Background_Color = UIColor(red: (197.0 / 255.0), green: (159.0 / 255.0), blue: (57.0 / 255.0), alpha: 1.0)
private let UnHighlight_Text_Color = UIColor(red: (147.0 / 255.0), green: (148.0 / 255.0), blue: (148.0 / 255.0), alpha: 1.0)

// Define text size
private let UnHighlight_EnglishTextSize : CGFloat = 80.0 / 2 * 0.9
private let UnHighlight_ChineseTextSize : CGFloat = 60.0 / 2 * 0.9
private let Highlight_EngalishTextSize : CGFloat = 135.0 / 2 * 0.9
private let Highlight_ChineseTextSize : CGFloat = 75.0 / 2 * 0.9
private let Sentence_TitleSize : CGFloat = 60.0 / 2 * 0.9
private let Sentence_TextSize : CGFloat = 40.0 / 2 * 0.7

class WCWordPlaySentenceContentView: UIView {
    // -------------------------------------------------------------------------------------------------
    // MARK: - Variables
    // UI components
    fileprivate var chineseSentenceLabel : UILabel!
    fileprivate var englishSentenceLabel : UILabel!
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        chineseSentenceLabel = UILabel()
        englishSentenceLabel = UILabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let seperateLine = CALayer()
        seperateLine.frame = CGRect(x: 5, y: frame.height / 2, width: frame.width - 10, height: 1.0);
        seperateLine.backgroundColor = Sentence_Background_Color.cgColor
        self.layer.addSublayer(seperateLine)
        
        englishSentenceLabel = UILabel(frame: CGRect(x: seperateLine.frame.origin.x, y: 0, width: seperateLine.bounds.width, height: frame.height / 2 + 5))
        englishSentenceLabel.font = UIFont(name: "DFHeiStd-W7", size: Sentence_TextSize)
        englishSentenceLabel.textAlignment = NSTextAlignment.natural
        englishSentenceLabel.textColor = UnHighlight_Text_Color
        englishSentenceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        englishSentenceLabel.numberOfLines = Int.max
        
        
        chineseSentenceLabel = UILabel(frame: CGRect(x: seperateLine.frame.origin.x, y: frame.height / 2, width: seperateLine.bounds.width, height: frame.height / 2))
        chineseSentenceLabel.font = UIFont(name: "DFHeiStd-W7", size: Sentence_TextSize)
        chineseSentenceLabel.textAlignment = NSTextAlignment.natural
        chineseSentenceLabel.textColor = UnHighlight_Text_Color
        chineseSentenceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        chineseSentenceLabel.numberOfLines = Int.max
        
        
        self.addSubview(englishSentenceLabel)
        self.addSubview(chineseSentenceLabel)
    }
    
    
    // -------------------------------------------------------------------------------------------------
    // MARK: - Label text
    /**
     Set English sentence label text
     
     - parameter englishSentenceString: English sentence string
     */
    func setEnglishSentenceString(_ englishSentenceString: String) {
        englishSentenceLabel.text = englishSentenceString
    }
    
    /**
     Set Chinese sentence label text
     
     - parameter chineseSentenceString: Chinese sentence string
     */
    func setChineseSentenceString(_ chineseSentenceString: String) {
        chineseSentenceLabel.text = chineseSentenceString
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
