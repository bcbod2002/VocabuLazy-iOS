//
//  WCWordPlayTableView.swift
//  Swallow
//
//  Created by Goston on 2015/8/23.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

// MARK: - WCWordPlayTableViewDelegate
@objc protocol WCWordPlayTableViewDelegate {
    /**
    WCWordPlayTableView did select WCWordPlayCollectionViewCell index path

    :param: tableView WCWordPlayTableView
    :param: indexPath Selected index path
    */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, didSelectItemAtIndexPath indexPath: IndexPath)

    /**
    WCWordPlayTableView will display WCWordPlayCollectionViewCell

    :param: tableView WCWordPlayTableView
    :param: cell      WCWordPlayCollectionViewCell
    :param: indexPath Index path
    */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, willDisplayCell cell: WCWordPlayCollectionViewCell, forItemAtIndexPath indexPath:IndexPath)

    /**
    WCWordPlayTableView did end display WCWordPlayColletionViewCell

    :param: tableView WCWordPlayTableView
    :param: cell      WCWordPlayCollectionViewCell
    :param: indexPath Index path
    */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, didEndDisplayingCell cell: WCWordPlayCollectionViewCell, forItemAtIndexPath indexPath: IndexPath)

    /**
    WCWordPlayTableView did scroll to item

    :param: tableView  WCWordPlayTableView
    :param: itemNumber Item number
    */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, didScrolltoItem itemNumber: Int)

    /**
    WCWordPlayTableView begin scroll with finger

    - parameter tableView: WCWordPlayTableView
    */
    @objc optional func tableViewBeginScrollWithFinger(_ tableView: WCWordPlayTableView)
    
    /**
     WCWordPlayTableView end scroll with finger
     
     - parameter tableView: WCWordPlayTableView
     - parameter itemNumber: Item number
     */
    @objc optional func tableViewEndScrollWithFinger(_ tableView: WCWordPlayTableView, willScrolltoItem itemNumber: Int)

    /**
    WCWordPlayTableView did finish animation cell

    - parameter tableView:         WCWordPlayTableView
    - parameter cell:              WCWordPlayCollectionViewCell
    - parameter isAmplifySentence: Is amplify sentence
    - parameter itemNumber:        Item number
    */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, didFinishAnimationCell cell: WCWordPlayCollectionViewCell, isAmplifySentence: Bool, itemNumber: Int)
    
    /**
     WCWordPlayTableView begin scroll with finger
     
     - parameter tableView:    WCWordPlayTableView
     - parameter cell:         WCWordPlayCollectionViewCell
     - parameter sentenceView: WCWordPlaySentenceView
     */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, beginScrollWithFinger cell: WCWordPlayCollectionViewCell, sentenceView: WCWordPlaySentenceView)
    
    /**
     WCWordPlayTableViewCell of WCWordTableView sentence scroll to another
     
     - parameter tableView:   WCWordPlayTableView
     - parameter cell:        WCWordPlayCollectionViewCell
     - parameter sentencView: WCWordPlaySentenceView
     - parameter itemNumber:  Scroll to Item number
     */
    @objc optional func tableView(_ tableView: WCWordPlayTableView, didScroll cell: WCWordPlayCollectionViewCell, sentencView: WCWordPlaySentenceView, to itemNumber: Int)
}

class WCWordPlayTableView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, WCWordPlayCollectionViewCellDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // WCWordPlayTableView data
    fileprivate var wordPlayModel : [WCVocabularyModel]!
    
    // UICollectionView components
    var wordPlayCollectionView : UICollectionView!
    var opendIndexPath: IndexPath?
    var cellIsAmplify : Bool! = false
    var animationLock: Bool = false
    fileprivate var scrollLock: Bool = false
    
    // UICollectionView component relate
    fileprivate var tableViewDataSource: WCWordPlayTableViewDataSource?
    fileprivate var wordPlayFlowLayout : WCWordPlayCollectionViewFlowLayout!
    fileprivate var amplifyCell : WCWordPlayCollectionViewCell!
    
    // Delegate
    var delegate: WCWordPlayTableViewDelegate?
    var isDelegateCall: Bool = true

    // Foreground status
    var isForegroundStatus : Bool? = true
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initial ItemArray
        initialWordPlayCollectionView()
    }

    /**
     Initial WCWordPlayTablewView with WCVocabularyModel array
     
     - parameter frame:          Set WCWordPlayTableView
     - parameter lessonContents: WCVocabularyModel array
     
     - returns: void
     */
    convenience init(frame: CGRect, lessonContents: [WCVocabularyModel]) {
        self.init(frame: frame)
        wordPlayModel = lessonContents
    }

    /**
    Initial WCWordPlayCollectionView and add two CAGradientLayer, one of the layer at the top , the oher one at the bottom

    :returns: void
    */
    fileprivate func initialWordPlayCollectionView() {
        let cellIdentifier = "WordPlayCell"
        
        wordPlayFlowLayout = WCWordPlayCollectionViewFlowLayout()
        wordPlayCollectionView = UICollectionView (frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: wordPlayFlowLayout)
        wordPlayFlowLayout.setCollectionViewSize(frame.size)
        wordPlayCollectionView.register(WCWordPlayCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        wordPlayCollectionView.backgroundColor = UIColor.clear
        wordPlayCollectionView.delegate = self
//        tableViewDataSource = WCWordPlayTableViewDataSource(numberOfItems: wordPlayModel.count, cellIdentifier: cellIdentifier)
//        wordPlayCollectionView.dataSource = tableViewDataSource
        wordPlayCollectionView.dataSource = self
        addSubview(wordPlayCollectionView)

        addTopBottomGradientLayers()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Decorate View
    fileprivate func addTopBottomGradientLayers() {
        // Add CAGradientLayer at top of UICollectionView
        let topGradientLayer = CAGradientLayer()
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: wordPlayFlowLayout.itemSize.height)
        topGradientLayer.colors = [UIColor(white: 1.0, alpha: 1.0).cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
        topGradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(topGradientLayer)
        
        // Add CAGradientLayer at bottom of UICollectionView
        let bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.frame = CGRect(x: 0, y: frame.height - (wordPlayFlowLayout.itemSize.height), width: frame.width, height: wordPlayFlowLayout.itemSize.height)
        bottomGradientLayer.colors = [UIColor(white: 1.0, alpha: 0.0).cgColor, UIColor(white: 1.0, alpha: 1.0).cgColor]
        bottomGradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(bottomGradientLayer)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Set WCWordPlayTableView data
    /**
     Set englishItemArray and chineseItemArray
     
     :param: englishArray Set englishItemArray
     :param: chineseArray Set chineseItemArray
     */
    func setWCWordPlayModel(_ lessonContents: [WCVocabularyModel]) {
        wordPlayModel = lessonContents
        wordPlayCollectionView.reloadData()
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Control WCWordPlayTableView
    /**
     Set WCWordPlayTableView could scroll or not
     
     - parameter enable: Scroll enable
     */
    func setScrollEnable(_ enable: Bool) {
        wordPlayCollectionView.isScrollEnabled = enable
    }
    
    /**
    Scroll WCWordPlayTableView to item number

    :param: itemNumber Item number
    */
    func tableViewScrolltoItem(_ itemNumber:Int, animated: Bool, callDelegate: Bool) {
        let itemIndexPath = IndexPath(row: itemNumber, section: 0)
        isDelegateCall = callDelegate
        wordPlayCollectionView.scrollToItem(at: itemIndexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: animated)
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Control WCWordPlayTableViewCell
    /**
     Scroll to the sentence which in WCwordPlayTableViewCell
     
     - parameter sentenceItemNumber: Sentence number
     */
    func tableViewCellScrollToSentence(_ sentenceItemNumber: Int, animated: Bool) {
        amplifyCell.scrollSentenceTo(sentenceItemNumber, isAnimation: animated)
    }
    
    /**
     Minifu all WCWordPlayTableViewCell
     */
    func minifyAllCell() {
        let totalNumberofSections = wordPlayCollectionView.numberOfSections
        
        for sectionIndex in 0...(totalNumberofSections - 1) {
            let totalNumberOfItems = wordPlayCollectionView.numberOfItems(inSection: sectionIndex)
            wordPlayCollectionView.isScrollEnabled = true
            for rowIndex in 0...(totalNumberOfItems - 1) {
                let cellIndexPath = IndexPath(row: rowIndex, section: sectionIndex)
                let cell : WCWordPlayCollectionViewCell? = wordPlayCollectionView.cellForItem(at: cellIndexPath) as? WCWordPlayCollectionViewCell
                if cell != nil && cell!.isAmplify {
                    cell?.cellMinify(false, success: { (amplify) in
                        self.cellIsAmplify = false
                    })
                }
            }
        }
    }
    
    /**
     Reload WCwordPlayTableView data
     */
    func reloadAllData() {
        wordPlayCollectionView.reloadData()
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordPlayModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : WCWordPlayCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "WordPlayCell", for: indexPath) as! WCWordPlayCollectionViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.setVocabulary(wordPlayModel[(indexPath as NSIndexPath).row])

        return cell
    }
    

    // ---------------------------------------------------------------------------------------------
    // FIXME: 第一版還不用打開單字卡，因為現在的單字庫沒有例句
    // MARK: - UICollectionViewDelegate
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        // 展開出字卡內容
//        // 內容為 顯示英文例句 與 中文例句
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WCWordPlayCollectionViewCell
//        
//        if cell.isHighlight == HighlightStatus.HighlightCell {
//            if animationLock == false {
//                if !cell.isAmplify {
//                    animationLock = true
//                    cellIsAmplify = true
//                    opendIndexPath = indexPath
//                    collectionView.scrollEnabled = false
//                    cell.cellAmplify(true, success: { (amplify) -> Void in
//                        self.animationLock = false
//                        cell.addTapGestureToSentenceView(with: self, action: #selector(WCWordPlayTableView.tapActiontoMinifyCell))
//                        self.amplifyCell = cell
//                        self.delegate?.tableView?(self, didFinishAnimationCell: cell, isAmplifySentence: true, itemNumber: indexPath.row)
//                    })
//                }
//                else {
//                    animationLock = true
//                    cellIsAmplify = false
//                    opendIndexPath = nil
//                    cell.cellMinify(true, success: { (amplify) -> Void in
//                        self.animationLock = false
//                        collectionView.scrollEnabled = true
//                        self.delegate?.tableView?(self, didFinishAnimationCell: cell, isAmplifySentence: false, itemNumber: indexPath.row)
//                    })
//                }
//                delegate?.tableView?(self, didSelectItemAtIndexPath: indexPath)
//            }
//        }
//    }
    
    /**
     Tap sentence and minify WCWordPlayTableViewCell
     */
    func tapActiontoMinifyCell() {
        amplifyCell.cellMinify(true, success: { (amplify) -> Void in
            self.cellIsAmplify = amplify
            self.wordPlayCollectionView.isScrollEnabled = true
            self.delegate?.tableView?(self, didFinishAnimationCell: self.amplifyCell, isAmplifySentence: false, itemNumber: ((self.wordPlayCollectionView.indexPath(for: self.amplifyCell) as NSIndexPath?)?.row)!)
        })
        if opendIndexPath != nil {
            delegate?.tableView?(self, didSelectItemAtIndexPath: opendIndexPath!)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.tableView?(self, willDisplayCell: cell as! WCWordPlayCollectionViewCell, forItemAtIndexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.tableView?(self, didEndDisplayingCell: cell as! WCWordPlayCollectionViewCell, forItemAtIndexPath: indexPath)
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - WCWordPlayCollectionViewCellDelegate
    func cell(_ cell: WCWordPlayCollectionViewCell, beginScrollWithFinger sentenceContentView: WCWordPlaySentenceView) {
        delegate?.tableView?(self, beginScrollWithFinger: cell, sentenceView: sentenceContentView)
    }
    
    func cell(_ cell: WCWordPlayCollectionViewCell, scroll sentenceContentView: WCWordPlaySentenceView, to itemNumber: Int) {
        delegate?.tableView?(self, didScroll: cell, sentencView: sentenceContentView, to: itemNumber)
    }

    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.tableViewBeginScrollWithFinger?(self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollLock == false {
            scrollLock = true
            scrollViewDidEndAllScrollingAnimation(scrollView, useFinger: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollLock == false {
            scrollLock = true
            scrollViewDidEndAllScrollingAnimation(scrollView, useFinger: false)
        }
    }
    
    fileprivate func scrollViewDidEndAllScrollingAnimation(_ scrollView: UIScrollView, useFinger: Bool) {
        let selectedIndexPath = wordPlayFlowLayout.selectedAttribute?.indexPath
        if isDelegateCall == true {
            if useFinger == true {
                delegate?.tableViewEndScrollWithFinger?(self, willScrolltoItem: (selectedIndexPath?.row)!)
            }
            else {
                delegate?.tableView?(self, didScrolltoItem: ((selectedIndexPath as NSIndexPath?)?.row)!)
            }
        }
        else {
            isDelegateCall = true
        }
        scrollLock = false
    }
    
    
    // ---------------------------------------------------------------------------------------------
    //FIXME: 第一版還不用打開單字卡，因為現在的單字庫沒有例句
    // MARK: - Select WCWordPlayTableView item
    /**
    Select WCWordPlayTableViewCell
    
    - parameter itemNumber: Item number
    */
//    func selectItemWithItemNumber(itemNumber: Int) {
//        let selectedIndexPath = NSIndexPath(forRow: itemNumber, inSection: 0)
//        
//        let cell : WCWordPlayCollectionViewCell? = wordPlayCollectionView.cellForItemAtIndexPath(selectedIndexPath) as? WCWordPlayCollectionViewCell
//        if cell != nil {
//            if (cell!.isHighlight == HighlightStatus.HighlightCell) {
//                amplyCellAnimation(cell!, selectedIndexPath: selectedIndexPath)
//            }
//            else {
//                amplyCellAnimation(cell!, selectedIndexPath: selectedIndexPath)
//            }
//        }
//    }
    
    //FIXME: 第一版還不用打開單字卡，因為現在的單字庫沒有例句
    /**
     Select WCWordPlayTableViewCell with mute
     
     - parameter itemNumber: Item number
     */
//    func selectItemWithItemNumberMute(itemNumber: Int) {
//        let selectedIndexPath = NSIndexPath(forRow: itemNumber, inSection: 0)
//        
//        let cell : WCWordPlayCollectionViewCell? = wordPlayCollectionView.cellForItemAtIndexPath(selectedIndexPath) as? WCWordPlayCollectionViewCell
//        if cell != nil {
//            if (cell!.isHighlight == HighlightStatus.HighlightCell) {
//                if !cell!.isAmplify {
//                    wordPlayCollectionView.scrollToItemAtIndexPath(selectedIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
//                    cell!.cellAmplify(false, success: { (amplify) -> Void in
//                        self.cellIsAmplify = amplify
//                        self.wordPlayCollectionView.scrollEnabled = false
//                        
//                        cell!.addTapGestureToSentenceView(with: self, action: #selector(WCWordPlayTableView.tapActiontoMinifyCell))
//                        self.amplifyCell = cell
//                    })
//                }
//                else {
//                    cell!.cellMinify(false, success: { (amplify) -> Void in
//                        self.cellIsAmplify = amplify
//                        self.wordPlayCollectionView.scrollEnabled = true
//                    })
//                }
//            }
//            else {
//                if !cell!.isAmplify {
//                    wordPlayCollectionView.scrollToItemAtIndexPath(selectedIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
//                    cell!.cellAmplify(false, success: { (amplify) -> Void in
//                        self.cellIsAmplify = amplify
//                        self.wordPlayCollectionView.scrollEnabled = false
//                        
//                        cell!.addTapGestureToSentenceView(with: self, action: #selector(WCWordPlayTableView.tapActiontoMinifyCell))
//                        self.amplifyCell = cell
//                    })
//                }
//                else {
//                    cell!.cellMinify(false, success: { (amplify) -> Void in
//                        self.cellIsAmplify = amplify
//                        self.wordPlayCollectionView.scrollEnabled = true
//                    })
//                }
//            }
//        }
//    }
    
    /**
     Amplify cell or Minify cell
     
     - parameter cell:              WCWordPlayTableViewCell
     - parameter selectedIndexPath: Selected index path
     */
    fileprivate func amplyCellAnimation(_ cell: WCWordPlayCollectionViewCell, selectedIndexPath: IndexPath) {
        if !cell.isAmplify {
            cellIsAmplify = true
            animationLock = true
            wordPlayCollectionView.isScrollEnabled = false
            cell.cellAmplify(true, success: { (amplify) -> Void in
                self.animationLock = false
                cell.addTapGestureToSentenceView(with: self, action: #selector(WCWordPlayTableView.tapActiontoMinifyCell))
                self.amplifyCell = cell
                if self.isForegroundStatus! {
                    self.delegate?.tableView?(self, didFinishAnimationCell: cell, isAmplifySentence: amplify, itemNumber: (selectedIndexPath as NSIndexPath).row)
                }
            })
        }
        else {
            animationLock = true
            cellIsAmplify = false
            cell.cellMinify(true, success: { (amplify) -> Void in
                self.animationLock = false
                self.wordPlayCollectionView.isScrollEnabled = true
                if self.isForegroundStatus! {
                    self.delegate?.tableView?(self, didFinishAnimationCell: cell, isAmplifySentence: amplify, itemNumber: (selectedIndexPath as NSIndexPath).row)
                }
            })
        }
        self.delegate?.tableView?(self, didSelectItemAtIndexPath: selectedIndexPath)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    deinit {
        wordPlayCollectionView = nil
        wordPlayFlowLayout = nil
        wordPlayModel = nil
        delegate = nil
    }
}
