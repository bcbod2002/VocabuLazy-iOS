//
//  WCWordForegroundHandle.swift
//  Swallow
//
//  Created by Goston on 2016/5/19.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

// ---------------------------------------------------------------------------------------------
// MARK: - WCWordForegroundHandlerDelegate
@objc protocol WCWordForegroundHandlerDelegate {
    /**
     Start play vocabulary
     
     - parameter itemNumber: Item number of Vocabulary array
     */
    @objc optional func playVocabulary(with itemNumber: Int)
    
    /**
     Scroll WCWordPlayTableView to item with animation
     
     - parameter itemNumber: Item number
     */
    @objc optional func tableViewScrollAnimation(_ itemNumber: Int)
    
    /**
     Amplify the item number of WCWordPlayTableViewCell with animation
     
     - parameter itemNumber: Item number
     */
    @objc optional func tableViewCellAmplifyAnimation(_ itemNumber: Int)
    
    /**
     Scroll the sentence of WCWordPlayTableViewCell
     
     - parameter sentenceNumber: Item of sentence number
     */
    @objc optional func tableViewCellScrollAnimation(_ sentenceNumber: Int)
    
    /**
     Scroll WCWordScrollView to item
     
     - parameter itemNumber: Item number
     */
    @objc optional func backgroundViewScrollAnimation(_ itemNumber: Int)
}

class WCWordForegroundHandler: NSObject/*, WCWordGroundHandlerProtocol*/ {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var delegate: WCWordForegroundHandlerDelegate?
    
    var selectedContentModel: WCSettingContentModel?
    var lessonNumber: Int = 0
    var playingNumber: Int = 0
    var sentenceNumber: Int = 0
    var cycleNumber: UInt = 1
    var playedItemArray: [Bool] = [Bool]()
    var playedSentencesArray: [Bool] = [Bool]()
    var isCellOpened: Bool = false
    var playedRandomCount = 0
    var vocabularyPlayedCount: UInt = 1
    
    
    var vocabularyTupleArray: [(String, String)]?
    var sentenceTupleArray: [[(String, String)]]?
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    override init() {
        super.init()
    }
    
    /**
     Initial with Vocabulary array and Sentence array
     
     - parameter vocabularyArray: Vocabulary tuple array
     - parameter sentenceArray:   Sentence tuple array
     */
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
     Increase playing number with delay without check WCWordPlayTableViewCell opend or not
     */
    func increasePlayingNumber() {
        increasePlayingNumber(isCellOpened: false)
    }
    
    /**
     Increase playing number with delay and check WCWordPlayTableViewCell opend or not
     
     - parameter opened: WCWordPlayTableViewCell opend or not
     */
    func increasePlayingNumber(isCellOpened opened: Bool) {
        isCellOpened = opened
        perform(#selector(WCWordForegroundHandler.realIncreasePlayingNumber), with: nil, afterDelay: Double((selectedContentModel?.secondDetailAdjust)!))
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Real increase playing number
    @objc fileprivate func realIncreasePlayingNumber() {
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
    func noneSentenceMode() {
        let oneLessonVocabularyCount = vocabularyTupleArray?.count
        
        if isCellOpened == true {
            clearAllPlayedSentencesArray()
            sentenceNumber += 1
            let oneVocabularySentenceCount = sentenceTupleArray![playingNumber].count
            if sentenceNumber < oneVocabularySentenceCount {
                delegate?.tableViewCellScrollAnimation?(sentenceNumber)
            }
            else {
                sentenceNumber = 0
                playedSentencesArray.removeAll()
                delegate?.tableViewCellAmplifyAnimation?(playingNumber)
            }
            return
        }
        
        if vocabularyPlayedCount < (selectedContentModel?.frequencyDetailAdjiust)! && playedItemArray[playingNumber] == false{
            delegate?.playVocabulary?(with: playingNumber)
            vocabularyPlayedCount += 1
        }
        else {
            vocabularyPlayedCount = 1
            playedItemArray[playingNumber] = true
            if selectedContentModel?.setPlay == SetPlayType.sequential  {
                sentenceModeMoveToNext(oneLessonVocabularyCount!)
            }
            else {
                sentenceModeRandomMoveToNext(oneLessonVocabularyCount!)
            }
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
        clearAllPlayedSentencesArray()
        
        if  playingNumber < oneLessonVocabularyCount! {
            if isItemPlayed == false {
                if vocabularyPlayedCount < (selectedContentModel?.frequencyDetailAdjiust)! {
                    delegate?.playVocabulary?(with: playingNumber)
                    vocabularyPlayedCount += 1
                }
                else {
                    if sentenceNumber == 0 && playedSentencesArray[0] == false {
                        // 狀態 : 未開啟 cell
                        delegate?.tableViewCellAmplifyAnimation?(playingNumber)
                        playedSentencesArray[0] = true
                    }
                    else {
                        // 狀態 : 已開啟 cell
                        // 播放到第二個例句後，滑回第一個例句，還是會自動關閉例句卡片
                        sentenceNumber += 1
                        let oneVocabularySentenceCount = sentenceTupleArray![playingNumber].count
                        if sentenceNumber < oneVocabularySentenceCount {
                            // 狀態 : 未念完例句
                            //                        playedSentencesArray[sentenceNumber] = true
                            delegate?.tableViewCellScrollAnimation?(sentenceNumber)
                        }
                        else {
                            // 狀態 : 已念完例句
                            vocabularyPlayedCount = 1
                            sentenceNumber = 0
                            playedItemArray[playingNumber] = true
                            playedSentencesArray.removeAll()
                            delegate?.tableViewCellAmplifyAnimation?(playingNumber)
                        }
                    }
                }
            }
            else {
                if selectedContentModel?.setPlay == SetPlayType.sequential {
                    sentenceModeMoveToNext(oneLessonVocabularyCount!)
                }
                else {
                    sentenceModeRandomMoveToNext(oneLessonVocabularyCount!)
                }
            }
        }
    }
    
    /**
     All Sentence which in One Vocabulary has been played continue to play the next Vocabulary
     
     - parameter oneLessonVocabularyCount: Vocabulary count in one Lesson
     */
    func sentenceModeMoveToNext(_ oneLessonVocabularyCount: Int) {
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
                    delegate?.tableViewScrollAnimation?(playingNumber)
                }
                else {
                    cycleNumber = 1
                    lessonNumber += 1
                    delegate?.backgroundViewScrollAnimation?(lessonNumber)
                }
                
                break
            }
        }
        else {
            delegate?.tableViewScrollAnimation?(playingNumber)
        }
    }
    
    /**
     <#Description#>
     
     - parameter oneLessonVocabularyCount: <#oneLessonVocabularyCount description#>
     */
    func sentenceModeRandomMoveToNext(_ oneLessonVocabularyCount: Int)  {
        if checkAllPlayedItemIsPlayed() == true {
            switch (selectedContentModel?.setCycle)! {
            case SetCycleType.infinity:
                clearAllPlayedItemsArray()
                break
            default:
                clearAllPlayedItemsArray()
                playingNumber = createRandomNumber()
                let selectedCycleNumber = selectedContentModel?.setCycle.rawValue
                if cycleNumber < selectedCycleNumber! {
                    cycleNumber += 1
                    delegate?.tableViewScrollAnimation?(playingNumber)
                }
                else {
                    cycleNumber = 1
                    lessonNumber += 1
                    delegate?.backgroundViewScrollAnimation?(lessonNumber)
                }
                
                break
            }
        }
        else {
            playingNumber = createRandomNumber()
            //            playedItemArray[playingNumber] = true
            delegate?.tableViewScrollAnimation?(playingNumber)
            
            playedRandomCount += 1
        }
    }
    
    /**
     <#Description#>
     
     - returns: <#return value description#>
     */
    func checkAllPlayedItemIsPlayed() -> Bool{
        for playedItem in playedItemArray {
            if playedItem == false {
                return false
            }
        }
        return true
    }
    
    /**
     <#Description#>
     */
    func clearAllPlayedItemsArray() {
        if vocabularyTupleArray != nil {
            for index in 0 ... vocabularyTupleArray!.count - 1 {
                playedItemArray[index] = false
            }
            playedRandomCount = 0
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Create a random number
    /**
     Get a random number
     
     - returns: Random number
     */
    func createRandomNumber() -> Int {
        //FIXME: 現在的方法是根據 playedItemArray.count 來產生 小於 playedItemArray.count 的亂數
        //       但由於超過 playedItemArray.count 的一半後，取得未被播放的亂數較為困難
        //       所以在超過一半後，就直接回傳從第0個開始播放未被播放過的 數字
        if playedRandomCount <= (playedItemArray.count / 2) {
            var randomNumber = Int(arc4random_uniform(UInt32(playedItemArray.count - 1)))
            while playedItemArray[randomNumber] == true {
                randomNumber = Int(arc4random_uniform(UInt32(playedItemArray.count - 1)))
            }
            return randomNumber
        }
        else {
            for isPlayedItem in playedItemArray {
                if isPlayedItem == false {
                    return playedItemArray.index(of: isPlayedItem)!
                }
            }
            return playedItemArray.count - 1
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - playedSentencesArray operation
    /**
     Set all of items in playedSentencesArray false
     */
    func clearAllPlayedSentencesArray() {
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
     It's not set all of items in playedSentencesArray true. It's set playedItemArray which played true
     */
    func fullPlayedSentencesArray() {
        sentenceNumber = 0
        playedItemArray[playingNumber] = true
        playedSentencesArray.removeAll()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - All property operation
    /**
     Reset all property and set lesson, vocabulary array and sentence array
     
     - parameter lesson:          Now leeson
     - parameter vocabularyArray: Vocabulary array
     - parameter sentenceArray:   Sentence array
     */
    func resetAllProperty(_ lesson: Int, vocabularyArray: [(String, String)], sentenceArray: [[(String, String)]]) {
        lessonNumber = lesson
        playingNumber = 0
        sentenceNumber = 0
        cycleNumber = 1
        isCellOpened = false
        
        setAllTupleArray(vocabularyArray, sentenceArray: sentenceArray)
    }
    
    /**
     Use WCWordBackgroundHandler to set WCWordForegroundHandler
     
     - parameter backgroundHandler: WCWordBackgroundHandler
     */
    func setGroundHandler(with backgroundHandler: WCWordBackgroundHandler) {
        selectedContentModel = backgroundHandler.selectedContentModel
        lessonNumber = backgroundHandler.lessonNumber
        playingNumber = backgroundHandler.playingNumber
        sentenceNumber = backgroundHandler.sentenceNumber
        cycleNumber = backgroundHandler.cycleNumber
        playedRandomCount = backgroundHandler.playedRandomCount
        vocabularyPlayedCount = backgroundHandler.vocabularyPlayedCount
        
        playedItemArray = backgroundHandler.playedItemArray
        playedSentencesArray = backgroundHandler.playedSentencesArray
        
        vocabularyTupleArray = backgroundHandler.vocabularyTupleArray
        sentenceTupleArray = backgroundHandler.sentenceTupleArray
    }
}
