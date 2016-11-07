//
//  WCFlipViewController.swift
//  Swallow
//
//  Created by JerryZ on 2015/12/14.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

class WCFlipViewController: UIViewController, WCSegmentTapViewDelegate, WCFlipTableViewDelegate {
    var segmentTapView: WCSegmentTapView!
    var flipView: WCFlipTableView!
    var controllsArray = [AnyObject]()
    var index = 0
    let screenSize: CGSize = UIScreen.main.bounds.size
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    // 按照螢幕寬度比例調整高度
    let barHeight = UIScreen.main.bounds.size.width / 4 / 4 * 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFlipTableView()
        initSegment()
    }
    
    func initSegment() {
        segmentTapView = WCSegmentTapView(
            frame: CGRect(x: 0, y: screenSize.height - barHeight, width: screenSize.width, height: barHeight),
            contentArray: ["學習單元" as AnyObject, "我的清單" as AnyObject, "測驗功能" as AnyObject, "關於我們" as AnyObject],
            font: 15
        )
        segmentTapView.delegate = self
        view.addSubview(segmentTapView)
    }
    
    func initFlipTableView() {
        controllsArray.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "first"))
        controllsArray.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "second"))
        controllsArray.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "third"))
        controllsArray.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fourth"))
        flipView = WCFlipTableView(
            frame: CGRect(
                x: 0, y: statusBarHeight,
                width: screenSize.width, height: screenSize.height - statusBarHeight),
            contentArray: controllsArray as NSArray)
        
        flipView.delegate = self
        view.addSubview(flipView)
        
        // 測試讓 segmentView 消失
        let mainViewController = controllsArray[0].viewControllers[0]
        mainViewController.addObserver(self, forKeyPath: "isViewAppear", options: .new, context: nil)
        
        let examViewController = controllsArray[2].viewControllers[0]
        examViewController.addObserver(self, forKeyPath: "isViewAppear", options: .new, context: nil)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if (keyPath == "isViewAppear") {
//            let newValue: Bool = change!["new"] as! Bool
//            [self .segmentTapViewAnimationAppear(newValue)]
//        }
//    }
    
    func selectedIndex(_ index: Int) {
        flipView.selectIndex(index)
    }
    
    func scrollChangeDelta(_ scrollDeltaPercent: CGFloat) {
        segmentTapView.moveToIndex(scrollDeltaPercent)
    }
    
    func segmentTapViewAnimationAppear(_ isAppear: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.segmentTapView.alpha = CGFloat(isAppear.hashValue)
            }, completion: { (Bool) in
                self.flipView.tableView.isScrollEnabled = isAppear
        }) 
    }
}
