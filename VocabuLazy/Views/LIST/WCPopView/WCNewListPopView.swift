//
//  WCAddListPopView.swift
//  Swallow
//
//  Created by jerryz on 2015/9/26.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

// ---------------------------------------------------------------------------------------------
// MARK: - WCNewListPopViewDelegate
protocol WCNewListPopViewDelegate {
    func newList(_ name: String)
    func lockNavigationBar(_ isLock: Bool)
}

class WCNewListPopView : UIView, UITextFieldDelegate {
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var view: UIView!
    var offset: CGFloat = 0
    var size: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var superView: UIView!
    var delegate: WCNewListPopViewDelegate!
    
    // IBOutlet
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yesBtn: UIButton!
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    /// Initial mutiple variables
    ///
    /// - Parameters:
    ///   - delegate: WCNewListPopViewDelegate
    ///   - frame: CGRect
    ///   - superView: UIView
    convenience init(delegate: WCNewListPopViewDelegate!, frame: CGRect, superView: UIView) {
        self.init(delegate: delegate, frame: frame, superView: superView, offset: 0)
    }
    
    
    /// Initial mutiple variables
    ///
    /// - Parameters:
    ///   - delegate: WCNewListPopViewDelegate
    ///   - frame: CGRect
    ///   - superView: UIView
    ///   - offset: CGFloat
    init(delegate: WCNewListPopViewDelegate!, frame: CGRect, superView: UIView, offset: CGFloat) {
        super.init(frame: frame)
        self.delegate = delegate
        self.delegate.lockNavigationBar(true)
        self.size = frame
        self.offset = offset
        self.superView = superView
        initMainView()
        initSubView()
        showAnimate()
    }
    
    
    /// <#Description#>
    func initMainView() {
        view = UINib(nibName: "WCNewListPopView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = CGRect(x: 0, y: -offset, width: size.width, height: size.height)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        superView.addSubview(view)
    }

    
    /// <#Description#>
    func initSubView() {
        let subSize = frame.height / 960
        popView.transform = CGAffineTransform(scaleX: subSize, y: subSize)
        popView.layer.cornerRadius = 5
        popView.layer.shadowOpacity = 0.3
        popView.layer.shadowOffset = CGSize(width: 5, height: 5)
        nameTextField.delegate = self
    }

    // ---------------------------------------------------------------------------------------------
    // MARK: - Animations
    /// <#Description#>
    func showAnimate() {
        NotificationCenter.default.addObserver(self, selector: #selector(WCNewListPopView.updatePopViewLocation(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished : Bool) in if finished { self.nameTextField.becomeFirstResponder() } })
    }
    
    /// <#Description#>
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
    
    
    /// <#Description#>
    ///
    /// - Parameter textField: <#textField description#>
    /// - Returns: <#return value description#>
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        yes()
        return true
    }

    func updatePopViewLocation(_ notify: Notification) {
        let keyboardHeight = ((notify as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        centerConstraint.constant = -(popView.frame.height - (view.bounds.height / 2 - keyboardHeight)) + offset
        view.layoutIfNeeded()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIButton actions
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
            delegate.newList(nameTextField.text!)
            removeAnimate()
        }
    }
}
