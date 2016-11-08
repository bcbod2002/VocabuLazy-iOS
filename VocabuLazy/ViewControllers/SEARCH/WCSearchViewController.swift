//
//  WCSearchViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/22.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

class WCSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var rawData = [WCSearchViewModel]()
    var searchResults = [WCSearchViewModel]()
    var popView: WCAddToListPopView!
    let screenSize = UIScreen.main.bounds.size
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRawData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: AnyObject) {
        if let searchText = searchTextField.text {
            getSearchResultsFromDataBySearchText(searchText)
        }
    }
    
    @IBAction func textFieldTouchDown(_ sender: AnyObject) {
        popView?.removeAnimate()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func getRawData()
    {
        self.rawData.removeAll(keepingCapacity: false)
        StorageManager.getVocabularyDataFromFileWithSuccess { (data) -> Void in
            do
            {
                let vocabularyArray : NSArray = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSArray;
                for jsonData in vocabularyArray
                {
                    self.rawData.append(
                        WCSearchViewModel(vocabularyNSDictionary: jsonData as! NSDictionary)
                    )
                }
                self.searchTableView.reloadData()
            }
            catch let error as NSError
            {
                NSLog("error = %@", error.description)
            }
        }
    }

    func getSearchResultsFromDataBySearchText(_ searchText: String) {
        self.searchResults.removeAll(keepingCapacity: false)
        for result in rawData {
            if result.word.lowercased().range(of: searchText, options: .anchored, range: nil, locale: nil) != nil {
                self.searchResults.append(result)
            }
        }
        self.searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        popView = WCAddToListPopView(
            frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height),
            selectedWord: searchResults[sender.tag].identity,
            superView: self.view,
            offset: navigationController!.navigationBar.frame.height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WCSearchTableViewCell
        cell.label.text = "\(searchResults[(indexPath as NSIndexPath).row].word) \(searchResults[(indexPath as NSIndexPath).row].chinese)"
        cell.btn.tag = (indexPath as NSIndexPath).row
        cell.btn.addTarget(self, action: #selector(WCSearchViewController.addToList(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        <#code#>
    }
}
