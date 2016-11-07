//
//  WCUtility.swift
//  Swallow
//
//  Created by Goston on 2016/10/3.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import Foundation

func printLog(_ message: Any...,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
