//
//  WCQuestionAnswerView.swift
//  Swallow
//
//  Created by Goston on 2016/4/11.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

// MARK: - Define
// Define variable
private let Answer_Number = 3;
private let ScreenSize: CGSize = UIScreen.main.bounds.size;
private let TopSpace: CGFloat = 50;
private let ButtonSpace: CGFloat = 12;
private let SideSpace: CGFloat = 20;
private let QuestionButtonHeight: CGFloat = 144;
private let AnswerButtonHeight: CGFloat = 48;
private let NextButtonHeight: CGFloat = 40;

// Define Color
private let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0);
private let WC_Gray_Color = UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0);
private let WC_DarkGray_Color = UIColor (red: 102.0 / 255.0, green: 108.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0);
private let Unselected_Answer_Background_Color = UIColor.gray;
private let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0);
private let Incorrect_Answer_Background_Color = UIColor();

// MARK: - Protocol
protocol WCQuestionAnswerViewDelegate
{
    /**
     點選問題按鈕
     
     - parameter currentNumber: 第幾題
     */
    func didTapQuestionTitleButton(QuestionNumber currentNumber: Int);
    
    /**
     選中正確的答案
     
     - parameter buttonNumer: 第幾個按鈕
     - parameter currentNumber: 第幾題
     */
    func didSelectCorrect(AnswerButtonNumber buttonNumer: Int, QuestionNumber currentNumber: Int);
    
    /**
     選中錯誤的答案
     
     - parameter buttonNumber: 第幾個按鈕
     - parameter currentNumber: 第幾題
     */
    func didSelectIncorrect(AnswerButtonNumber buttonNumber: Int, QuestionNumber currentNumber: Int);
    
    /**
     按下下一步的按鈕
     
     - parameter number: 目前的題數
     */
    func didTapNextButton(_ currentQuestionNumber: Int);
}

class WCQuestionAnswerView: UIView
{
    // Private variable
    fileprivate var questionTitleView: WCQuestionTitleView?;
    fileprivate var questionButton: WCMaterialButton?;
    fileprivate var answerButtons: [WCMaterialButton]? = [WCMaterialButton]();
    fileprivate var nextButton: WCMaterialButton?;
    fileprivate var questionModel: WCVocabularyModel?;
    fileprivate var answerModels: [WCVocabularyModel]?;
    
    // Public variable
    var delegate: WCQuestionAnswerViewDelegate?;
    var questionNumber: Int
    {
        get
        {
            return self.questionNumber;
        }
        set(setNumber)
        {
            questionTitleView?.setTitleString(String(setNumber) + "/10");
        }
    }
    var isButtonActive: Bool? = false;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.backgroundColor = UIColor.white;
        self.initialQuestionTitle();
        self.initialButtons();
    }
    
    fileprivate func initialQuestionTitle()
    {
        questionTitleView = WCQuestionTitleView(frame: CGRect(x: SideSpace, y: ButtonSpace, width: ScreenSize.width - (SideSpace * 2), height: 21));
        self.addSubview(questionTitleView!);
    }
    
    fileprivate func initialButtons()
    {
        initialQuestionButton();
        initialAnswerButtons();
        initialNextButton();
    }
    
    fileprivate func initialQuestionButton()
    {
        questionButton = WCMaterialButton(frame: CGRect(x: SideSpace, y: TopSpace, width: ScreenSize.width - (SideSpace * 2), height: QuestionButtonHeight), cornerRadious: 8);
        questionButton?.setTitleColor(UIColor.white, for: UIControlState());
        questionButton?.titleLabel?.font = UIFont (name: "DFHeiStd-W7", size: 30);
        questionButton?.addTarget(self, action: #selector(WCQuestionAnswerView.questionButtonAction(_:)), for: UIControlEvents.touchUpInside);
        questionButton?.backgroundColor = WC_Green_Color;
        self.addSubview(questionButton!);
    }
    
    fileprivate func initialAnswerButtons()
    {
        let questionButtonLastY = (questionButton?.bounds.height)! + (questionButton?.frame.origin.y)!;
        for i in 0...Answer_Number
        {
            let buttonYPosition = (AnswerButtonHeight + ButtonSpace) * CGFloat(i) + ButtonSpace;
            
            let answerButton = WCMaterialButton(frame: CGRect(x: SideSpace, y: questionButtonLastY + buttonYPosition, width: (questionButton?.bounds.width)!, height: AnswerButtonHeight), cornerRadious: 8);
            answerButton.materialAnimation = .examType;
            answerButton.setTitleColor(UIColor.black, for: UIControlState());
            answerButton.titleLabel?.font = UIFont (name: "DFHeiStd-W7", size: 22);
            answerButton.tag = i;
            answerButton.addTarget(self, action: #selector(WCQuestionAnswerView.answerButtonsAction(_:)), for: UIControlEvents.touchUpInside);
            answerButton.backgroundColor = WC_Gray_Color;
            answerButton.touchBeganColor = WC_DarkGray_Color;
            answerButtons?.append(answerButton);
            self.addSubview(answerButton);
        }
    }
    
    fileprivate func initialNextButton()
    {
        let nextButtonFirstX = (questionButton?.frame.origin.x)! + ((questionButton?.bounds.width)! / 2);
        let nextButtonFirstY = (answerButtons?.last?.frame.origin.y)! + (answerButtons?.last?.bounds.height)! + ButtonSpace;
        
        nextButton = WCMaterialButton(frame: CGRect(x: nextButtonFirstX, y: nextButtonFirstY, width: ((questionButton?.bounds.width)! / 2), height: NextButtonHeight), cornerRadious: NextButtonHeight / 2);
        nextButton?.addTarget(self, action: #selector(WCQuestionAnswerView.nextButtonAction(_:)), for: UIControlEvents.touchUpInside);
        nextButton?.setTitle("NEXT", for: UIControlState());
        nextButton?.setTitleColor(UIColor.black, for: UIControlState());
        nextButton?.backgroundColor = WC_Gray_Color;
        
        nextButton?.isUserInteractionEnabled = false;
        nextButton?.alpha = 0.0;
        
        self.addSubview(nextButton!);
    }
    
    /**
     設定 QuestionButton 的文字敘述
     
     - parameter questionModel: 傳入 WCVicabularyModel
     */
    func setQuestionButtonTitle(_ questionModel: WCVocabularyModel)
    {
        self.questionModel = questionModel;
        questionButton?.setTitle(questionModel.english, for: UIControlState());
    }
    
    /**
     設定 AnswerButton 的文字敘述
     
     - parameter answerModels: 傳入 WCVicabularyModel 的 array
     */
    func setAnswerButtonsTitle(_ answerModels: [WCVocabularyModel])
    {
        if answerModels.count == answerButtons?.count
        {
            self.answerModels = answerModels;
            for i in 0...(answerModels.count - 1)
            {
                let answerButton = answerButtons![i];
                let answerModel = answerModels[i]
                answerButton.setTitle(answerModel.chinese, for: UIControlState());
            }
        }
    }
    
    /**
     還原全部的按鈕狀態，由於此 View 會於下個 Cell 被重複使用，須還原狀態
     */
    func resetAllButtonStatus()
    {
        for answerButton in answerButtons!
        {
            answerButton.backgroundColor = WC_Gray_Color;
            answerButton.isUserInteractionEnabled = true;
            answerButton.setTitleColor(UIColor.black, for: UIControlState());
        }
        nextButton?.isUserInteractionEnabled = false;
        nextButton?.alpha = 0.0;
    }
    
    fileprivate func isAnswerCorrect(_ answerNumber: Int) -> Bool
    {
        if questionModel?.english == answerModels![answerNumber].english
        {
            delegate?.didSelectCorrect(AnswerButtonNumber: answerNumber, QuestionNumber: questionNumber);
            return true;
        }
        else
        {
            delegate?.didSelectIncorrect(AnswerButtonNumber: answerNumber, QuestionNumber: questionNumber);
            return false;
        }
    }
    
    // MARK: - UIButton action
    @IBAction func questionButtonAction(_ sender: UIButton)
    {
        printLog("questionButtonAction")
        delegate?.didTapQuestionTitleButton(QuestionNumber: questionNumber);
    }
    
    @IBAction func answerButtonsAction(_ sender: UIButton)
    {
        printLog("answerButtonsAction tag = ", sender.tag)
        if isAnswerCorrect(sender.tag) == true
        {
            sender.backgroundColor = WC_Yellow_Color;
        }
        else
        {
            
            for answerButton in answerButtons!
            {
                let determineModel = answerModels![answerButton.tag];
                if questionModel?.english == determineModel.english
                {
                    answerButton.backgroundColor = WC_Yellow_Color;
                }
                else
                {
                    answerButton.backgroundColor = WC_DarkGray_Color;
                }
            
                answerButton.isUserInteractionEnabled = false;
                answerButton.setTitleColor(UIColor.white, for: UIControlState());
            }
        }
        
        nextButton?.isUserInteractionEnabled = true;
        nextButton?.alpha = 1.0;
        
        isButtonActive = true;
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton)
    {
        delegate?.didTapNextButton(questionNumber);
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
