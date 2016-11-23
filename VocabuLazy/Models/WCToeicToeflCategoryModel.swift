//
//  WCToeicToeflCategoryModel.swift
//  VocabuLazy
//
//  Created by Goston on 22/11/2016.
//  Copyright © 2016 WishCan. All rights reserved.
//

import Foundation

class WCToeicToeflCategoryModel: NSObject {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var textbookType = ""
    var textbookTitle = ""
    var textbookID: UInt = 0
    var textbookContent = [TextbookContent]()
    
    struct TextbookContent {
        var lessonTitle = ""
        var lessonId: UInt = 0
        var lessonContent = [UInt]()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    override init() {
        super.init()
    }
    
    convenience init(toeicToeflCatrgoryNSDictionary: NSDictionary) {
        self.init()
        
        textbookType = toeicToeflCatrgoryNSDictionary.object(forKey: "textbookType") as? String ?? ""
        textbookTitle = toeicToeflCatrgoryNSDictionary.object(forKey: "textbookTitle") as? String ?? ""
        textbookID = toeicToeflCatrgoryNSDictionary.object(forKey: "textbookID") as? UInt ?? 0
        let textbookContentArray = toeicToeflCatrgoryNSDictionary.object(forKey: "textbookContent") as? [NSDictionary] ?? [NSDictionary]()
        for textbookContent in textbookContentArray {
            let lessonTitle = textbookContent.object(forKey: "lessonTitle") as? String ?? ""
            let lessonId = textbookContent.object(forKey: "lessonId") as? UInt ?? 0
            let lessonContent = textbookContent.object(forKey: "lessonContent") as? [UInt] ?? [UInt]()
            self.textbookContent.append(TextbookContent(lessonTitle: lessonTitle, lessonId: lessonId, lessonContent: lessonContent))
        }
        
    }
    
    override var description: String {
        return ""
    }

}
