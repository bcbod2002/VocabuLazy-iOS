//
//  WCSearchViewModel
//  Swallow
//
//  Created by jerryz on 2015/9/1.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import Foundation

class WCSearchViewModel: NSObject{
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var identity: UInt = 0
    //-------------------------
    var word: String = ""
    var chinese: String = ""

    override init() {
        super.init()
    }
    
    convenience init(identity: UInt?, word: String?, chinese: String?) {
        self.init()
        
        self.identity = identity ?? UInt()
        self.word = word ?? String()
        self.chinese = chinese ?? String()
    }
    
    convenience init(vocabularyNSDictionary: NSDictionary) {
        self.init()
        
        self.identity = (vocabularyNSDictionary.object(forKey: "id")) as? UInt ?? UInt()
        self.word = (vocabularyNSDictionary.object(forKey: "spell")) as? String ?? String()
        self.chinese = vocabularyNSDictionary.object(forKey: "translation") as? String ?? String()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Override other methods
    override var description: String {
        return "\n\(identity)\n\(word)\n\(chinese)"
    }
}
