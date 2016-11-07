//
//  WCWordSpeechPlayer.swift
//  Swallow
//
//  Created by Goston on 2016/5/19.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - WCWordSpeechLanguage
enum WCWordSpeechLanguage: String {
    case English = "en-US"
    case Chinese = "zh-TW"
}

class WCWordSpeechPlayer: NSObject {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var speechSynthesizer = AVSpeechSynthesizer()
    
    var isSpeech: Bool = false
    var isPaused: Bool = false
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required override init() {
        super.init()
    }
    
    /**
     初始化 WCWordSpeechPlayer 並且設定 Delegate
     
     - parameter delegate: AVSpeechSynthesizerDelegate
     */
    convenience init(withDelegate delegate: AVSpeechSynthesizerDelegate) {
        self.init()
        activeBackgroundSpeech()
        enableReceivingRemoteControlEvents(true)
        speechSynthesizer.delegate = delegate
        
        judgeString("qqq")
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Background speech
    /**
     啟動背景播放
     */
    fileprivate func activeBackgroundSpeech() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(true, with: .notifyOthersOnDeactivation)
            }
            catch let error as NSError {
                printLog("Active Error = ", error.localizedDescription)
            }
        }
        catch let error as NSError {
            printLog("Category error = ", error.localizedDescription)
        }
    }
    
    fileprivate func enableReceivingRemoteControlEvents(_ isEnable: Bool) {
        if isEnable == true {
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
        else {
            UIApplication.shared.endReceivingRemoteControlEvents()
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Speech action
    /**
     開始唸出 單字 或 句子
     
     - parameter speechString: 單字或句子
     - parameter language:     語系
     */
    func startSpeech(speechString: String, language: WCWordSpeechLanguage, speechSpeed: Float = 0.4) {
        if speechSynthesizer.isSpeaking == true {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        let speechUtterance = AVSpeechUtterance(string: speechString)
        let speechSynthesisVoice = AVSpeechSynthesisVoice(language: language.rawValue)
        
        speechUtterance.voice = speechSynthesisVoice
//        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        switch speechSpeed {
            case 1:
                let actualSpeechSpeed = speechSpeed * 0.4
                speechUtterance.rate = actualSpeechSpeed
                break
            case 2:
                let actualSpeechSpeed = speechSpeed * 0.275
                speechUtterance.rate = actualSpeechSpeed
                break
            default:
                speechUtterance.rate = speechSpeed
        }
        speechUtterance.volume = 1
        
        speechSynthesizer.speak(speechUtterance)
        
        isSpeech = true
    }
    
    /**
     停止唸出 單字 或 句子
     */
    func stopSpeech() {
        if speechSynthesizer.isSpeaking == true {
            
            // 立即中斷可能會失敗，所以需要再次停止
            let speechStopped = speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            if speechStopped == false {
                speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            }
            
            isSpeech = false
        }
    }
    
    /**
     暫停唸出 單字 或 句子
     */
    func pauseSpeech() {
        if speechSynthesizer.isSpeaking == true || speechSynthesizer.isPaused == false {
            
            let speechPaused = speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
            if speechPaused == false {
                speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            }
            
            isSpeech = false
            isPaused = true
        }
    }
    
    /**
     繼續唸出未念完的 單字 或 句子
     */
    func continueSpeech() {
        if speechSynthesizer.isPaused == true {
            let speechContinued = speechSynthesizer.continueSpeaking()
            if speechContinued == false {
                speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            }
            
            isSpeech = true
            isPaused = false
        }
    }
    
    //TODO: 這邊還需要修改，將來要改成能夠根據 speechString 來判斷現在要撥出什麼語系
    fileprivate func judgeString(_ speechString: String) -> WCWordSpeechLanguage {
        let japaneseString = "はいけません"
        let chhineseString = "不回家"
        let length = speechString.characters.count
        
        NSLinguisticTagSchemeLanguage
        
        printLog("japaneseString = ", japaneseString.characters)
        printLog("chhineseString = ", chhineseString.characters)
        
        
        return WCWordSpeechLanguage.Chinese
    }
    
    deinit {
        enableReceivingRemoteControlEvents(false)
    }
}
