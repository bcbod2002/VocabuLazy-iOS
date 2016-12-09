//
//  WCQuestionViewController.swift
//  Swallow
//
//  Created by Goston on 2016/4/7.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit
import AVFoundation

class WCQuestionViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var vocabularyArray: [WCVocabularyModel]!
    
    var questionView : WCMaterialButton?
    let questionViewTopInset = CGFloat(40)
    let Button_Left_Inset_Ratio = CGFloat(44.0 / 540.0)
    let screenSize = UIScreen.main.bounds.size
    var answer : [String] = ["", "", "", ""]
    var question = ""
    let r = CGFloat(0.34)
    
    var correctIndex = 0
    var questionIndex = 0
    var correctAnswerNumber = 0
    
    var wordSpeechPlayer: WCWordSpeechPlayer?
    
    // IBOutlet
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "英翻中"

        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeQuestionAndAnswerView()
        
        questionIndex = 0
        loadData(questionIndex)
        drawView()
        
        initialWordSpeechPlayer()
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Initial WCWordSpeechPlayer
    fileprivate func initialWordSpeechPlayer() {
        wordSpeechPlayer = WCWordSpeechPlayer(withDelegate: self)
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Draw all view
    fileprivate func drawView() {
        drawLineView()
        drawQuestionView()
        drawAnswerButton()
        drawNextButton()
        questionNumberLabel.text = "\(questionIndex + 1)/\(vocabularyArray.count)"
    }
    
    /// Draw the line
    fileprivate func drawLineView() {
        let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
        let buttonLeftInset = screenSize.width * Button_Left_Inset_Ratio
        let height = CGFloat(19)
        
        let leftlineView = UIView(frame: CGRect(x: buttonLeftInset, y: height, width: self.view.frame.width * 0.3, height: 5))
        leftlineView.backgroundColor = WC_Green_Color
        self.view.addSubview(leftlineView)
        
        let rightlineView = UIView(frame: CGRect(x: self.view.frame.width - buttonLeftInset - self.view.frame.width * 0.3, y: height, width: self.view.frame.width * 0.3, height: 5))
        rightlineView.backgroundColor = WC_Green_Color
        self.view.addSubview(rightlineView)
    }
    
    
    /// Draw the question
    fileprivate func drawQuestionView() {
        let buttonLeftInset = screenSize.width * Button_Left_Inset_Ratio
        let buttonHeight = screenSize.height * r
        
        // QuestionButton
        questionView = WCMaterialButton(frame: CGRect(x: screenSize.width / 2, y: questionViewTopInset + (buttonHeight / 2), width: 0, height: 0), cornerRadious: 10)
        questionView?.addTarget(self, action: #selector(questionButtonTouchDown(_:)), for: .touchUpInside)
        let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
        self.questionView!.backgroundColor = WC_Green_Color
        self.view.addSubview(self.questionView!)
        
        
        
        // Animation
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions() , animations: {
            self.questionView?.frame = CGRect(x: buttonLeftInset, y: self.questionViewTopInset, width: self.screenSize.width - buttonLeftInset * 2, height: buttonHeight)
        }, completion: { _ in
            self.questionView?.setTitle(self.question, for: UIControlState())
            
            // Add audio image view
            let audioImageView = UIImageView(image: UIImage(named: "ExamAudio"))
            audioImageView.frame = CGRect(x: ((self.questionView?.bounds.width)! - 60) / 2, y: (self.questionView?.bounds.height)! - 60 - 10, width: 60, height: 60)
            self.questionView?.addSubview(audioImageView)
        })
    }
    
    
    /// Draw the answer
    fileprivate func drawAnswerButton() {
        let buttonGap = CGFloat(10)
        let buttonTopInset = questionViewTopInset + questionView!.frame.size.height + buttonGap
        let buttonLeftInset = screenSize.width * Button_Left_Inset_Ratio
        let height = (questionView?.frame.size.height)! * 0.2
        var delayTime : Double
        
        for i in 0...3 {
            var answerButton : WCMaterialButton?
            answerButton = WCMaterialButton(frame: CGRect(x: screenSize.width / 2, y: buttonTopInset + (height + buttonGap) * CGFloat(i) + (height / 2) ,width: 0, height: 0), cornerRadious: 10)
            answerButton?.backgroundColor = UIColor(red:219/255, green:220/255, blue:220/255, alpha:1.0)
            self.view.addSubview(answerButton!)
            
            answerButton?.tag = 2
            answerButton?.addTarget(self, action: #selector(answerButtonTouchDown(_:)), for: .touchDown)
            answerButton?.addTarget(self, action: #selector(answerButtonTouchUp(_:)), for: .touchUpInside)
            
            delayTime = questionIndex == 0 ? (0.5 * Double(i + 1)) : 0
            UIView.animate(withDuration: 1, delay:delayTime, options:UIViewAnimationOptions() , animations: {
                answerButton?.frame = CGRect(x: buttonLeftInset, y: buttonTopInset + (height + buttonGap) * CGFloat(i) , width: self.screenSize.width - buttonLeftInset * 2, height: height)
            }, completion: { _ in
                answerButton?.setTitle(self.answer[i], for: UIControlState())
            })
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Move to next question
    fileprivate func nextQuestion() {
        questionIndex += 1
        loadData(questionIndex)
        
        removeQuestionAndAnswerView()
        drawView()
    }
    
    fileprivate func removeQuestionAndAnswerView() {
        for view in self.view.subviews {
            if view.isKind(of: WCMaterialButton.self) {
                view.removeFromSuperview()
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Create answers
    fileprivate func loadData(_ lessonNumber: NSInteger) {
        answer = ["", "", "", ""]
        
        let vocabulary = vocabularyArray[lessonNumber]
        question = vocabulary.english
        
        correctIndex = Int(arc4random_uniform(4))  // 隨機產生正確答案的位置
        answer[correctIndex] = vocabulary.chinese
        
        for wrongIndex in 0...3 {  // 隨機產三個錯誤的答案
            if wrongIndex != correctIndex {  // 放正確答案的位置不需要處理
                var wrongVocabulary = vocabularyArray[Int(arc4random_uniform(uint(vocabularyArray.count)))]  // 檢查錯誤答案是否有重複
                
                for i in 0...wrongIndex {
                    while wrongVocabulary.chinese == answer[i] || wrongVocabulary.chinese == answer[correctIndex] {
                        wrongVocabulary = vocabularyArray[Int(arc4random_uniform(uint(vocabularyArray.count)))]
                    }
                }
                
                answer[wrongIndex] = wrongVocabulary.chinese
            }
        }
    }
    
    
    /// Draw the next button
    fileprivate func drawNextButton() {
        var nextButton : WCMaterialButton?
        let x = screenSize.width - 126 - screenSize.width * Button_Left_Inset_Ratio
        let y = screenSize.height * r * 9/5 + 40 + 10 * 4 + 13
        nextButton = WCMaterialButton(frame: CGRect(x: x, y: y, width: 126, height: 40), cornerRadious: 20)
        nextButton?.setTitle("NEXT", for: UIControlState())
        nextButton?.backgroundColor = UIColor(red:219/255, green:220/255, blue:220/255, alpha:1.0)
        nextButton?.alpha = 0
        view.addSubview(nextButton!)
        
        nextButton?.addTarget(self, action: #selector(nextButtonClick(_:)), for: .touchUpInside)
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Material button action
    @objc fileprivate func nextButtonClick(_ sender: UIButton) {
        if questionIndex == vocabularyArray.count - 1 {
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result") as! ResultViewController
            nextViewController.totalQuestion = vocabularyArray.count
            nextViewController.rightAnswer = correctAnswerNumber
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            nextQuestion()
        }
    }
    
    @objc fileprivate func answerButtonTouchUp(_ sender: UIButton) {
        sender.bounds.size.height = sender.bounds.size.height * 100 / 93
        sender.bounds.size.width = sender.bounds.size.width * 100 / 93
        
        for v in view.subviews {
            if v.tag == 2 {
                v.backgroundColor = UIColor(red: 102/255, green: 108/255, blue: 120/255, alpha: 1)
                
                v.isUserInteractionEnabled = false
            }
            
            if v.alpha == 0 {
                v.alpha = 1
            }
        }
        sender.backgroundColor = UIColor(red:1.00, green:0.81, blue:0.33, alpha:1.0)
        
        
        let w = sender.frame.height * (5/7)
        let y = (sender.frame.height - w) / 2
        let imageView = UIImageView(frame: CGRect(x: y + 2, y: y, width: w, height: w))
        if sender.currentTitle! == answer[correctIndex] {
            imageView.image = UIImage(named: "correct")
            correctAnswerNumber += 1
        } else {
            imageView.image = UIImage(named: "wrong")
            for view in self.view.subviews {
                if view.tag == 2 {
                    let button = view as! WCMaterialButton
                    if button.currentTitle! == answer[correctIndex] {
                        let imageView2 = UIImageView(frame: CGRect(x: y + 2, y: y, width: w, height: w))
                        imageView2.image = UIImage(named: "correct")
                        button.addSubview(imageView2)
                    }
                    
                }
            }
        }
        sender.addSubview(imageView)
    }
    
    @objc fileprivate func answerButtonTouchDown(_ sender: UIButton) {
        for v in view.subviews {
            if v.tag == 2 {
                v.backgroundColor = UIColor(red:0.40, green:0.42, blue:0.47, alpha:1.0)
            }
        }
        
        sender.bounds.size.height = sender.bounds.size.height * 0.93
        sender.bounds.size.width = sender.bounds.size.width * 0.93
    }
    
    @objc fileprivate func questionButtonTouchDown(_ sender: UIButton) {
        let speechString = sender.titleLabel?.text
        wordSpeechPlayer?.startSpeech(speechString: speechString!, language: .English)
    }
}
