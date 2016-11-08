//
//  WCWordPlaySettingView.swift
//  Swallow
//
//  Created by Goston on 2015/9/29.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

// MARK: - WCWordPlaySettingView Delegate
@objc protocol WCWordPlaySettingViewDelegate {
    /**
    WCWordPlaySettingView finished appear animation
    */
    @objc optional func didFinishedAppearAnimation()

    /**
    WCWordPlaySettingView finished disappear animation
    */
    @objc optional func didStartDisappearAnimation()
    
    /**
     WCWordPlaySettingView did set model
     */
    func didChangeSettingModel()
}

class WCWordPlaySettingView: UIView, UIScrollViewDelegate, WCSettingContentViewDelegate {
    // MARK: - Define costance
    fileprivate let WidthHeightRatio: CGFloat! = 0.818
    fileprivate let TagHeightRatio: CGFloat! = 0.182
    fileprivate let ScreenSizeRatio: CGFloat! = UIScreen.main.bounds.size.height / (1920.0 / 2.0)
    fileprivate let CustomColor: UIColor! = UIColor(red: 106.0 / 255.0, green: 190.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    fileprivate let SleepColor: UIColor! = UIColor(red: 150.0 / 255.0, green: 205.0 / 255.0, blue: 164.0 / 255.0, alpha: 1.0)
    fileprivate let CommutingColor: UIColor! = UIColor(red: 169.0 / 255.0, green: 208.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    
    fileprivate let screenSize : CGSize = UIScreen.main.bounds.size
    fileprivate var tagsViewOriginY : CGFloat!

    // ------------------------------------------------------------------------------------------------
    // MARK: - Private variables
    fileprivate var grayMaskView: UIView?
    fileprivate var backgroundScrollView: UIScrollView!
    fileprivate var customView: WCSettingContentView!
    fileprivate var sleepView: WCSettingContentView!
    fileprivate var commutingView: WCSettingContentView!
    
    fileprivate var customTagView: WCSettingTagView!
    fileprivate var sleepTagView: WCSettingTagView!
    fileprivate var commutingTagView: WCSettingTagView!

    var selectedPattern: PatternType! = PatternType.customPattern

    // MARK: - Public variables
    // Public WCSettingContentModel
    var selectedSettingModal: WCSettingContentModel?

    // Public variable
    var delegate: WCWordPlaySettingViewDelegate!

    // MARK: - Initial WCWordSettingView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initialGrayMaskView(with: frame.size)
        initializeBackgroundTapView(frame.size)
        initializeBacgreoundScrollView(frame.size)
        initialSettingTagViews(frame.size)
        initialSettingContentViews(frame.size)
        
        self.addSubview(backgroundScrollView)
    }

    fileprivate func initialGrayMaskView(with frameSize: CGSize) {
        grayMaskView = UIView(frame: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height))
        grayMaskView!.backgroundColor = UIColor.gray
        grayMaskView!.alpha = 0.0
    }
    
    // MARK: - Content components initial
    // Initial Background
    fileprivate func initializeBackgroundTapView(_ frameSize: CGSize) {
        let backgroundTapView = UIView(frame: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.width * WidthHeightRatio))
        backgroundTapView.backgroundColor = UIColor.clear

        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(WCWordPlaySettingView.tapBackground(_:)))
        backgroundTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(backgroundTapGesture)

        backgroundTapView.addGestureRecognizer(backgroundTapGesture)

        self.addSubview(backgroundTapView)
    }
    
    // Initial Background Scroll view
    fileprivate func initializeBacgreoundScrollView(_ frameSize: CGSize!) {
        backgroundScrollView = UIScrollView(frame: CGRect(x: 0, y: frameSize.height - (frameSize.width * WidthHeightRatio), width: frameSize.width, height: frameSize.width * WidthHeightRatio))
        backgroundScrollView.delegate = self
        backgroundScrollView.isDirectionalLockEnabled = true
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.contentSize = CGSize(width: frameSize.width * 3.0, height: frameSize.width * WidthHeightRatio)
        backgroundScrollView.backgroundColor = UIColor.clear
        backgroundScrollView.isPagingEnabled = true
        
        tagsViewOriginY = frameSize.height - backgroundScrollView.bounds.size.height - backgroundScrollView.bounds.size.height * TagHeightRatio
    }
    
    // // Initial Setting Content view
    fileprivate func initialSettingContentViews(_ frameSize: CGSize!) {
        // Initial Custom WCSettingContentModel
        let customSettingContentModel = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.noneSentence, second: 1, frequency: 1, speed: 1, playTime: 1)
        
        // Initial Sleep WCSettingContentModel
        let sleepSettingContentModel = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.noneSentence, second: 1, frequency: 1, speed: 1, playTime: 1)
        
        // Initial Commuting WCSettingContentModel
        let commuttingSettingContentModel = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.noneSentence, second: 1, frequency: 1, speed: 1, playTime: 1)
     
        // Initial Custom WCSettingContentView
        customView = WCSettingContentView(frame: CGRect(x: 0, y: 0, width: backgroundScrollView.bounds.size.width, height: backgroundScrollView.bounds.size.height), setDelegate: self, contentModel: customSettingContentModel)
        customView.backgroundColor = CustomColor
        
        // Initial Sleep WCSettingContentView
        sleepView = WCSettingContentView(frame: CGRect(x: backgroundScrollView.bounds.size.width, y: 0, width: backgroundScrollView.bounds.size.width, height: backgroundScrollView.bounds.size.height), setDelegate: self, contentModel: sleepSettingContentModel)
        sleepView.backgroundColor = SleepColor
        
        // Initial Commutin WCSettingContentView
        commutingView = WCSettingContentView(frame: CGRect(x: backgroundScrollView.bounds.size.width * 2.0, y: 0, width: backgroundScrollView.bounds.size.width, height: backgroundScrollView.bounds.size.height), setDelegate: self, contentModel: commuttingSettingContentModel)
        commutingView.backgroundColor = CommutingColor
        
        backgroundScrollView.addSubview(customView)
        backgroundScrollView.addSubview(sleepView)
        backgroundScrollView.addSubview(commutingView)
    }
    
    // Initial Setting Tag view
    fileprivate func initialSettingTagViews(_ frameSize: CGSize) {
        customTagView = WCSettingTagView(frame: CGRect(x: 0, y: tagsViewOriginY, width: frameSize.width / 3.0, height: backgroundScrollView.bounds.height * TagHeightRatio), backgroundColor: CustomColor, tagName: "自訂模式")
        customTagView.tag = 0
        let customTap = UITapGestureRecognizer(target: self, action: #selector(WCWordPlaySettingView.tagViewTapAction(_:)))
        customTagView.addGestureRecognizer(customTap)
        
        sleepTagView = WCSettingTagView(frame: CGRect(x: frameSize.width / 3.0, y: tagsViewOriginY, width: frameSize.width / 3.0, height: backgroundScrollView.bounds.height * TagHeightRatio), backgroundColor: SleepColor, tagName: "睡眠模式")
        sleepTagView.tag = 1
        let sleepTap = UITapGestureRecognizer(target: self, action: #selector(WCWordPlaySettingView.tagViewTapAction(_:)))
        sleepTagView.addGestureRecognizer(sleepTap)
        
        
        commutingTagView = WCSettingTagView(frame: CGRect(x: frameSize.width * 2.0 / 3.0, y: tagsViewOriginY, width: frameSize.width / 3.0, height: backgroundScrollView.bounds.height * TagHeightRatio), backgroundColor: CommutingColor, tagName: "通勤模式")
        commutingTagView.tag = 2
        let commutingTap = UITapGestureRecognizer(target: self, action: #selector(WCWordPlaySettingView.tagViewTapAction(_:)))
        commutingTagView.addGestureRecognizer(commutingTap)
        
        self.addSubview(customTagView)
        self.addSubview(sleepTagView)
        self.addSubview(commutingTagView)
    }

    // Tap background
    @objc fileprivate func tapBackground(_ sender : UITapGestureRecognizer) {
        // Disappear Animation
        self.disappearAnimation()
    }

    // MARK: - Animation
    func appearAnimation(from superView: UIView) {
        readDataFromUserDefaults()
        
        superView.addSubview(grayMaskView!)
        superView.addSubview(self)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.grayMaskView?.alpha = 0.5
            self.frame = CGRect(x: 0, y: -65, width: self.frame.size.width, height: self.frame.size.height)
            }) { (completion) -> Void in
                self.delegate.didFinishedAppearAnimation?()
        }
    }

    func disappearAnimation(from superView: UIView) {
        disappearAnimation()
    }
    
    fileprivate func disappearAnimation() {
        saveDataToUserDefaults()
        delegate.didStartDisappearAnimation?()
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.grayMaskView?.alpha = 0.0
            self.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        }) { (completion) -> Void in
            self.grayMaskView?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    // MARK: - Read and Save Setting from UserDefaults
    // Initial UserDefaults
    fileprivate func initWordPlaySettingUserDefaults() -> [String : Any] {

        // CustomSetting
        let customSettingModel = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.noneSentence, second: 0, frequency: 1, speed: 1, playTime: 10)
        let customModelData = NSKeyedArchiver.archivedData(withRootObject: customSettingModel)
        let customSettingDictionary: [String : Any] = ["settingContentModel" : customModelData, "isSelected" : NSNumber(value: true)]
        
        // SleepSetting
        let sleepSettingModel = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.noneSentence, second: 0, frequency: 1, speed: 1, playTime: 10)
        let sleepModelData = NSKeyedArchiver.archivedData(withRootObject: sleepSettingModel)
        let sleepSettingDictionary: [String : Any] = ["settingContentModel" : sleepModelData, "isSelected" : NSNumber(value: false)]
        
        // CommutinSetting
        let commutingSettingModel = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.noneSentence, second: 0, frequency: 1, speed: 1, playTime: 10)
        let commutingModelData = NSKeyedArchiver.archivedData(withRootObject: commutingSettingModel)
        let commutingSettingDictionary: [String : Any] = ["settingContentModel" : commutingModelData, "isSelected" : NSNumber(value: false)]
        
        // WordPlaySetting
        let wordPlaySetting: [String : Any] = ["customSetting" : customSettingDictionary, "sleepSetting" : sleepSettingDictionary, "commutingSetting" : commutingSettingDictionary]
        
        selectedSettingModal = customSettingModel
        
        return wordPlaySetting
    }

    // Read from UserDefaults
    func readDataFromUserDefaults() {
        let userDefault = UserDefaults.standard
        let wordPlaySetting : NSDictionary! = userDefault.dictionary(forKey: "wordPlaySetting") as NSDictionary!
        if (wordPlaySetting == nil) {
            userDefault.set(self.initWordPlaySettingUserDefaults(), forKey: "wordPlaySetting")
            userDefault.synchronize()
            
            backgroundScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        else {
            let customDictionary = wordPlaySetting.object(forKey: "customSetting") as! NSDictionary
            let customSelected : Bool = (customDictionary.object(forKey: "isSelected") as! NSNumber).boolValue
            self.setContentViewFromSetDictionary(customView, setDictionary: customDictionary)
            
            let sleepDictionary = wordPlaySetting.object(forKey: "sleepSetting") as! NSDictionary
            let sleepSelected : Bool = (sleepDictionary.object(forKey: "isSelected") as! NSNumber).boolValue
            self.setContentViewFromSetDictionary(sleepView, setDictionary: sleepDictionary)
            
            let commutingDictionary = wordPlaySetting.object(forKey: "commutingSetting") as! NSDictionary
            let commutingSelected : Bool = (commutingDictionary.object(forKey: "isSelected") as! NSNumber).boolValue
            self.setContentViewFromSetDictionary(commutingView, setDictionary: commutingDictionary)
            
            if(customSelected) {
                selectedPattern = PatternType.customPattern
                customTagView.pullTagForward()
                sleepTagView.pushTagBackward()
                commutingTagView.pushTagBackward()
                backgroundScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
            else if(sleepSelected) {
                selectedPattern = PatternType.sleepPattern
                customTagView.pushTagBackward()
                sleepTagView.pullTagForward()
                commutingTagView.pushTagBackward()
                backgroundScrollView.setContentOffset(CGPoint(x: backgroundScrollView.frame.size.width, y: 0), animated: false)
            }
            else if(commutingSelected) {
                selectedPattern = PatternType.commutingPattern
                customTagView.pushTagBackward()
                sleepTagView.pushTagBackward()
                commutingTagView.pullTagForward()
                backgroundScrollView.setContentOffset(CGPoint(x: backgroundScrollView.frame.size.width * 2.0, y: 0), animated: false)
            }
            else {
                selectedPattern = PatternType.customPattern
                customTagView.pullTagForward()
                sleepTagView.pushTagBackward()
                commutingTagView.pushTagBackward()
                backgroundScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
    }
    
    // Set information to ContentView
    fileprivate func setContentViewFromSetDictionary(_ contentView: WCSettingContentView, setDictionary: NSDictionary) {
        let contentViewModel = NSKeyedUnarchiver.unarchiveObject(with: setDictionary.object(forKey: "settingContentModel") as! Data) as! WCSettingContentModel
        contentView.setSettingContentModal(contentViewModel)
        if((setDictionary.object(forKey: "isSelected") as! NSNumber).boolValue) {
            selectedSettingModal = NSKeyedUnarchiver.unarchiveObject(with: setDictionary.object(forKey: "settingContentModel") as! Data) as? WCSettingContentModel
        }
        
//        self.printLogTest()
    }

    // Save to UserDefaults
    fileprivate func saveDataToUserDefaults() {
        let userDefault = UserDefaults.standard
        var customSelected : Bool = false
        var sleepSelected : Bool = false
        var commutingSelected : Bool = false
        switch(selectedPattern.rawValue) {
        case PatternType.customPattern.rawValue :
                customSelected = true
                sleepSelected = false
                commutingSelected = false
            break
            
            case PatternType.sleepPattern.rawValue :
                customSelected = false
                sleepSelected = true
                commutingSelected = false
            break
            
            case PatternType.commutingPattern.rawValue :
                customSelected = false
                sleepSelected = false
                commutingSelected = true
            break
            
            default :
                break
        }
        
        let customDictionary = self.packageContentViewSetting(customView, isSelected: customSelected)
        
        let sleepDictionary = self.packageContentViewSetting(sleepView, isSelected: sleepSelected)
        
        let commutingDictionary = self.packageContentViewSetting(commutingView, isSelected: commutingSelected)
        
        let wordPlaySetting = NSDictionary(objects: [customDictionary, sleepDictionary, commutingDictionary], forKeys: ["customSetting" as NSCopying, "sleepSetting" as NSCopying, "commutingSetting" as NSCopying])
        
        userDefault.set(wordPlaySetting, forKey: "wordPlaySetting")
        userDefault.synchronize()
    }
    
    fileprivate func packageContentViewSetting(_ contentview: WCSettingContentView, isSelected: Bool) -> NSDictionary {
        let contentViewContentModel = NSKeyedArchiver.archivedData(withRootObject: contentview.settingContentModel!)
        let contentSetting = NSDictionary(objects: [contentViewContentModel, NSNumber(value: isSelected as Bool)], forKeys: ["settingContentModel" as NSCopying, "isSelected" as NSCopying])
        
        return contentSetting
    }

    // MARK: - Tap TagView gesture
    @objc fileprivate func tagViewTapAction(_ sender : UITapGestureRecognizer) {
        let tappedTagView : WCSettingTagView! = sender.view as! WCSettingTagView

        switch (tappedTagView.tag) {
            case 0 :
                selectedPattern = PatternType.customPattern
                customTagView.pullTagForward()
                sleepTagView.pushTagBackward()
                commutingTagView.pushTagBackward()
                backgroundScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            case 1 :
                selectedPattern = PatternType.sleepPattern
                customTagView.pushTagBackward()
                sleepTagView.pullTagForward()
                commutingTagView.pushTagBackward()
                backgroundScrollView.setContentOffset(CGPoint(x: backgroundScrollView.frame.size.width, y: 0), animated: true)
            case 2 :
                selectedPattern = PatternType.commutingPattern
                customTagView.pushTagBackward()
                sleepTagView.pushTagBackward()
                commutingTagView.pullTagForward()
                backgroundScrollView.setContentOffset(CGPoint(x: backgroundScrollView.frame.size.width * 2.0, y: 0), animated: true)

            default :
                break
        }
        self.setDetailAdjustAfterScrollEnd()
    }

    // MARK: - UIScrollView Delegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (targetContentOffset.pointee.x == 0) {
            selectedPattern = PatternType.customPattern
            customTagView.pullTagForward()
            sleepTagView.pushTagBackward()
            commutingTagView.pushTagBackward()
        }
        else if(targetContentOffset.pointee.x == scrollView.bounds.width) {
            selectedPattern = PatternType.sleepPattern
            customTagView.pushTagBackward()
            sleepTagView.pullTagForward()
            commutingTagView.pushTagBackward()
        }
        else if (targetContentOffset.pointee.x == scrollView.bounds.width * 2) {
            selectedPattern = PatternType.commutingPattern
            customTagView.pushTagBackward()
            sleepTagView.pushTagBackward()
            commutingTagView.pullTagForward()
        }
        self.setDetailAdjustAfterScrollEnd()
    }

    fileprivate func setDetailAdjustAfterScrollEnd() {
        var tmpContentView : WCSettingContentView!
        if (selectedPattern == PatternType.customPattern) {
            tmpContentView = customView
        }
        else if (selectedPattern == PatternType.sleepPattern) {
            tmpContentView = sleepView
        }
        else {
            tmpContentView = commutingView
        }
        
        selectedSettingModal = tmpContentView.settingContentModel
        delegate.didChangeSettingModel()
    }
    
    // MARK: - WCSettingContentView Delegate
    func didSetContentModel(_ contentModel: WCSettingContentModel) {
        selectedSettingModal = contentModel
        delegate.didChangeSettingModel()
        
//        self.printLogTest();
    }

    func printLogTest() {
        NSLog("selectedSettingModel = \n%@", (selectedSettingModal?.description)!)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
