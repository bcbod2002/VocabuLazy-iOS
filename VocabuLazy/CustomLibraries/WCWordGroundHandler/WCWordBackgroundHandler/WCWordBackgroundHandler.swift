//
//  WCWordBackgroundHandle.swift
//  Swallow
//
//  Created by Goston on 2016/5/19.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

//TODO: 隨機模式還沒做、也需要重構
// ---------------------------------------------------------------------------------------------
// MARK: - WCWordBackgroundHandlerDelegate
@objc protocol WCWordBackgroundHandlerDelegate {
    /**
     Start play vocabulary
     
     - parameter itemNumber: Item number of Vocabulary array
     */
    @objc optional func playVocabulary(with itemNumber: Int)
    
    /**
     Start play sentenceNumber
     
     - parameter vNumber: Item number of Vocabulary array
     - parameter sNumber: Item number of Sentence array
     */
    @objc optional func playSentence(vocabularyNumber vNumber: Int, sentenceNumber sNumber: Int)
    
    /**
     Read Vocabulary and Sentence data
     
     - parameter lessonNumber: Number of lesson
     */
    @objc optional func readVocabularyData(with lessonNumber: Int)
}

class WCWordBackgroundHandler: NSObject, WCWordGroundHandlerProtocol {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var delegate: WCWordBackgroundHandlerDelegate?
    
    var selectedContentModel: WCSettingContentModel?
    var lessonNumber: Int = 0
    var playingNumber: Int = 0
    var sentenceNumber: Int = 0
    var isSentence: Bool = false
    var cycleNumber: UInt = 0
    var playedItemArray: [Bool] = [Bool]()
    var playedSentencesArray:[Bool] = [Bool]()
    var playedRandomCount = 0
    var vocabularyPlayedCount: UInt = 1
    
    var vocabularyTupleArray: [(String, String)]?
    var sentenceTupleArray: [[(String, String)]]?
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    override init() {
        super.init()
    }
    
    required init?(vocabularyArray: [(String, String)], sentenceArray: [[(String, String)]]) {
        super.init()
        setAllTupleArray(vocabularyArray, sentenceArray: sentenceArray)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Set Vocabulary and Sentence
    /**
     Set All Vocabulary array and Sentence array
     
     - parameter vocabularyArray: Vocabulary array
     - parameter sentenceArray:   Sentence array
     */
    func setAllTupleArray(_ vocabularyArray: [(String, String)], sentenceArray: [[(String, String)]]) {
        vocabularyTupleArray = vocabularyArray
        sentenceTupleArray = sentenceArray
        
        playedItemArray.removeAll()
        
        if vocabularyArray.count > 0 {
            for _ in 1...vocabularyArray.count {
                playedItemArray.append(false)
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Increase playing number
    /**
     Increase playing number with delay
     */
    func increasePlayingNumber() {
        perform(#selector(WCWordBackgroundHandler.realIncreasePlayingNumber), with: nil, afterDelay: Double((selectedContentModel?.secondDetailAdjust)!))
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Real increase playing number
    /**
     <#Description#>
     */
    func realIncreasePlayingNumber() {
        if selectedContentModel?.setCycle == SetCycleType.infinity {
            cycleInfinite()
        }
        else {
            cycleFinite()
        }
    }
    
    func cycleInfinite() {
        switch (selectedContentModel?.setSentence)! {
        case .noneSentence:
            noneSentenceMode()
            break
        case .englishSentence:
            sentenceMode()
            break
        }
    }
    
    func cycleFinite() {
        switch (selectedContentModel?.setSentence)! {
        case .noneSentence:
            noneSentenceMode()
            break
        case .englishSentence:
            sentenceMode()
            break
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Vocabulary mode
    /**
     Vocabulary finite state machine
     */
    func noneSentenceMode() {
        let oneLessonVocabularyCount = vocabularyTupleArray?.count
        
        if playingNumber < oneLessonVocabularyCount! - 1 {
            if vocabularyPlayedCount < (selectedContentModel?.frequencyDetailAdjiust)! {
                delegate?.playVocabulary?(with: playingNumber)
                vocabularyPlayedCount += 1
            }
            else {
                vocabularyPlayedCount = 1
                playingNumber = playingNumber + 1
                // Play audio
                
                delegate?.playVocabulary?(with: playingNumber)
            }
        }
        else {
            switch (selectedContentModel?.setCycle)! {
            case SetCycleType.infinity:
                playingNumber = 0
                break
            default:
                playingNumber = 0
                let selectedCycleNumber = selectedContentModel?.setCycle.rawValue
                if cycleNumber < selectedCycleNumber! {
                    cycleNumber += 1
                }
                else {
                    cycleNumber = 1
                    lessonNumber += 1
                    // Play Audio
                    // FIXME: 要切換到下一個 Lesson
                    delegate?.readVocabularyData?(with: lessonNumber)
                }
                break
            }
            // Play Audio
            
            delegate?.playVocabulary?(with: 0)
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Sentence mode
    /**
     Sentence finite state machine
     */
    func sentenceMode() {
        let oneLessonVocabularyCount = vocabularyTupleArray?.count
        let isItemPlayed = playedItemArray[playingNumber]
        setPlayedSentencesArray()
        
        if  playingNumber < oneLessonVocabularyCount! {
            if isItemPlayed == false {
                if vocabularyPlayedCount < (selectedContentModel?.frequencyDetailAdjiust)! {
                    delegate?.playVocabulary?(with: playingNumber)
                    vocabularyPlayedCount += 1
                }
                else {
                    if sentenceNumber == 0 && playedSentencesArray[0] == false {
                        // 狀態 : 開始播放第一個例句
                        delegate?.playSentence?(vocabularyNumber: playingNumber, sentenceNumber: 0)
                        playedSentencesArray[0] = true
                        isSentence = true
                    }
                    else {
                        // 狀態 : 已開啟 cell
                        sentenceNumber += 1
                        let oneVocabularySentenceCount = sentenceTupleArray![playingNumber].count
                        if sentenceNumber < oneVocabularySentenceCount {
                            // 狀態 : 開始播放第二個例句
                            delegate?.playSentence?(vocabularyNumber: playingNumber, sentenceNumber: sentenceNumber)
                            isSentence = true
                        }
                        else {
                            // 狀態 : 已念完例句
                            vocabularyPlayedCount = 1
                            sentenceNumber = 0
                            playedItemArray[playingNumber] = true
                            playedSentencesArray.removeAll()
                            // 狀態 : 播放單字去
                            allSentenceFinished(vocabularyCount: oneLessonVocabularyCount!)
                            isSentence = false
                        }
                    }
                }
            }
        }
    }
    
    /**
     All Sentence which in One Vocabulary has been played continue to play the next Vocabulary
     
     - parameter oneLessonVocabularyCount: Vocabulary count in one Lesson
     */
    fileprivate func allSentenceFinished(vocabularyCount oneLessonVocabularyCount: Int) {
        // 狀態 : 例句已全數撥完
        playingNumber += 1
        if playingNumber >= oneLessonVocabularyCount {
            switch (selectedContentModel?.setCycle)! {
            case SetCycleType.infinity:
                playingNumber = 0
                break
            default:
                playingNumber = 0
                let selectedCycleNumber = selectedContentModel?.setCycle.rawValue
                if cycleNumber < selectedCycleNumber! {
                    cycleNumber += 1
                }
                else {
                    cycleNumber = 1
                    lessonNumber += 1
                    // 狀態 : 要播放下一個 Unit 的單字
                    delegate?.readVocabularyData?(with: lessonNumber)
                    delegate?.playVocabulary?(with: 0)
                }
                break
            }
        }
        else {
            // 狀態 : 要播放同一 Unit 的單字
            delegate?.playVocabulary?(with: playingNumber)
        }
    }
    
    /**
     If playedSentencesArray is empty put new Sentence in it
     */
    func setPlayedSentencesArray() {
        if playedSentencesArray.count == 0 {
            if sentenceTupleArray != nil {
                let singleSentenceTupleArray = sentenceTupleArray![playingNumber]
                playedSentencesArray = singleSentenceTupleArray.map({ (chinese, english) -> Bool in
                    return false
                })
            }
        }
    }
    
    /**
     <#Description#>
     */
    func sequentialListIncrease() {
        switch (selectedContentModel?.setCycle)! {
        case .infinity:
            cycleNumber = 0
        default:
            cycleNumber += 1
        }
    }
    
    /**
     <#Description#>
     */
    func clearAllPlayedItemsArray() {
        if vocabularyTupleArray != nil {
            for _ in 1 ... vocabularyTupleArray!.count {
                //                playedItemArray[index] = false
            }
        }
    }
    
    /**
     Use WCWordForegroundHandler to set WCWordBackgroundHandler
     
     - parameter foregroundHandler: WCWordForegroundHandler
     */
    func setGroundHandler(with foregroundHandler: WCWordForegroundHandler) {
        selectedContentModel = foregroundHandler.selectedContentModel
        lessonNumber = foregroundHandler.lessonNumber
        playingNumber = foregroundHandler.playingNumber
        sentenceNumber = foregroundHandler.sentenceNumber
        cycleNumber = foregroundHandler.cycleNumber
        playedRandomCount = foregroundHandler.playedRandomCount
        vocabularyPlayedCount = foregroundHandler.vocabularyPlayedCount
        
        playedItemArray = foregroundHandler.playedItemArray
        playedSentencesArray = foregroundHandler.playedSentencesArray
        vocabularyTupleArray = foregroundHandler.vocabularyTupleArray
        sentenceTupleArray = foregroundHandler.sentenceTupleArray
    }
}
