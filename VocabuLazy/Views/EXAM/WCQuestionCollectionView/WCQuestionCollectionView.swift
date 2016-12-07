//
//  WCQuestionCollectionView.swift
//  Swallow
//
//  Created by Goston on 2016/4/2.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

// MARK: - WCQuestionCollectionViewDelegate
protocol WCQuestionCollectionViewDelegate {
    /**
     點選 測驗標題按鈕
     
     - parameter collectionView: WCQuestionCollectionView
     - parameter currentNumber:  當前的題目號碼
     */
    func didTapQuestionTitleButtonFrom(
        QuestionCollectionView collectionView: WCQuestionCollectionView,
        QuestionNumber currentNumber: Int)
    
    /**
     點選 正確的答案案鈕
     
     - parameter collectionView: WCQuestionCollectionView
     - parameter currentNumber:  當前的題目號碼
     - parameter buttonNumber:   選中的按鈕號碼
     */
    func didSelectCorrentButtonFrom(
        QuestionCollectionView collectionView: WCQuestionCollectionView,
        QuestionNumber currentNumber: Int,
        AnswerButtonNumber buttonNumber: Int)
    
    /**
     點選 錯誤的答案按鈕
     
     - parameter collectionView: WCQuestionCollectionView
     - parameter currentNumber:  當前的題目號碼
     - parameter buttonNumber:   選中的按鈕號碼
     */
    func didSelectIncorrentButtonFrom(
        QuestionCollectionView collectionView: WCQuestionCollectionView,
        QuestionNumber currentNumber: Int,
        AnswerButtonNumber buttonNumber: Int)
    
    /**
     點選 前往下一題的按鈕
     
     - parameter collectionView: WCQuestionCollectionView
     - parameter currentNumber:  當前的題目號碼
     */
    func didTapNextButtonFrom(
        QuestionCollectionView collectionView: WCQuestionCollectionView,
        QuestionNumber currentNumber: Int)
    
    /**
     點選 再測試一次的按鈕
     
     - parameter collectionView: WCQuestionCollectionView
     */
    func didTapAgainButtonFrom(QuestionCollectionView collectionView: WCQuestionCollectionView)
    
    /**
     點選 測試其他題目的按鈕
     
     - parameter collectionView: WCQuestionCollectionView
     */
    func didTapOtherButtonFrom(QuestionCollectionView collectionView: WCQuestionCollectionView)
}

class WCQuestionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, WCQuestionAnswerViewDelegate, WCExamResultViewDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    // Private variables
    fileprivate var questionCollectionView: UICollectionView!

    // Public variables
    internal var delegate: WCQuestionCollectionViewDelegate?
    internal var questionTitles: [WCVocabularyModel]? = [WCVocabularyModel]()
    internal var answerTitles: [[WCVocabularyModel]]? = [[WCVocabularyModel]]()
    internal var answerResults: [Bool]?
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialQuestionCollectionView()
        answerResults = [Bool]()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
//        initialQuestionCollectionView()
//        answerResults = [Bool]()
    }
    
    
    /// Initial with mutiple variables
    ///
    /// - Parameters:
    ///   - frame: CGRect
    ///   - questionArray: WCVocabularyModel array
    ///   - answerArrayOfArray: WocabularyModel array
    convenience init(frame: CGRect, QuestionTitles questionArray:[WCVocabularyModel], AnsertTitles answerArrayOfArray:[[WCVocabularyModel]]) {
        self.init(frame: frame)
        
        questionTitles = questionArray
        answerTitles = answerArrayOfArray
        initialQuestionCollectionView()
    }
    
    fileprivate func initialQuestionCollectionView() {
        questionCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: WCQuestionCollectionViewFlowLayout())
        questionCollectionView.register(WCQuestionCollectionViewCell.self, forCellWithReuseIdentifier: "QuestionCell")
        questionCollectionView.dataSource = self
        questionCollectionView.delegate = self
        questionCollectionView.isScrollEnabled = false
        self.addSubview(questionCollectionView)
    }
    
    // MARK: - UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let questionViewCell: WCQuestionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! WCQuestionCollectionViewCell
        questionViewCell.questionAnswerViewDelegate = self
        questionViewCell.indexPath = indexPath
        questionViewCell.questionAnswerViewDelegate = self
        questionViewCell.examResultViewDelegate = self
        
        if (questionTitles?.count)! > 0  && (answerTitles?.count)! > 0 {
            questionViewCell.questionAnswerView?.setQuestionButtonTitle(questionTitles![(indexPath as NSIndexPath).row])
            
            if answerTitles![(indexPath as NSIndexPath).row].count > 0 {
                questionViewCell.questionAnswerView?.setAnswerButtonsTitle(answerTitles![(indexPath as NSIndexPath).row])
            }
        }
        
        return questionViewCell
    }
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - WCQuestionAnswerView Delegate
    func didTapQuestionTitleButton(QuestionNumber currentNumber: Int) {
        delegate?.didTapQuestionTitleButtonFrom(QuestionCollectionView: self, QuestionNumber: currentNumber)
    }
    
    func didSelectCorrect(AnswerButtonNumber buttonNumer: Int, QuestionNumber currentNumber: Int) {
        delegate?.didSelectCorrentButtonFrom(QuestionCollectionView: self, QuestionNumber: currentNumber, AnswerButtonNumber: buttonNumer)
    }
    
    func didSelectIncorrect(AnswerButtonNumber buttonNumber: Int, QuestionNumber currentNumber: Int) {
        delegate?.didSelectIncorrentButtonFrom(QuestionCollectionView: self, QuestionNumber: currentNumber, AnswerButtonNumber: buttonNumber)
    }
    
    func didTapNextButton(_ currentQuestionNumber: Int) {
        let nexIndexPtah = IndexPath(row: currentQuestionNumber + 1, section: 0)
        questionCollectionView.scrollToItem(at: nexIndexPtah, at: .centeredHorizontally, animated: true)
        delegate?.didTapNextButtonFrom(QuestionCollectionView: self, QuestionNumber: currentQuestionNumber)
    }
    
    // MARK: - WCExamResultView Delegate
    func didTapAgainButton() {
        let recoverIndexPath = IndexPath(row: 0, section: 0)
        questionCollectionView.scrollToItem(at: recoverIndexPath, at: .centeredHorizontally, animated: true)
        delegate?.didTapAgainButtonFrom(QuestionCollectionView: self)
    }
    
    func didTapOtherButton() {
        delegate?.didTapOtherButtonFrom(QuestionCollectionView: self)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
