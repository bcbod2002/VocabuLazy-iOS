//
//  WCSettingContentModel.swift
//  Swallow
//
//  Created by Goston on 2015/11/18.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

enum PatternType : UInt
{
    case customPattern = 0
    case sleepPattern
    case commutingPattern
}

enum SetPlayType : UInt
{
    case random = 0
    case sequential
}

enum SetCycleType : UInt
{
    case infinity = 0
    case once
    case twice
    case thrice
    case fourTimes
}

enum SetSentenceType : UInt
{
    case noneSentence = 0
    case englishSentence
}

enum DetailAdjustType : Int
{
    case secondAdjust = 0;
    case frequencyAdjust
    case speedAdjust
    case timeAdjust
}

class WCSettingContentModel: NSObject, NSCoding
{
    var playPattern : PatternType!;
    var setPlay : SetPlayType!;
    var setCycle : SetCycleType!;
    var setSentence : SetSentenceType!;
    
    var secondDetailAdjust : UInt!;
    var frequencyDetailAdjiust : UInt!;
    var speedDetailAdjust : UInt!;
    var playTimeDetailAdjust : UInt!;
    
    override var description : String
    {
        let descriptionString = "PatternType = " + String(describing: playPattern.rawValue) + "\n" +
                                "SetPlayType = " + String(setPlay.rawValue) + "\n" +
                                "SetCycleType = " + String(setCycle.rawValue) + "\n" +
                                "SetSentenceType = " + String(setSentence.rawValue) + "\n" +
                                "SecondDetailAdjust = " + String(secondDetailAdjust) + "\n" +
                                "FrequencyDetailAdjiust = " + String(frequencyDetailAdjiust) + "\n" +
                                "SpeedDetailAdjust = " + String(speedDetailAdjust) + "\n" +
                                "PlayTimeDetailAdjust = " + String(playTimeDetailAdjust);
        
        return descriptionString;
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init();
        
        NSKeyedUnarchiver.setClass(WCSettingContentModel.self, forClassName: "Swallow.WCSettingContentModel")
        playPattern = PatternType(rawValue: UInt(aDecoder.decodeInteger(forKey: "playPattern")));
        setPlay = SetPlayType(rawValue: UInt(aDecoder.decodeInteger(forKey: "setPlay")));
        setCycle = SetCycleType(rawValue: UInt(aDecoder.decodeInteger(forKey: "setCycle")));
        setSentence = SetSentenceType(rawValue: UInt(aDecoder.decodeInteger(forKey: "setSentence")));
        
        secondDetailAdjust = UInt(aDecoder.decodeInteger(forKey: "secondDetailAdjust"));
        frequencyDetailAdjiust = UInt(aDecoder.decodeInteger(forKey: "frequencyDetailAdjiust"));
        speedDetailAdjust = UInt(aDecoder.decodeInteger(forKey: "speedDetailAdjust"));
        playTimeDetailAdjust = UInt(aDecoder.decodeInteger(forKey: "playTimeDetailAdjust"));
    }
    
    /**
     Initial WCSettingContentModel PatternType, SetPlayType, SetCycleType, SetSentenceType, Delay second, Repeat times, Audio speed, Total play time
     
     - parameter pattern:   PatternType
     - parameter play:      SetPlayType
     - parameter cycle:     SetCycleType
     - parameter sentence:  SetSentenceType
     - parameter second:    Delay second
     - parameter frequency: Repeat times
     - parameter speed:     Audio speed
     - parameter playTime:  Total play time
     
     - returns: WCSettingContentModel
     */
    init(pattern: PatternType?, play: SetPlayType?, cycle: SetCycleType?, sentence: SetSentenceType?, second: UInt?, frequency: UInt?, speed: UInt?, playTime: UInt?)
    {
        
        self.playPattern = pattern ?? PatternType.customPattern;
        self.setPlay = play ?? SetPlayType.sequential;
        self.setCycle = cycle ?? SetCycleType.once;
        self.setSentence = sentence ?? SetSentenceType.noneSentence;
        
        self.secondDetailAdjust = second ?? 1;
        self.frequencyDetailAdjiust = frequency ?? 1;
        self.speedDetailAdjust = speed ?? 1;
        self.playTimeDetailAdjust = playTime ?? 1;
    }
    
     func encode(with aEnCoder: NSCoder)
    {
        aEnCoder.encode(Int(playPattern.rawValue), forKey: "playPattern");
        aEnCoder.encode(Int(setPlay.rawValue), forKey: "setPlay");
        aEnCoder.encode(Int(setCycle.rawValue), forKey: "setCycle");
        aEnCoder.encode(Int(setSentence.rawValue), forKey: "setSentence");
        
        aEnCoder.encode(Int(secondDetailAdjust), forKey: "secondDetailAdjust");
        aEnCoder.encode(Int(frequencyDetailAdjiust), forKey: "frequencyDetailAdjiust");
        aEnCoder.encode(Int(speedDetailAdjust), forKey: "speedDetailAdjust");
        aEnCoder.encode(Int(playTimeDetailAdjust), forKey: "playTimeDetailAdjust");
    }
    
    func decodeWithCoder(_ aDecoder: NSCoder)
    {
        playPattern = PatternType(rawValue: UInt(aDecoder.decodeInteger(forKey: "playPattern")));
        setPlay = SetPlayType(rawValue: UInt(aDecoder.decodeInteger(forKey: "setPlay")));
        setCycle = SetCycleType(rawValue: UInt(aDecoder.decodeInteger(forKey: "setCycle")));
        setSentence = SetSentenceType(rawValue: UInt(aDecoder.decodeInteger(forKey: "setSentence")));
        
        secondDetailAdjust = UInt(aDecoder.decodeInteger(forKey: "secondDetailAdjust"));
        frequencyDetailAdjiust = UInt(aDecoder.decodeInteger(forKey: "frequencyDetailAdjiust"));
        speedDetailAdjust = UInt(aDecoder.decodeInteger(forKey: "speedDetailAdjust"));
        playTimeDetailAdjust = UInt(aDecoder.decodeInteger(forKey: "playTimeDetailAdjust"));
    }
}
