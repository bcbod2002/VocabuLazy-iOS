//
//  WCSegmentTapView.swift
//  Swallow
//
//  Created by JerryZ on 2015/12/11.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit
import Foundation

protocol WCSegmentTapViewDelegate
{
    func selectedIndex(_ index: Int)
}

class WCSegmentTapView : UIView
{
    var dataArray = [AnyObject]()
    var buttonsArray = [UIButton]()
    var lineImageView: UIImageView!
    var delegate: WCSegmentTapViewDelegate!
    var titleFont: CGFloat
    var lineColor: UIColor
    var textNormalColor: UIColor
    var textSelectedColor: UIColor

    required init?(coder aDecoder: NSCoder) {
        titleFont = CGFloat()
        lineColor = UIColor.red
        textNormalColor = UIColor.black
        textSelectedColor = UIColor.red
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, contentArray: [AnyObject], font: CGFloat) {
        titleFont = font
        dataArray = contentArray
        lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        textNormalColor = UIColor.black
        textSelectedColor = UIColor.red
        super.init(frame: frame)
        self.frame = frame
        backgroundColor = UIColor.black
        addSubSegmentView()
    }
    
    func addSubSegmentView() {
        let width = self.frame.size.width / CGFloat(dataArray.count)
        for i in (0..<dataArray.count) {
            let button = UIButton(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: frame.size.height))
            let source = dataArray[i] as! String
            button.tag = i + 1
            button.adjustsImageWhenHighlighted = false;
            button.backgroundColor = UIColor.clear
            button.setImage(UIImage(named: source), for: UIControlState())
            button.addTarget(self, action: #selector(WCSegmentTapView.tapAction(_:)), for: .touchUpInside)
            if (i == 0) {
                button.isSelected = true
            }
            else {
                button.isSelected = false
            }
            buttonsArray.append(button)
            addSubview(button)
        }
        lineImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: frame.size.height))
        lineImageView.backgroundColor = lineColor
        addSubview(lineImageView)
    }
    
    func tapAction(_ button: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.lineImageView.frame = CGRect(
                x: button.frame.origin.x, y: 0,
                width: button.frame.size.width, height: button.frame.size.height
            )
            for subButton in self.buttonsArray {
                if (button == subButton) {
                    subButton.isSelected = true
                }
                else {
                    subButton.isSelected = false
                }
            }
            self.delegate.selectedIndex(button.tag - 1)
        })
    }
    
    func selectIndex(_ index: Int) {
        for subButton in buttonsArray {
            if (index != subButton.tag) {
                subButton.isSelected = false
            }
            else {
                subButton.isSelected = true
                UIView.animate(withDuration: 0.2, animations: {
                    printLog("subButton.frame.origin.x = ", subButton.frame.origin.x)
                    self.lineImageView.frame = CGRect(
                        x: subButton.frame.origin.x, y: 0,
                        width: subButton.frame.size.width, height: subButton.frame.size.height
                    )
                })
            }
        }
    }
    
    func moveToIndex(_ deltaPercent: CGFloat) {
        let moveOrigin = CGPoint(x: deltaPercent * frame.size.width, y: 0)
        let tmpButtonSize = buttonsArray[0].frame.size
        lineImageView.frame = CGRect(origin: moveOrigin, size: tmpButtonSize)
    }
}
