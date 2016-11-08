//
//  WCFlipTableView.swift
//  Swallow
//
//  Created by JerryZ on 2015/12/8.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit
import Foundation

protocol WCFlipTableViewDelegate
{
    func scrollChangeDelta(_ scrollDeltaPercent: CGFloat)
}

class WCFlipTableView : UIView, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    var dataArray: NSArray!
    var tableView: UITableView
    var delegate: WCFlipTableViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        dataArray = NSArray()
        tableView = UITableView()
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, contentArray: NSArray) {
        dataArray = contentArray
        tableView = UITableView()
        super.init(frame: frame)
        self.frame = frame
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        tableView.frame = self.bounds
        tableView.bounces = false
        tableView.scrollsToTop = true
        tableView.isPagingEnabled = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.clear
        let vc = dataArray.object(at: (indexPath as NSIndexPath).row) as! UIViewController
        vc.view.frame = cell.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.size.width
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let deltaPercent = (scrollView.contentOffset.y) / scrollView.contentSize.height
        delegate.scrollChangeDelta(deltaPercent)
    }
    
    func selectIndex(_ index: Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
        })
    }
}
