//
//  WCWordGroundHandlerProtocol.swift
//  Swallow
//
//  Created by Goston on 2016/5/20.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import Foundation

protocol WCWordGroundHandlerProtocol
{
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var selectedContentModel: WCSettingContentModel? {get set}
    var lessonNumber: Int {get set}
    var playingNumber: Int {get set}
    var sentenceNumber: Int {get set}
    var cycleNumber: UInt {get set}
    var playedItemArray: [Bool] {get set}
    var playedSentencesArray: [Bool] {get set}
    
    var vocabularyTupleArray: [(String, String)]? {get set}
    var sentenceTupleArray: [[(String, String)]]? {get set}
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Methods
    /**
     Set Vocabulary array and Sentence array
     */
    func setAllTupleArray(_ vocabularyArray: [(String, String)], sentenceArray: [[(String, String)]])
    
    /**
     Start increase and caculate the next playing number
     */
    func increasePlayingNumber()
    
    /**
     Play the lesson with Infinite
     */
    func cycleInfinite()
    
    /**
     Play the lesson with Finite
     */
    func cycleFinite()
    
    /**
     Only play vocabulary
     */
    func noneSentenceMode()
    
    /**
     Play vicablary and sentence
     */
    func sentenceMode()
}
