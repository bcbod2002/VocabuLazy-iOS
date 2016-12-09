//
//  EListTableViewController.swift
//  Swallow
//
//  Created by 蘇健豪1 on 2016/8/28.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class EListTableViewController: UITableViewController {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var rawData = [WCVocabularyModel]()
    var listData = [WCListViewModel]()


    // ---------------------------------------------------------------------------------------------
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "清單測驗"
        
        getRawData()
        
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getListData()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.font = UIFont (name: "DFHeiStd-W7", size: 25)
        cell.textLabel?.text = listData[(indexPath as NSIndexPath).row].name
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if listDataMapRawData(itemNumber: (indexPath as NSIndexPath).row).count > 3 {
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionPage") as! WCQuestionViewController
            nextViewController.vocabularyArray = listDataMapRawData(itemNumber: (indexPath as NSIndexPath).row)
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - DataBase
    func getRawData() {
        self.rawData.removeAll(keepingCapacity: false)
        StorageManager.getVocabularyDataFromFileWithSuccess { (data) -> Void in
            do {
                let vocabularyArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in vocabularyArray {
                    self.rawData.append(
                        WCVocabularyModel(vocabularyNSDictionary: jsonData)
                    )
                }
            }
            catch let error as NSError {
                NSLog("error = %@", error.description)
            }
        }
    }
    
    func getListData() {
        listData.removeAll(keepingCapacity: false)
        StorageManager.readListDataFromFileWithSuccess { (data) -> Void in
            self.listData = data
            self.tableView.reloadData()
        }
    }
    
    fileprivate func listDataMapRawData(itemNumber listDataNumber: Int) -> [WCVocabularyModel] {
        var listVocabularyModelArray = [WCVocabularyModel]()
        let listDataContent = listData[listDataNumber].content
        
        // 展開再排序
        let rawDataIdentity = rawData.map { (vocabularyModel) -> Int in
            return Int(vocabularyModel.identity)
            }.sorted()
        
        for contentIdentity in listDataContent {
            let mappedNumber = fibonacciSearch(searchArray: rawDataIdentity, find: Int(contentIdentity))
            if (mappedNumber != nil) {
                let vocabularyModel = rawData[mappedNumber!]
                listVocabularyModelArray.append(vocabularyModel)
            }
        }
        return listVocabularyModelArray
    }
    
    func fibonacciSearch(searchArray: [Int], find: Int) -> Int? {
        var fibonacciM2 = 0
        var fibonacciM1 = 1
        var fibonacci = 0 + 1
        
        while fibonacci < find {
            fibonacciM2 = fibonacciM1
            fibonacciM1 = fibonacci
            fibonacci = fibonacciM2 + fibonacciM1
        }
        
        var offset = -1
        
        while fibonacci > 1 {
            let i = min(offset + fibonacciM2, searchArray.count - 1)
            
            if searchArray[i] < find {
                fibonacci = fibonacciM1
                fibonacciM1 = fibonacciM2
                fibonacciM2 = fibonacci - fibonacciM1
                offset = i
            }
            else if searchArray[i] > find {
                fibonacci = fibonacciM2
                fibonacciM1 = fibonacciM1 - fibonacciM2
                fibonacciM2 = fibonacci - fibonacciM1
            }
            else {
                return i
            }
        }
        
        if fibonacciM1 == find && searchArray[offset + 1] == find {
            return offset + 1
        }
        
        return nil
    }
}
