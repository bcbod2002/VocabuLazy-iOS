//
//  WCListViewModel.swift
//  Swallow
//
//  Created by JerryZ on 2015/10/19.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import Foundation

class WCListViewModel: NSObject, NSCoding {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var name: String
    var content: [UInt]

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        content = aDecoder.decodeObject(forKey: "content") as! [UInt]
        super.init()
    }
    
    init(name: String?, content: [UInt]?) {
        self.name = name ?? String()
        self.content = content ?? [UInt]()
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK - NSCoding protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(content, forKey: "content")
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Override other methods
    override var description: String {
        return "\(name) \(content)"
    }
}
