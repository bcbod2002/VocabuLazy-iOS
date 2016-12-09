//
//  WCQuestionCollectionViewCell.swift
//  Swallow
//
//  Created by Goston on 2016/4/5.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCQuestionCollectionViewCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------
    // Private variable
    var questionAnswerView: WCQuestionAnswerView?
    var examResultView: WCExamResultView?
    
    // Public variable
    var indexPath: IndexPath? {
        get {
            return self.indexPath
        }
        set(outerIndexPath){
            if ((outerIndexPath as NSIndexPath?)?.row)! < 9 {
                appearQuestionAnswerView()
                questionAnswerView?.questionNumber = ((outerIndexPath as NSIndexPath?)?.row)!
                if questionAnswerView?.isButtonActive == true {
                    questionAnswerView?.resetAllButtonStatus()
                }
            }
            else {
                disappearQuestionAnswerView()
                appearExamResultView()
            }
        }
    }
    
    var questionAnswerViewDelegate: WCQuestionAnswerViewDelegate? {
        get {
            return (questionAnswerView?.delegate)!
        }
        set(outerObject) {
            questionAnswerView?.delegate = outerObject
        }
    }
    
    var examResultViewDelegate: WCExamResultViewDelegate? {
        get {
            return (examResultView?.delegate)!
        }
        set(outerObect) {
            examResultView?.delegate = outerObect
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        questionAnswerView = WCQuestionAnswerView(frame: self.bounds)
        questionAnswerView?.isUserInteractionEnabled = false
        questionAnswerView?.alpha = 0.0
        
        examResultView = WCExamResultView(frame: self.bounds)
        examResultView?.isUserInteractionEnabled = false
        examResultView?.alpha = 0.0
    }
    
    fileprivate func appearQuestionAnswerView() {
        questionAnswerView?.isUserInteractionEnabled = true
        questionAnswerView?.alpha = 1.0
        self.contentView.addSubview(questionAnswerView!)
    }
    
    fileprivate func disappearQuestionAnswerView() {
        questionAnswerView?.isUserInteractionEnabled = false
        questionAnswerView?.alpha = 0.0
        questionAnswerView?.removeFromSuperview()
    }
    
    fileprivate func appearExamResultView() {
        examResultView?.isUserInteractionEnabled = true
        examResultView?.alpha = 1.0
        self.contentView.addSubview(examResultView!)
    }
    
    fileprivate func disappearExamResultView() {
        examResultView?.isUserInteractionEnabled = false
        examResultView?.alpha = 0.0
        examResultView?.removeFromSuperview()
    }
}
