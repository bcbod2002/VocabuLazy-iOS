//
//  WCSettingContentView.swift
//  Swallow
//
//  Created by Goston on 2015/10/24.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol WCSettingContentViewDelegate {
    /**
     WCSettingContentView did touch up any buttons
     
     - parameter contentModel: WCSettingContentModel
     */
    func didSetContentModel(_ contentModel : WCSettingContentModel)
}

class WCSettingContentView: UIView {
    // MARK: - Define costance
    fileprivate let WidthHeightRatio: CGFloat! = 0.818
    fileprivate let TagHeightRatio: CGFloat! = 0.182
    fileprivate let ScreenSizeRatio: CGFloat! = UIScreen.main.bounds.size.height / (1920.0 / 2.0)
    fileprivate let CustomColor:  UIColor! = UIColor(red: 106.0 / 255.0, green: 190.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    fileprivate let SleepColor: UIColor! = UIColor(red: 150.0 / 255.0, green: 205.0 / 255.0, blue: 164.0 / 255.0, alpha: 1.0)
    fileprivate let CommutingColor: UIColor! = UIColor(red: 169.0 / 255.0, green: 208.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)

    fileprivate let screenSize: CGSize = UIScreen.main.bounds.size

    // --------------------------------------------------------------------------------------------------------
    // MARK: - Public variables
    var delegate: WCSettingContentViewDelegate!

    var settingContentModel: WCSettingContentModel? = WCSettingContentModel(pattern: PatternType.customPattern, play: SetPlayType.sequential, cycle: SetCycleType.once, sentence: SetSentenceType.englishSentence, second: 0, frequency: 1, speed: 1, playTime: 10)

    // --------------------------------------------------------------------------------------------------------
    // MARK: - Private variables
    fileprivate var playButton : UIButton!
    fileprivate var cycleButton : UIButton!
//    private var sentenceButton : UIButton!

    fileprivate var secondLabel : UILabel!
    fileprivate var frequencyLabel : UILabel!
    fileprivate var speedLabel : UILabel!
    fileprivate var playTimeLabel : UILabel!

    // MARK: - Initial WCSettingContentView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialSettingButtons()
        self.initialTitleLabels()
        self.initialContentLabels()

        self.layer.zPosition = 0.0
    }
    
    /**
    Initial WCSettingContentView frame , WCSettingContentViewDelegate, WCSettingContentModel
    
    - parameter frame:        CGrect
    - parameter setDelegate:  WCSettingContentViewDelegate
    - parameter contentModel: WCSettingContentModel
    
    - returns: WCSettingContentView
    */
    convenience init(frame: CGRect, setDelegate : WCSettingContentViewDelegate, contentModel : WCSettingContentModel) {
        self.init(frame: frame)
        
        delegate = setDelegate
        
        self.setSettingContentModal(contentModel)
    }

    // MARK: - Content components initial
    // Lefty Buttons
    fileprivate func initialSettingButtons() {
        let buttonSpace = ((self.bounds.size.height) - (104 * ScreenSizeRatio * 3)) / 3
        
        //FIXME: 第一版還不用打開單字卡，因為現在的單字褲沒有例句
        // Sequence Button
//        playButton = UIButton(frame: CGRectMake(50 * ScreenSizeRatio, buttonSpace, 104 * ScreenSizeRatio, 104 * ScreenSizeRatio))
        playButton = UIButton(frame: CGRect(x: 50 * ScreenSizeRatio, y: buttonSpace * 2, width: 104 * ScreenSizeRatio, height: 104 * ScreenSizeRatio))
        playButton.tag = 0
        playButton.setBackgroundImage(UIImage(named: "WordPlay_Sentence_None"), for: UIControlState())
        playButton.addTarget(self, action: #selector(WCSettingContentView.playButtonAction(_:)), for: UIControlEvents.touchUpInside)

        //FIXME: 第一版還不用打開單字卡，因為現在的單字褲沒有例句
        // Cycle Button
//        cycleButton = UIButton(frame: CGRectMake(playButton.frame.origin.x, playButton.frame.origin.y + playButton.bounds.height + buttonSpace, 104 * ScreenSizeRatio, 104 * ScreenSizeRatio))
        cycleButton = UIButton(frame: CGRect(x: playButton.frame.origin.x, y: playButton.frame.origin.y + playButton.bounds.height + buttonSpace * 1.5, width: 104 * ScreenSizeRatio, height: 104 * ScreenSizeRatio))
        cycleButton.tag = 1
        cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Once"), for: UIControlState())
        cycleButton.addTarget(self, action: #selector(WCSettingContentView.cycleButtonAction(_:)), for: UIControlEvents.touchUpInside)

        //FIXME: 第一版還不用打開單字卡，因為現在的單字褲沒有例句
        // SentenceButton
//        sentenceButton = UIButton(frame: CGRectMake(playButton.frame.origin.x, cycleButton.frame.origin.y + cycleButton.bounds.height + buttonSpace, 104 * ScreenSizeRatio, 104 * ScreenSizeRatio))
//        sentenceButton.tag = 2
//        sentenceButton.setBackgroundImage(UIImage(named: "WordPlay_Sentence_None"), forState: UIControlState.Normal)
//        sentenceButton.addTarget(self, action: #selector(WCSettingContentView.sentenceButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(playButton)
        self.addSubview(cycleButton)
//        self.addSubview(sentenceButton)
    }

    // Title Labels
    fileprivate func initialTitleLabels() {
        let labelTopSpace = (self.bounds.size.height - (40 * 4)) / 5
        let labelLeftSpace = self.bounds.size.width / 3

        let secondLabel = UILabel(frame: CGRect(x: labelLeftSpace, y: labelTopSpace, width: 80, height: 40))
        secondLabel.numberOfLines = 2
        secondLabel.font = UIFont(name: "Futura", size: 14.0)
        secondLabel.textAlignment = NSTextAlignment.center
        secondLabel.textColor = UIColor.white
        secondLabel.text = "間隔秒數second"

        let frequencyLabel = UILabel(frame: CGRect(x: labelLeftSpace, y: labelTopSpace * 2 + 40, width: 80, height: 40))
        frequencyLabel.numberOfLines = 2
        frequencyLabel.font = UIFont(name: "Futura", size: 14.0)
        frequencyLabel.textAlignment = NSTextAlignment.center
        frequencyLabel.textColor = UIColor.white
        frequencyLabel.text = "播放次數frequency"

        let speedLabel = UILabel(frame: CGRect(x: labelLeftSpace, y: labelTopSpace * 3 + 80, width: 80, height: 40))
        speedLabel.numberOfLines = 2
        speedLabel.font = UIFont(name: "Futura", size: 14.0)
        speedLabel.textAlignment = NSTextAlignment.center
        speedLabel.textColor = UIColor.white
        speedLabel.text = "播放速度speed"

        let playTimeLabel = UILabel(frame: CGRect(x: labelLeftSpace, y: labelTopSpace * 4 + 120, width: 80, height: 40))
        playTimeLabel.numberOfLines = 2
        playTimeLabel.font = UIFont(name: "Futura", size: 14.0)
        playTimeLabel.textAlignment = NSTextAlignment.center
        playTimeLabel.textColor = UIColor.white
        playTimeLabel.text = "播放時間play-time"

        self.addSubview(secondLabel)
        self.addSubview(frequencyLabel)
        self.addSubview(speedLabel)
        self.addSubview(playTimeLabel)
    }

    // Content Labels
    fileprivate func initialContentLabels() {
        let viewTopSpace = (self.bounds.size.height - (40 * 4)) / 5
        let viewLeftSpace = self.bounds.size.width / 3 * 2 - 20
        let backgroundViewSize = CGSize(width: 189 * ScreenSizeRatio, height: 60.5 * ScreenSizeRatio)
        let viewMiddleSpace = ((self.bounds.size.height - (2 * viewTopSpace)) - (backgroundViewSize.height * 4)) / 3
        
        // ------------------------------------------------------------------------------------------------
        // Second
        let secondView = UIView(frame: CGRect(x: viewLeftSpace, y: viewTopSpace, width: backgroundViewSize.width, height: backgroundViewSize.height))
        secondView.backgroundColor = UIColor.white
        secondView.layer.cornerRadius = secondView.bounds.height / 2

        secondLabel = UILabel(frame: CGRect(x: 0, y: 0, width: secondView.bounds.size.width, height: secondView.bounds.size.height))
        secondLabel.numberOfLines = 1
        secondLabel.font = UIFont(name: "Futura", size: 30.0)
        secondLabel.textAlignment = NSTextAlignment.center
        secondLabel.textColor = UIColor.black
        secondLabel.text = String((settingContentModel?.secondDetailAdjust)!)

        secondView.addSubview(secondLabel)
        self.addDetailAdjustButtonFrom(secondView, AndContentTag: 0)

        // ------------------------------------------------------------------------------------------------
        // Frequency
        let frequencyView = UIView(frame: CGRect(x: viewLeftSpace, y: viewTopSpace + backgroundViewSize.height + viewMiddleSpace, width: backgroundViewSize.width, height: backgroundViewSize.height))
        frequencyView.backgroundColor = UIColor.white
        frequencyView.layer.cornerRadius = frequencyView.bounds.height / 2

        frequencyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: secondView.bounds.size.width, height: secondView.bounds.size.height))
        frequencyLabel.numberOfLines = 1
        frequencyLabel.font = UIFont(name: "Futura", size: 30.0)
        frequencyLabel.textAlignment = NSTextAlignment.center
        frequencyLabel.textColor = UIColor.black
        frequencyLabel.text = String((settingContentModel?.frequencyDetailAdjiust)!)

        frequencyView.addSubview(frequencyLabel)
        self.addDetailAdjustButtonFrom(frequencyView, AndContentTag: 1)


        // ------------------------------------------------------------------------------------------------
        // Speed
        let speedView = UIView(frame: CGRect(x: viewLeftSpace, y: viewTopSpace + backgroundViewSize.height * 2 + viewMiddleSpace * 2, width: backgroundViewSize.width, height: backgroundViewSize.height))
        speedView.backgroundColor = UIColor.white
        speedView.layer.cornerRadius = speedView.bounds.height / 2

        speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: secondView.bounds.size.width, height: secondView.bounds.size.height))
        speedLabel.numberOfLines = 1
        speedLabel.font = UIFont(name: "Futura", size: 30.0)
        speedLabel.textAlignment = NSTextAlignment.center
        speedLabel.textColor = UIColor.black
        speedLabel.text = String((settingContentModel?.speedDetailAdjust)!)

        speedView.addSubview(speedLabel)
        self.addDetailAdjustButtonFrom(speedView, AndContentTag: 2)


        // ------------------------------------------------------------------------------------------------
        // Time
        let timeView = UIView(frame: CGRect(x: viewLeftSpace, y: viewTopSpace + backgroundViewSize.height * 3 + viewMiddleSpace * 3, width: backgroundViewSize.width, height: backgroundViewSize.height))
        timeView.backgroundColor = UIColor.white
        timeView.layer.cornerRadius = timeView.bounds.height / 2

        playTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: timeView.bounds.size.width, height: timeView.bounds.size.height))
        playTimeLabel.numberOfLines = 1
        playTimeLabel.font = UIFont(name: "Futura", size: 30.0)
        playTimeLabel.textAlignment = NSTextAlignment.center
        playTimeLabel.textColor = UIColor.black
        playTimeLabel.text = String((settingContentModel?.playTimeDetailAdjust)!)

        timeView.addSubview(playTimeLabel)
        self.addDetailAdjustButtonFrom(timeView, AndContentTag: 3)

        self.addSubview(secondView)
        self.addSubview(frequencyView)
        self.addSubview(speedView)
        self.addSubview(timeView)
    }

    fileprivate func addDetailAdjustButtonFrom(_ contentBackgroundView : UIView, AndContentTag contentTag : Int) {
        let adjustButtonSize = CGSize(width: contentBackgroundView.bounds.height / 2 + 4, height: contentBackgroundView.bounds.height / 2 + 4)
        
        let minusButton = UIButton(frame: CGRect(x: adjustButtonSize.width / 4, y: (contentBackgroundView.bounds.height / 2) - adjustButtonSize.height / 2, width: adjustButtonSize.width, height: adjustButtonSize.height))
        minusButton.setBackgroundImage(UIImage(named: "WordPlay_Minus"), for: UIControlState())
        minusButton.tag = contentTag
        minusButton.addTarget(self, action: #selector(WCSettingContentView.minusDetailAdjustButtonAction(_:)), for:  UIControlEvents.touchUpInside)

        let plusButton = UIButton(frame: CGRect(x: contentBackgroundView.bounds.width - adjustButtonSize.width / 4 * 5, y: (contentBackgroundView.bounds.height / 2) - adjustButtonSize.height / 2, width: adjustButtonSize.width, height: adjustButtonSize.height))
        plusButton.setBackgroundImage(UIImage(named: "WordPlay_Plus"), for: UIControlState())
        plusButton.tag = contentTag
        plusButton.addTarget(self, action: #selector(WCSettingContentView.plusDetailAdjustButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        contentBackgroundView.addSubview(minusButton)
        contentBackgroundView.addSubview(plusButton)
    }

    // MARK: - Set SettingContentModal
    /**
    Set WCSettingContentModel of WCSettingContentView
    
    - parameter contentModel: WCSettingContentModel
    */
    func setSettingContentModal(_ contentModel : WCSettingContentModel) {
        settingContentModel = contentModel
        if (contentModel.setPlay == SetPlayType.sequential) {
            playButton.setBackgroundImage(UIImage(named: "WordPlay_Play_Sequential"), for: UIControlState())
        }
        else {
            playButton.setBackgroundImage(UIImage(named: "WordPlay_Play_Random"), for: UIControlState())
        }
        
        if (settingContentModel?.setPlay == SetPlayType.sequential) {
            playButton.setBackgroundImage(UIImage(named: "WordPlay_Play_Sequential"), for: UIControlState())
        }
        else {
            playButton.setBackgroundImage(UIImage(named: "WordPlay_Play_Random"), for: UIControlState())
        }
        
        // SetCycleType
        if(contentModel.setCycle.rawValue <= 4) {
            switch (contentModel.setCycle.rawValue) {
                case SetCycleType.infinity.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Infinity"), for: UIControlState())
                    break
                case SetCycleType.once.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Once"), for: UIControlState())
                    break
                
                case SetCycleType.twice.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Twice"), for: UIControlState())
                    break
                
                case SetCycleType.thrice.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Thrice"), for: UIControlState())
                    break
                
                case SetCycleType.fourTimes.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_FourTimes"), for: UIControlState())
                    break
                
                default :
                    break
            }
        }
        
        // SetSentenceType
        if(contentModel.setSentence == SetSentenceType.noneSentence) {
//            sentenceButton.setBackgroundImage(UIImage(named: "WordPlay_Sentence_None"), forState: UIControlState.Normal)
            
        }
        else {
//            sentenceButton.setBackgroundImage(UIImage(named: "WordPlay_Sentence_English"), forState: UIControlState.Normal)
        }
        
        // Set detail adjust label text
        secondLabel.text = String(contentModel.secondDetailAdjust)
        
        frequencyLabel.text = String(contentModel.frequencyDetailAdjiust)
        
        speedLabel.text = String(contentModel.speedDetailAdjust)
        
        playTimeLabel.text = String(contentModel.playTimeDetailAdjust)
    }

    // MARK: - Lefty Buttons action
    @objc fileprivate func playButtonAction(_ sender: UIButton) {
        if (settingContentModel?.setPlay == SetPlayType.sequential) {
            playButton.setBackgroundImage(UIImage(named: "WordPlay_Play_Random"), for: UIControlState())
            settingContentModel?.setPlay = SetPlayType.random
        }
        else {
            playButton.setBackgroundImage(UIImage(named: "WordPlay_Play_Sequential"), for: UIControlState())
            settingContentModel?.setPlay = SetPlayType.sequential
        }
        delegate.didSetContentModel(settingContentModel!)
    }

    @objc fileprivate func cycleButtonAction(_ sender : UIButton) {
        if(settingContentModel?.setCycle.rawValue < 4) {
            settingContentModel?.setCycle = SetCycleType(rawValue: (settingContentModel?.setCycle.rawValue)! + 1)
            switch ((settingContentModel?.setCycle.rawValue)!) {
                case SetCycleType.once.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Once"), for: UIControlState())
                    break
                
                case SetCycleType.twice.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Twice"), for: UIControlState())
                    break
                
                case SetCycleType.thrice.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Thrice"), for: UIControlState())
                    break
                
                case SetCycleType.fourTimes.rawValue :
                    cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_FourTimes"), for: UIControlState())
                    break
                
                default :
                    break
            }
        }
        else {
            settingContentModel?.setCycle = SetCycleType.infinity
            cycleButton.setBackgroundImage(UIImage(named: "WordPlay_Cycle_Infinity"), for: UIControlState())
        }
        delegate.didSetContentModel(settingContentModel!)
    }
    
    @objc fileprivate func sentenceButtonAction(_ sender: UIButton) {
        if(settingContentModel?.setSentence == SetSentenceType.noneSentence) {
            //FIXME: 第一版還不用打開單字卡，因為現在的單字褲沒有例句
//            sentenceButton.setBackgroundImage(UIImage(named: "WordPlay_Sentence_English"), forState: UIControlState.Normal)
            settingContentModel?.setSentence = SetSentenceType.englishSentence
        }
        else {
            //FIXME: 第一版還不用打開單字卡，因為現在的單字褲沒有例句
//            sentenceButton.setBackgroundImage(UIImage(named: "WordPlay_Sentence_None"), forState: UIControlState.Normal)
            settingContentModel?.setSentence = SetSentenceType.noneSentence
        }
        delegate.didSetContentModel(settingContentModel!)
    }

    // MARK: - Detail adjust Minus and Plus buttons action
    @objc fileprivate func minusDetailAdjustButtonAction(_ sender : UIButton) {
        switch(sender.tag) {
            case 0:
                if(settingContentModel?.secondDetailAdjust > 0) {
                    settingContentModel?.secondDetailAdjust = (settingContentModel?.secondDetailAdjust)! - 1
                }
                else {
                    settingContentModel?.secondDetailAdjust = 9
                }
                secondLabel.text = String((settingContentModel?.secondDetailAdjust)!)
                break

            case 1:
                if(settingContentModel?.frequencyDetailAdjiust > 1) {
                    settingContentModel?.frequencyDetailAdjiust = (settingContentModel?.frequencyDetailAdjiust)! - 1
                }
                else {
                    settingContentModel?.frequencyDetailAdjiust = 4
                }
                frequencyLabel.text = String((settingContentModel?.frequencyDetailAdjiust)!)
                break

            case 2:
                if(settingContentModel?.speedDetailAdjust > 1) {
                    settingContentModel?.speedDetailAdjust = (settingContentModel?.speedDetailAdjust)! - 1
                }
                else {
                    settingContentModel?.speedDetailAdjust = 2
                }
                speedLabel.text = String((settingContentModel?.speedDetailAdjust)!)
                break

            case 3:
                if(settingContentModel?.playTimeDetailAdjust > 10) {
                    settingContentModel?.playTimeDetailAdjust = (settingContentModel?.playTimeDetailAdjust)! - 1
                }
                else {
                    settingContentModel?.playTimeDetailAdjust = 40
                }
                playTimeLabel.text = String((settingContentModel?.playTimeDetailAdjust)!)
                break

            default:
                break
        }
        delegate.didSetContentModel(settingContentModel!)
    }

    @objc fileprivate func plusDetailAdjustButtonAction(_ sender : UIButton) {
        switch(sender.tag) {
            case 0:
                if (settingContentModel?.secondDetailAdjust < 9) {
                    settingContentModel?.secondDetailAdjust = (settingContentModel?.secondDetailAdjust)! + 1
                }
                else {
                    settingContentModel?.secondDetailAdjust = 0
                }
                secondLabel.text = String((settingContentModel?.secondDetailAdjust)!)
                break

            case 1:
                if (settingContentModel?.frequencyDetailAdjiust < 5) {
                    settingContentModel?.frequencyDetailAdjiust = (settingContentModel?.frequencyDetailAdjiust)! + 1
                }
                else {
                    settingContentModel?.frequencyDetailAdjiust = 1
                }
                frequencyLabel.text = String((settingContentModel?.frequencyDetailAdjiust)!)
                break

            case 2:
                if (settingContentModel?.speedDetailAdjust < 2) {
                    settingContentModel?.speedDetailAdjust = (settingContentModel?.speedDetailAdjust)! + 1
                }
                else {
                    settingContentModel?.speedDetailAdjust = 1
                }
                speedLabel.text = String((settingContentModel?.speedDetailAdjust)!)
                break

            case 3:
                if (settingContentModel?.playTimeDetailAdjust < 40) {
                    settingContentModel?.playTimeDetailAdjust = (settingContentModel?.playTimeDetailAdjust)! + 1
                }
                else {
                    settingContentModel?.playTimeDetailAdjust = 10
                }
                playTimeLabel.text = String((settingContentModel?.playTimeDetailAdjust)!)
            break

                default:
                    break
        }
        delegate.didSetContentModel(settingContentModel!)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
