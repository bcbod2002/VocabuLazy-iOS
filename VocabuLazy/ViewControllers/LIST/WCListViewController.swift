//
//  WCListViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/21.
//  Copyright (c) 2015年 Wishcan. All rights reserved.
//

import UIKit

class WCListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCNewListPopViewDelegate, WCRenameListPopViewDelegate, WCDeleteListPopViewDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // Define
    let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var rawData = [WCVocabularyModel]()
    var newListPopView: WCNewListPopView!
    var renameListPopView: WCRenameListPopView!
    var deleteListPopView: WCDeleteListPopView!
    var listData = [WCListViewModel]()
    var offset: CGFloat = 0.0
    let screenSize = UIScreen.main.bounds.size
    var addButton: WCMaterialButton?
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        offset = navigationController!.navigationBar.frame.height
        getRawData()
        readToeflVocabularyFromStorage()
        readToeicVocabularyFromStorage()
        
        initialSuspensionAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getListData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hidesBottomBarWhenPushed = false
    }
    
    
    func getListData() {
        listData.removeAll(keepingCapacity: false)
        StorageManager.readListDataFromFileWithSuccess { (data) -> Void in
            self.listData = data
            self.listTableView.reloadData()
            
            if self.listData.count == 0 {
                self.addEmptyView()
            }
        }
    }
    
    func createBackgroundColorByImageName(_ named: String) -> UIColor {
        let img = UIImage(named: named) as UIImage!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 0.0)
        img?.draw(in: CGRect(x: 10, y: 10, width: 20, height: 20))
        let imgView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
        UIGraphicsEndImageContext()
        imgView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        imgView.backgroundColor = UIColor(red: 72/255, green: 207/255, blue: 174/255, alpha: 1.0)
        UIGraphicsBeginImageContext(imgView.bounds.size)
        imgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIColor(patternImage: UIGraphicsGetImageFromCurrentImageContext()!)
    }
    
    fileprivate func addEmptyView() {
        let listEmptyView = UINib(nibName: "WCListEmptyView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        listEmptyView.frame = view.bounds
        view.addSubview(listEmptyView)
    }
    
    func initialSuspensionAddButton() {
        let addButtonSize = CGSize(width: 50, height: 50)
        let addButtonPoint = CGPoint(x: screenSize.width - addButtonSize.width * 3 / 2, y: screenSize.height - (offset + (addButtonSize.height * 3)))
        addButton = WCMaterialButton(frame: CGRect(x: addButtonPoint.x, y: addButtonPoint.y, width: addButtonSize.width, height: addButtonSize.height), cornerRadious: addButtonSize.height / 2)
        addButton?.addTarget(self, action: #selector(WCListViewController.addToList), for: UIControlEvents.touchUpInside)
        
        addButton?.backgroundColor = WC_Yellow_Color
        addButton?.setTitle("+", for: UIControlState())
        addButton?.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(addButton!)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont (name: "DFHeiStd-W7", size: 25)
        cell.textLabel?.text = listData[(indexPath as NSIndexPath).row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard listData[(indexPath as NSIndexPath).row].content.count == 0 else {
            let listVocabularyModelArray = listDataMapRawData(itemNumber: (indexPath as NSIndexPath).row)
            
            let wordPlayViewController = storyboard?.instantiateViewController(withIdentifier: "WordPlayPage") as! WCWordPlayViewController
            wordPlayViewController.allLessonsArray = [listVocabularyModelArray]
            wordPlayViewController.title = listData[(indexPath as NSIndexPath).row].name
            navigationController?.pushViewController(wordPlayViewController, animated: true)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let renameAction = UITableViewRowAction(style: .normal, title: "   ") { action, index in
            self.renameListPopView = WCRenameListPopView(
                delegate: self,
                frame: CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height),
                superView: self.view, offset: self.offset, name: self.listData[(indexPath as NSIndexPath).row].name)
            self.renameListPopView.indexPath = indexPath
        }
        renameAction.backgroundColor = createBackgroundColorByImageName("L_Edit_Rename.png")
        
        let combineAction = UITableViewRowAction(style: .normal, title: "   ") { action, index in
//            <#code#>
        }
        combineAction.backgroundColor = createBackgroundColorByImageName("L_Edit_Combine.png")
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "   ") { action, index in
            self.deleteListPopView = WCDeleteListPopView(
                delegate: self,
                frame: CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height),
                superView: self.view, offset: self.offset, name: self.listData[(indexPath as NSIndexPath).row].name)
            self.deleteListPopView.indexPath = indexPath
        }
        deleteAction.backgroundColor = createBackgroundColorByImageName("L_Edit_Delete.png")
        
        return [combineAction, renameAction, deleteAction]
    }
    
    //TODO: 現在暫時沒辦法做到點選 UITableViewCell 上的任一東西來讓 UITableViewCell 直接進入 UITableViewRowAction
    //      原因如下
    //      http://stackoverflow.com/questions/32625983/ios-trigger-swipe-to-delete-manually-instead-of-a-user-interaction
    //      http://stackoverflow.com/questions/35947931/manually-trigger-uitableviewrowaction-handler
    //      應該是要直接去偷 UITableViewRowAction 的 private 方法
    //      或是
    //      自己重新做一個 UITableView 出來
    
    /**
     根據 listData 陣列中的 content 找出在 rawData 中的 WCVocabulartModel
     
     - parameter listDataNumber: Number of listData
     
     - returns: WCVocabularyModel
     */
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
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Fibonacci search (logN)
    /**
     Fabonacci search (The data must be sorted)
     
     - parameter searchArray: Data array
     - parameter find:        Search data
     
     - returns: Index of array
     */
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
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - 取得資料
    /**
     從 Vocabulary.json 取得 raw data
     */
    func getRawData() {
        rawData.removeAll(keepingCapacity: false)
        StorageManager.getVocabularyDataFromFileWithSuccess { (data) -> Void in
            do {
                let vocabularyArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in vocabularyArray {
                    self.rawData.append(WCVocabularyModel(vocabularyNSDictionary: jsonData))
                }
            }
            catch let error as NSError {
                printLog("error = %@", error.description)
            }
        }
    }
    
    fileprivate func readToeicVocabularyFromStorage() {
        StorageManager.getToeicDataFromFileWithSuccess { (data) in
            do {
                let toeicArray: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in toeicArray {
                    self.rawData.append(WCVocabularyModel(vocabularyNSDictionary: jsonData))
                }
            }
            catch let error as NSError {
                printLog("error = %@", error.description)
            }
        }
    }
    
    fileprivate func readToeflVocabularyFromStorage() {
        StorageManager.getToeflDataFromFileWithSuccess { (data) in
            do {
                let toeicArray: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in toeicArray {
                    self.rawData.append(WCVocabularyModel(vocabularyNSDictionary: jsonData))
                }
            }
            catch let error as NSError {
                printLog("error = %@", error.description)
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCNewListPopViewDelegate
    func newList(_ name: String) {
        listData.append(WCListViewModel(name: name, content: [UInt]()))
        listTableView.reloadData()
        StorageManager.writeListDataToFile(listData)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCNewListPopViewDelegate
    func renameList(_ indexPath: IndexPath, newName: String) {
        listData[(indexPath as NSIndexPath).row].name = newName
        listTableView.isEditing = false
        listTableView.cellForRow(at: indexPath)?.textLabel?.text = newName
        StorageManager.writeListDataToFile(listData)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCDeleteListPopViewDelegate
    func deleteList(_ indexPath: IndexPath) {
        listData.remove(at: (indexPath as NSIndexPath).row)
        listTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        StorageManager.writeListDataToFile(listData)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCNewListPopViewDelegate, WCRenameListPopViewDelegate and WCDeleteListPopViewDelegate
    func lockNavigationBar(_ isLock: Bool) {
        if let items = navigationItem.rightBarButtonItems {
            for item in items {
                item.isEnabled = !isLock
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIBarButton action
    func addToList() {
        if (newListPopView?.superView == nil) {
            newListPopView = WCNewListPopView(
                delegate: self,
                frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height),
                superView: view, offset: offset)
        }
    }
}
