//
//  WCVocabularyModel.swift
//  Swallow
//
//  Created by JerryZ on 2015/11/23.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import Foundation

class WCVocabularyModel: NSObject, NSCoding {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var level: UInt = 0
    var identity: UInt = 0
    //-------------------------
    var english: String = ""
    var chinese: String = ""
    //-------------------------
    var englishSentenceArray: NSArray = NSArray()
    var chineseSentenceArray: NSArray = NSArray()
    //-------------------------
    var phonetic: String = ""
    //-------------------------
    var partOfSpeech: String = ""
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        level = aDecoder.decodeObject(forKey: "level") as! UInt
        identity = aDecoder.decodeObject(forKey: "id") as! UInt
        english = aDecoder.decodeObject(forKey: "spell") as! String
        chinese = aDecoder.decodeObject(forKey: "translation") as! String
        englishSentenceArray = aDecoder.decodeObject(forKey: "enSentence") as! NSArray
        chineseSentenceArray = aDecoder.decodeObject(forKey: "cnSentence") as! NSArray
        phonetic = aDecoder.decodeObject(forKey: "phonetic") as! String
        partOfSpeech = aDecoder.decodeObject(forKey: "partOfSpeech") as! String
        
        super.init()
    }
    
    /**
     Initial vocabulary model with mutiple variables
     
     - parameter level:        level
     - parameter identity:     id
     - parameter english:      spell
     - parameter chinese:      translation
     - parameter engSen:       english sentences
     - parameter chnSen:       chinese sentences
     - parameter phonetic:     phonetic
     - parameter partOfSpeech: partOfSpeech
     
     - returns: WCVocabularyModel
     */
    convenience init(level: UInt?, identity: UInt?, english: String?, chinese: String?, engSen: NSArray?, chnSen: NSArray?, phonetic: String?, partOfSpeech: String?)
    {
        self.init()
        
        self.level = level ?? UInt()
        self.identity = identity ?? UInt()
        self.english = english ?? String()
        self.chinese = chinese ?? String()
        self.englishSentenceArray = engSen ?? NSArray()
        self.chineseSentenceArray = chnSen ?? NSArray()
        self.phonetic = phonetic ?? String()
        self.partOfSpeech = partOfSpeech ?? String()
    }
    
    /**
     Initial Vocabulary model with NSDictionary
     
     - parameter vocabularyNSDictionary: NSDictionary from vocabulary.json
     
     - returns: WCVocabularyModel
     */
    convenience init(vocabularyNSDictionary : NSDictionary)
    {
        self.init()
        
        level = vocabularyNSDictionary.object(forKey: "level") as? UInt ?? UInt()
        identity = (vocabularyNSDictionary.object(forKey: "id")) as? UInt ?? UInt()
        english = (vocabularyNSDictionary.object(forKey: "spell")) as? String ?? String()
        chinese = vocabularyNSDictionary.object(forKey: "translation") as? String ?? String()
        englishSentenceArray = (vocabularyNSDictionary.object(forKey: "enSentence")) as? NSArray ?? NSArray()
        chineseSentenceArray = (vocabularyNSDictionary.object(forKey: "cnSentence")) as? NSArray ?? NSArray()
        phonetic = (vocabularyNSDictionary.object(forKey: "phonetic")) as? String ?? String()
        partOfSpeech = (vocabularyNSDictionary.object(forKey: "partOfSpeech")) as? String ?? String()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Override other methods
    override var description: String {
        return "\n\(level)\n\(identity)\n\(english)\n\(chinese)\n\(englishSentenceArray)\n\(chineseSentenceArray)\n\(phonetic)\n\(partOfSpeech)"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(level, forKey: "level")
        aCoder.encode(identity, forKey: "id")
        aCoder.encode(english, forKey: "spell")
        aCoder.encode(chinese, forKey: "translation")
        aCoder.encode(englishSentenceArray, forKey: "enSentence")
        aCoder.encode(chineseSentenceArray, forKey: "cnSentence")
        aCoder.encode(phonetic, forKey: "phonetic")
        aCoder.encode(partOfSpeech, forKey: "partOfSpeech")
    }
}
