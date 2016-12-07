//
//  WCAddToListPopView.swift
//  Swallow
//
//  Created by jerryz on 2015/9/27.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

// MARK: - WCAddToListPopViewDelegate
@objc protocol WCAddToListPopViewDelegate {
    
    /**
     WCAddToListPopView did finish remove animation
     */
    @objc optional func didEndRemoveAnimation()
}

class WCAddToListPopView : UIView, UITableViewDelegate, UITableViewDataSource, WCNewListPopViewDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // WCAddToListPopView data
    var listData = [WCListViewModel]()
    var selectedWord: UInt!
    
    // View setting
    var view: UIView!
    var offset: CGFloat = 0
    var size: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var superView: UIView!
    var innerPopView: WCNewListPopView!
    
    // WCAddToListPopViewDelegate
    var delegate: WCAddToListPopViewDelegate?
    
    // Interface Builder
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /**
     Initial WCAddToListPopView
     
     - parameter frame:        UIView.frame
     - parameter selectedWord: WCVocabularyModel.identity
     - parameter superView:    UIView
     - parameter offset:       Location
     
     - returns: WCAddToListPopView
     */
    init(frame: CGRect, selectedWord: UInt!, superView: UIView!, offset: CGFloat) {
        super.init(frame: frame)
        getListData()
        self.size = frame
        self.offset = offset
        self.selectedWord = selectedWord
        self.superView = superView
        initMainView()
        initSubView()
        initTableView()
        showAnimate()
    }
    
    /**
     初始化 WCAddToListPopView 的位置與大小
     */
    func initMainView() {
        view = UINib(nibName: "WCAddToListPopView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = CGRect(x: 0, y: -offset, width: size.width, height: size.height)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        superView.addSubview(view)
    }
    
    /**
     初始化相關 SubView 的位置與大小
     */
    func initSubView() {
        let subSize = frame.height / 960
        subView.transform = CGAffineTransform(scaleX: subSize, y: subSize)
        popView.layer.cornerRadius = 5
        popView.layer.shadowOpacity = 0.3
        popView.layer.shadowOffset = CGSize(width: 5, height: 5)
        closeBtn.layer.borderColor = UIColor(red: 72/255, green: 207/255, blue: 174/255, alpha: 1).cgColor
        closeBtn.layer.borderWidth = 3
        closeBtn.layer.cornerRadius = 0.5 * closeBtn.bounds.size.width
    }
    
    /**
     初始化 UITableView
     */
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // ---------------------------------------------------------------------------------------------
    /**
     從 Vocabulary.json 讀取所有的單字
     */
    func getListData() {
        listData.removeAll(keepingCapacity: false)
        StorageManager.readListDataFromFileWithSuccess { (data) -> Void in
            self.listData = data
            self.tableView.reloadData()
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Animations
    /**
     出現 WCAddToListPopView 時的動畫
     */
    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    /**
     消失 WCAddToListPopView 時的動畫
     */
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished : Bool) in if finished {
            self.innerPopView?.removeAnimate()
            self.view.removeFromSuperview()
            self.superView = nil
            self.delegate?.didEndRemoveAnimation!()
        } })
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont (name: "DFHeiStd-W7", size: 25)
        cell.textLabel?.text = listData[(indexPath as NSIndexPath).row].name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listData[(indexPath as NSIndexPath).row].content.append(selectedWord)
        StorageManager.writeListDataToFile(listData)
        removeAnimate()
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Other Methods
    /**
     新增一個新的筆記欄
     
     - parameter name: Note list name
     */
    func newList(_ name: String) {
        listData.append(WCListViewModel(name: name, content: [UInt]()))
        tableView.reloadData()
        StorageManager.writeListDataToFile(listData)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCNewListPopViewDelegate
    func lockNavigationBar(_ isLock: Bool) { }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIButton action
    @IBAction func add() {
        innerPopView = WCNewListPopView(delegate: self, frame: size, superView: superView, offset: offset)
    }
    
    @IBAction func close() {
        removeAnimate()
    }
}
