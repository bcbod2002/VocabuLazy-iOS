//
//  StorageManager.swift
//  Swallow
//
//  Created by jerryz on 2015/9/1.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import Foundation

class StorageManager {
    
    /// Get vocabulary data from storage
    ///
    /// - Parameter success: Success closure
    class func getVocabularyDataFromFileWithSuccess(_ success: @escaping ((_ data: Data) -> Void))
    {
        DispatchQueue.main.async { () -> Void in
            let filePath = Bundle.main.path(
                forResource: "Vocabulary",
                ofType:"json"
            )
            do
            {
                let data = try Data (contentsOf: URL(fileURLWithPath: filePath!), options: NSData.ReadingOptions.uncached)
                success (data)
            }
            catch let error as NSError
            {
                NSLog("error = %@", error.description)
            }
        }
    }
    
    /// Get Toeic data from storage
    ///
    /// - Parameter success: Success closure
    class func getToeicDataFromFileWithSuccess(_ success: @escaping ((_ data: Data) -> Void)) {
        DispatchQueue.main.async { () -> Void in
            let filePath = Bundle.main.path(forResource: "TOEIC_final", ofType: "json")
            do {
                let data = try Data (contentsOf: URL(fileURLWithPath: filePath!), options: NSData.ReadingOptions.uncached)
                success(data)
            }
            catch let error as NSError {
                NSLog("error = %@", error.description)
            }
        }
    }
    
    
    /// Get toefl data from storage
    ///
    /// - Parameter success: Success closure
    class func getToeflDataFromFileWithSuccess(_ success: @escaping ((_ data: Data) -> Void)) {
        DispatchQueue.main.async { () -> Void in
            let filePath = Bundle.main.path(forResource: "TOEFL_final", ofType: "json")
            do {
                let data = try Data (contentsOf: URL(fileURLWithPath: filePath!), options: NSData.ReadingOptions.uncached)
                success(data)
            }
            catch let error as NSError {
                NSLog("error = %@", error.description)
            }
        }
    }
    
    /// Get Toeic and Toefl category data from storage
    ///
    /// - Parameter success: Success closure
    class func getToeic_ToeflCategoryWithSuccess(_ success: @escaping ((_ data: Data) -> Void)) {
        DispatchQueue.main.async { () -> Void in
            let filePath = Bundle.main.path(forResource: "TOEIC_TOEFL_textbook", ofType: "json")
            do {
                let data = try Data (contentsOf: URL(fileURLWithPath: filePath!), options: NSData.ReadingOptions.uncached)
                success(data)
            }
            catch let error as NSError {
                NSLog("error = %@", error.description)
            }
        }
    }
    
    /// Get List data from storage
    ///
    /// - Parameter success: Success closure
    class func readListDataFromFileWithSuccess(_ success: @escaping ((_ data: [WCListViewModel]) -> Void)) {
        DispatchQueue.main.async { () -> Void in
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .allDomainsMask, true).first as NSString? {
                let path = dir.appendingPathComponent("List.json")
                if (FileManager.default.fileExists(atPath: path)) {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .uncached)
                        NSKeyedUnarchiver.setClass(WCListViewModel.self, forClassName: "Swallow.WCListViewModel")
                        success(NSKeyedUnarchiver.unarchiveObject(with: data) as! [WCListViewModel])
                    }
                    catch let error as NSError {
                        NSLog("error = %@", error.description)
                    }
                }
            }
        }
    }
    
    /// Write List data to storage
    ///
    /// - Parameter data: WCListViewModel array
    class func writeListDataToFile(_ data: [WCListViewModel]) {
        DispatchQueue.main.async { () -> Void in
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .allDomainsMask, true).first as NSString? {
                let path = dir.appendingPathComponent("List.json")
                NSKeyedArchiver.setClassName("Swallow.WCListViewModel", for: WCListViewModel.self)
                try? NSKeyedArchiver.archivedData(withRootObject: data).write(to: URL(fileURLWithPath: path) , options: [])
            }
        }
    }
}
