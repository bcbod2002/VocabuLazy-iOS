//
//  WCRenameListPopView.swift
//  Swallow
//
//  Created by JerryZ on 2015/10/6.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

protocol WCRenameListPopViewDelegate
{
    func renameList(_ indexPath: IndexPath, newName: String)
    func lockNavigationBar(_ isLock: Bool)
}

class WCRenameListPopView : UIView, UITextFieldDelegate {
    var view : UIView!
    var offset : CGFloat = 0
    var size : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var superView : UIView!
    var name : String = ""
    var indexPath : IndexPath = IndexPath(index: 0)
    var delegate : WCRenameListPopViewDelegate!
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yesBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(delegate: WCRenameListPopViewDelegate!, frame: CGRect, superView: UIView, offset: CGFloat, name: String) {
        super.init(frame: frame)
        self.delegate = delegate
        self.delegate.lockNavigationBar(true)
        self.size = frame
        self.offset = offset
        self.superView = superView
        self.name = name
        initMainView()
        initSubView()
        initNameTextField()
        showAnimate()
    }
    
    func initMainView() {
        view = UINib(nibName: "WCRenameListPopView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
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
        nameTextField.delegate = self
    }
    
    func initNameTextField() {
        if !name.isEmpty {
            nameTextField.text = name
            nameTextFieldEditingChanged()
        }
    }
    
    func showAnimate() {
        NotificationCenter.default.addObserver(self, selector: #selector(WCRenameListPopView.updatePopViewLocation(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished : Bool) in if finished { self.nameTextField.becomeFirstResponder() } })
    }
    
    func removeAnimate() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nameTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished : Bool) in if finished {
            self.view.removeFromSuperview()
            self.superView = nil
            self.delegate.lockNavigationBar(false)
        } })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        yes()
        return true
    }
    
    func updatePopViewLocation(_ notify: Notification) {
        let keyboardHeight = ((notify as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        centerConstraint.constant = -(popView.frame.height - (view.bounds.height / 2 - keyboardHeight)) + offset
        view.layoutIfNeeded()
    }
    
    @IBAction func nameTextFieldEditingChanged() {
        UIView.animate(withDuration: 0.25, animations: {
            self.yesBtn.backgroundColor = self.nameTextField.text!.isEmpty ?
            UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0) : UIColor(red: 72/255, green: 207/255, blue: 174/255, alpha: 1.0)
        })
    }
    
    @IBAction func no() {
        removeAnimate()
    }
    
    @IBAction func yes() {
        if !nameTextField.text!.isEmpty {
            removeAnimate()
            delegate.renameList(indexPath, newName: nameTextField.text!)
        }
    }
}
