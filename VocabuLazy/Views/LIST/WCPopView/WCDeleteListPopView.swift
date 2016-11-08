//
//  WCDeleteListPopView.swift
//  Swallow
//
//  Created by JerryZ on 2015/10/6.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

protocol WCDeleteListPopViewDelegate
{
    func deleteList(_ indexPath: IndexPath)
    func lockNavigationBar(_ isLock: Bool)
}

class WCDeleteListPopView : UIView {
    var view : UIView!
    var offset : CGFloat = 0
    var size : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var superView : UIView!
    var delegate : WCDeleteListPopViewDelegate!
    var indexPath : IndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(delegate: WCDeleteListPopViewDelegate!,frame: CGRect, superView: UIView, offset: CGFloat, name: String) {
        super.init(frame: frame)
        self.delegate = delegate
        self.delegate.lockNavigationBar(true)
        self.size = frame
        self.offset = offset
        self.superView = superView
        initMainView()
        initSubView()
        nameLabel.text = "\"\(name)\""
        showAnimate()
    }
    
    func initMainView() {
        view = UINib(nibName: "WCDeleteListPopView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = CGRect(x: 0, y: -offset, width: size.width, height: size.height)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        superView.addSubview(view)
    }
    
    func initSubView() {
        let subSize = frame.height / 960
        popView.transform = CGAffineTransform(scaleX: subSize, y: subSize)
        popView.layer.cornerRadius = 5
        popView.layer.shadowOpacity = 0.3
        popView.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool) in if finished {
            self.view.removeFromSuperview()
            self.superView = nil
            self.delegate.lockNavigationBar(false)
        }})
    }
    
    @IBAction func no() {
        removeAnimate()
    }
    
    @IBAction func yes() {
        self.delegate.deleteList(indexPath)
        removeAnimate()
    }
}
