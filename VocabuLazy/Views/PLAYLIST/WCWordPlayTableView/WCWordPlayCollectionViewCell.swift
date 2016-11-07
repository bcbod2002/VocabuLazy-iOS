//
//  WCWordPlayCollectionViewCell.swift
//  Swallow
//
//  Created by Goston on 2015/8/24.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

// -------------------------------------------------------------------------------------------------
// MARK: - Define
// Define color
private let HightLight_Background_Color = UIColor(red: (254.0 / 255.0), green: (206.0 / 255.0), blue: (85.0 / 255.0), alpha: 1.0)
private let UnHighlight_Background_Color = UIColor(red: (179.0 / 255.0), green: (235.0 / 255.0), blue: (221.0 / 255.0), alpha: 1.0)
private let Sentence_Background_Color = UIColor(red: (197.0 / 255.0), green: (159.0 / 255.0), blue: (57.0 / 255.0), alpha: 1.0)
private let UnHighlight_Text_Color = UIColor(red: (147.0 / 255.0), green: (148.0 / 255.0), blue: (148.0 / 255.0), alpha: 1.0)

// -------------------------------------------------------------------------------------------------
// Define text size 原圖是72dpi
private let ScreenSizeRatio: CGFloat! = UIScreen.main.bounds.size.height / (1920.0 / 2.0)
private let Vocabulary_EnglishTextSize: CGFloat = 39.6 * ScreenSizeRatio
private let Vocabulary_ChineseTextSize: CGFloat = 23.85 * ScreenSizeRatio
private let Sentence_TitleSize: CGFloat = 60.0 * 0.666 * ScreenSizeRatio
private let Sentence_TextSize: CGFloat = 40.0 * 0.666 * ScreenSizeRatio


// -------------------------------------------------------------------------------------------------
// MARK: - WCWordPlayCollectionViewCellDelegate
@objc protocol WCWordPlayCollectionViewCellDelegate {
    /**
     WCWordPlaySentenceView which in WCWordPlayCollectionViewCell begin scroll with finger
     
     - parameter cell:                WCWordPlayCollectionViewCell
     - parameter sentenceContentView: WCWordPlaySentenceView
     */
    @objc optional func cell(_ cell: WCWordPlayCollectionViewCell, beginScrollWithFinger sentenceContentView: WCWordPlaySentenceView)
    
    /**
     WCWordPlaySentenceView which in WCWordPlayCollectionViewCell did scroll to item
     
     - parameter cell:                WCWordPlayCollectionViewCell
     - parameter sentenceContentView: WCWordPlaySentenceView
     - parameter itemNumber:          Item number
     */
    @objc optional func cell(_ cell: WCWordPlayCollectionViewCell, scroll sentenceContentView: WCWordPlaySentenceView, to itemNumber:Int)
}


// -------------------------------------------------------------------------------------------------
// MARK: - HighlightStatus
enum HighlightStatus {
    case highlightCell
    case unHighlightCell
}

class WCWordPlayCollectionViewCell: UICollectionViewCell, WCWordPlaySentenceViewDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // Vocabulary Type
    fileprivate var englishLabel: UILabel!
    fileprivate var chineseLabel: UILabel!
    fileprivate var kkLabel: UILabel?

    fileprivate let zoom: CGFloat! = 1.4
    fileprivate(set) internal var isAmplify = false
    fileprivate var sentenceView: UIView!

    fileprivate var sentenceContentView: UIView!

    // Sentence Type
    fileprivate var englishKKTitleLabel: UILabel!
    fileprivate var chineseTitleLabel: UILabel?
    fileprivate var enChSentenceView: WCWordPlaySentenceView?
    fileprivate var englishSentenceArray: [String] = [String]()
    fileprivate var chineseSentenceArray: [String] = [String]()

    var isHighlight = HighlightStatus.highlightCell
    var indexPath: IndexPath!
    fileprivate var vocabulary : WCVocabularyModel?
    var delegate: WCWordPlayCollectionViewCellDelegate?

    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        indexPath = IndexPath()

        englishLabel = UILabel()
        chineseLabel = UILabel()
        kkLabel = UILabel()

        sentenceView = UIView()
        englishKKTitleLabel = UILabel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        indexPath = IndexPath()

        initialVocabularyRelate()
        initialSentenceRelate()

        contentView.backgroundColor = UnHighlight_Background_Color
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? WCWordPlayCollectionViewLayoutAttributes {
            self.contentView.backgroundColor = attributes.backgroundColor
            
            self.layer.shadowPath = attributes.shadowPath
            self.layer.shadowColor = attributes.shadowColor
            self.layer.shadowOffset = attributes.shadowOffset
            self.layer.shadowOpacity = attributes.shadowOpacity
            
            self.isHighlight = attributes.isHighlight
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial relate function
    /**
     Initial Vicabulary labels
     */
    fileprivate func initialVocabularyRelate() {
        // Initial EnglishLabel
        englishLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        
        englishLabel.font = UIFont (name: "Futura Md BT", size: Vocabulary_EnglishTextSize)
        englishLabel.textColor = UnHighlight_Text_Color
        englishLabel.textAlignment = NSTextAlignment.center
        englishLabel.text = "Appearance"
        
        // Initial ChineseLabel
        chineseLabel = UILabel (frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: frame.height / 4))
        chineseLabel.font = UIFont (name: "DFHeiStd-W7", size: Vocabulary_ChineseTextSize)
        chineseLabel.textColor = UnHighlight_Text_Color
        chineseLabel.textAlignment = NSTextAlignment.center
        chineseLabel.text = "出現 ; 顯露"
        
        // Initial KKLabel
        kkLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height * 3 / 4, width: frame.size.width, height: frame.size.height / 4))
        // Older phonetic font - BeYoungsPhoneticSymbolPlain
        kkLabel!.font = UIFont(name: "Futura Md BT", size: Vocabulary_ChineseTextSize)
        kkLabel!.textColor = UnHighlight_Text_Color
        kkLabel!.textAlignment = NSTextAlignment.center
        kkLabel!.text = "[bother]"
        
        contentView.addSubview(englishLabel)
        contentView.addSubview(chineseLabel)
        contentView.addSubview(kkLabel!)
    }
    
    /**
     Initial relate function
     */
    fileprivate func initialSentenceRelate() {
        // Initial Sentence view
        sentenceView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        sentenceView.backgroundColor = HightLight_Background_Color
        sentenceView.alpha = 0.0
        
        // Initial Sentence english title and chinese title
        englishKKTitleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: contentView.bounds.width - 10, height: 25))
        // Older phonetic font - DFHeiStd-W7
        englishKKTitleLabel.font = UIFont (name: "Futura Md BT", size: Sentence_TextSize)
        englishKKTitleLabel.textAlignment = NSTextAlignment.natural
        englishKKTitleLabel.text = "Appearance [appearance]"
        englishKKTitleLabel.textColor = UIColor.white
        englishKKTitleLabel.alpha = 0.0
        
        // Initial Sentence kk phonetic
        chineseTitleLabel = UILabel(frame: CGRect(x: 5, y: englishKKTitleLabel.frame.maxY, width: contentView.bounds.width - 10, height: 25))
        chineseTitleLabel?.font = UIFont(name: "DFHeiStd-W7", size: Sentence_TextSize)
        chineseTitleLabel?.textAlignment = NSTextAlignment.natural
        chineseTitleLabel?.text = "出現 ; 顯現"
        chineseTitleLabel?.textColor = UIColor.white
        chineseTitleLabel?.alpha = 0.0
        
        // Initial Sentence content view
        sentenceContentView = UIView(frame: CGRect(x: 5, y: chineseTitleLabel!.frame.maxY, width: sentenceView.frame.width - 10, height: (contentView.frame.height * zoom * 2) - chineseTitleLabel!.frame.maxY - 5))
        sentenceContentView.backgroundColor = UIColor.white
        sentenceContentView.alpha = 0.0
        
        // Initiel Sentence english and chinese sentenceView
        enChSentenceView = WCWordPlaySentenceView(frame: sentenceContentView.bounds)
        enChSentenceView?.delegate = self
        
        contentView.addSubview(sentenceView)
        
        sentenceView.addSubview(englishKKTitleLabel)
        sentenceView.addSubview(chineseTitleLabel!)
        sentenceContentView.addSubview(enChSentenceView!)
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Set Label string
    /**
     Set english and chinese label text with WCVocabularyModel
     
     - parameter vocabularyModel: WCVocabularyModel
     */
    func setVocabulary(_ vocabularyModel : WCVocabularyModel) {
        vocabulary = vocabularyModel
        englishLabel.text = vocabularyModel.english
        
        let partOfSpeech = "(" + String(vocabularyModel.partOfSpeech) + ")" + "  "
        chineseLabel.text = partOfSpeech + vocabularyModel.chinese
        
        kkLabel?.text = vocabularyModel.phonetic
        
        englishKKTitleLabel.text = vocabularyModel.english + " " + vocabularyModel.phonetic
        chineseTitleLabel?.text = vocabularyModel.chinese
        
        enChSentenceView?.setVocabulary(vocabularyModel)
    }
    
    fileprivate func adjustLabelSizeAccordingText(_ labelString: String) -> CGSize {
        let maximumLabelSize = CGSize(width: contentView.bounds.size.width, height: contentView.bounds.size.height / 2)
        let attributeDictionary = [NSFontAttributeName: UIFont.systemFont(ofSize: Vocabulary_EnglishTextSize)]
        let nsLabelString = labelString as NSString
        
        let labelBounds = nsLabelString.boundingRect(with: maximumLabelSize, options: NSStringDrawingOptions.truncatesLastVisibleLine, attributes: attributeDictionary, context: nil)
        
        
        return labelBounds.size
    }
    
    /**
     Add tap gesture to SentenceView
     
     - parameter target: Any object
     - parameter action: Closure
     */
    func addTapGestureToSentenceView(with target: AnyObject, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        sentenceView.addGestureRecognizer(tapGesture)
    }
    
    /**
     Scroll to sentence
     
     - parameter sentenceItemNumber: Item number of sentence
     - parameter isAnimation:        Do animation or not
     */
    func scrollSentenceTo(_ sentenceItemNumber: Int, isAnimation:Bool) {
        enChSentenceView?.scrollToSentence(with: sentenceItemNumber,isAnimation: isAnimation)
    }
   
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlaySentenceView Delegate
    func sentenceViewBeginScrollWithFinger(_ sentenceView: WCWordPlaySentenceView) {
        delegate?.cell?(self, beginScrollWithFinger: sentenceView)
    }
    
    func sentenceView(_ sentenceView: WCWordPlaySentenceView, didScrollToItem itemNumber: Int) {
        delegate?.cell?(self, scroll: sentenceView, to: itemNumber)
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Cell animation
    /**
     Amplify WCWordPlayCollectionViewCell
     
     - parameter success: WCWordPlayCollectionViewCell is amplify or not
     */
    func cellAmplify(_ animated: Bool, success:@escaping ((_ amplify: Bool) -> Void)) {
        let amplifyFrame = CGRect(x: 0, y: sentenceView.frame.origin.y - (sentenceView.frame.size.height / zoom), width: sentenceView.frame.width, height: sentenceView.frame.height * zoom  * 2)

        if  !isAmplify {
            
            let shadowAmplifyAnimation = CABasicAnimation(keyPath: "shadowPath")
            let shadowAmplifyPath = UIBezierPath(roundedRect: amplifyFrame, cornerRadius: 1).cgPath
            
            shadowAmplifyAnimation.duration = 0.5
            shadowAmplifyAnimation.toValue = shadowAmplifyPath
            shadowAmplifyAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            shadowAmplifyAnimation.fillMode = kCAFillModeForwards
            shadowAmplifyAnimation.isRemovedOnCompletion = false
            
            if animated == true {
                // 有動畫
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.englishLabel.alpha = 0
                    self.chineseLabel.alpha = 0
                    self.kkLabel?.alpha = 0
                    }, completion: { (Bool) -> Void in
                        self.sentenceView.alpha = 1
                        self.layer.add(shadowAmplifyAnimation, forKey: "shadowPath")
                })
                
                UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.sentenceView.backgroundColor = Sentence_Background_Color
                    
                    self.sentenceView.frame = amplifyFrame
                    
                    }, completion: { (Bool) -> Void in
                        self.layer.shadowPath = shadowAmplifyPath
                        self.layer.removeAllAnimations()
                })
                sentenceView.addSubview(sentenceContentView)
                
                UIView.animate(withDuration: 0.3, delay: 0.8, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.sentenceContentView.alpha = 1
                    self.englishKKTitleLabel.alpha = 1
                    self.chineseTitleLabel?.alpha = 1
                    }, completion: { (Bool) -> Void in
                        self.isAmplify = true
                        success(self.isAmplify)
                })
            }
            else {
                // 沒動畫
                englishLabel.alpha = 0
                chineseLabel.alpha = 0
                sentenceView.alpha = 1
                layer.shadowPath = shadowAmplifyPath
                sentenceView.backgroundColor = Sentence_Background_Color
                sentenceView.frame = amplifyFrame
                sentenceView.addSubview(sentenceContentView)
                sentenceContentView.alpha = 1
                englishKKTitleLabel.alpha = 1
                chineseTitleLabel?.alpha = 1
                isAmplify = true
                success(isAmplify)
            }
        }
    }

    /**
     Minify WCWordPlayCollectionViewCell
     
     - parameter success: WCWordPlayCollectionViewCell is amplify or not
     */
    func cellMinify(_ animated: Bool, success:@escaping ((_ amplify: Bool) -> Void)) {
        let amplifyFrame = CGRect(x: 0, y: sentenceView.frame.origin.y, width: sentenceView.frame.width, height: sentenceView.frame.height)
        let minifyFrame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height * zoom)

        if  isAmplify {
            
            let shadowMinifyAnimation = CABasicAnimation(keyPath: "shadowPath")
            let shadowAmplifyPath = UIBezierPath(roundedRect: amplifyFrame, cornerRadius: 1).cgPath
            let shadowMinifyPath = UIBezierPath(roundedRect: bounds, cornerRadius: 1).cgPath

            shadowMinifyAnimation.duration = 0.5
            shadowMinifyAnimation.fromValue = shadowAmplifyPath
            shadowMinifyAnimation.toValue = shadowMinifyPath
            shadowMinifyAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            shadowMinifyAnimation.fillMode = kCAFillModeForwards
            shadowMinifyAnimation.isRemovedOnCompletion = false

            if animated == true {
                // 有動畫
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.sentenceContentView.alpha = 0
                    self.englishKKTitleLabel.alpha = 0
                    self.chineseTitleLabel?.alpha = 0
                    }, completion: { (Bool) -> Void in
                        self.sentenceContentView.removeFromSuperview()
                        self.layer.add(shadowMinifyAnimation, forKey: "shadowPath")
                })
                
                
                UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.sentenceView.frame = self.bounds
                    self.sentenceView.backgroundColor = HightLight_Background_Color
                    
                    }, completion: { (Bool) -> Void in
                        self.sentenceView.alpha = 0.0
                        
                })
                
                UIView.animate(withDuration: 0.3, delay: 0.8, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.englishLabel.alpha = 1
                    self.chineseLabel.alpha = 1
                    self.kkLabel?.alpha = 1
                    }, completion: { (Bool) -> Void in
                        self.isAmplify = false
                        self.layer.shadowPath = shadowMinifyPath
                        self.layer.removeAllAnimations()
                        // 把Sentence View 內部的 滾動到初始化
                        self.scrollSentenceTo(0, isAnimation: false)
                        success(self.isAmplify)
                })
            }
            else {
                // 沒動畫
                sentenceContentView.alpha = 0
                englishKKTitleLabel.alpha = 0
                chineseTitleLabel?.alpha = 0
                sentenceContentView.removeFromSuperview()
                layer.shadowPath = shadowMinifyPath
                sentenceView.frame = minifyFrame
                sentenceView.backgroundColor = HightLight_Background_Color
                sentenceView.alpha = 0
                englishLabel.alpha = 1
                chineseLabel.alpha = 1
                isAmplify = false
                scrollSentenceTo(0, isAnimation: false)
                success(isAmplify)
            }
        }
    }
}
