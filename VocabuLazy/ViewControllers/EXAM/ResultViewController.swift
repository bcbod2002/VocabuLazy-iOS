//
//  ResultViewController.swift
//  Swallow
//
//  Created by 蘇健豪1 on 2016/9/18.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var resultImage: UIImageView!
    var rightAnswer : Int = 0
    var totalQuestion = 40
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "測驗結果"
        drawView()
    }
    
    fileprivate func drawView() {
        drawLabelOne()
        drawLabelTwo()
        drawAgainButton()
        drawOthersButton()
    }
    
    fileprivate func drawLabelOne() {
        labelOne.text = "答對\(rightAnswer)題"
        labelOne.textColor = UIColor(red: 102/255, green: 108/255, blue: 120/255, alpha: 1)
        labelOne.font = UIFont.systemFont(ofSize: 16.5)
    }
    
    fileprivate func drawLabelTwo() {
        labelTwo.text = "答對率\(Float(rightAnswer)/Float(totalQuestion) * 100)％"
        labelTwo.textColor = UIColor(red: 102/255, green: 108/255, blue: 120/255, alpha: 1)
        labelTwo.font = UIFont.systemFont(ofSize: 16.5)
    }
    
    fileprivate func drawAgainButton() {
        var againButton : WCMaterialButton?
        let y = self.view.frame.height * 0.6
        againButton = WCMaterialButton(frame: CGRect(x: self.view.frame.width/2 - 112, y: y, width: 224, height: 53), cornerRadious: 29)
        againButton?.setTitle("再試一次", for: UIControlState())
        againButton?.backgroundColor = UIColor(red: 102/255, green: 108/255, blue: 120/255, alpha: 1)
        view.addSubview(againButton!)
        
        againButton?.addTarget(self, action: #selector(againButtonClick(_:)), for: .touchUpInside)
    }
    
    fileprivate func drawOthersButton() {
        var othersButton : WCMaterialButton?
        let y = self.view.frame.height * 0.71
        othersButton = WCMaterialButton(frame: CGRect(x: self.view.frame.width/2 - 112, y: y, width: 224, height: 53), cornerRadious: 29)
        othersButton?.setTitle("試試其他單元", for: UIControlState())
        othersButton?.backgroundColor = UIColor(red: 102/255, green: 108/255, blue: 120/255, alpha: 1)
        view.addSubview(othersButton!)
        
        othersButton?.addTarget(self, action: #selector(othersButtonClick(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func againButtonClick(_ sender: UIButton) {
        let viewControllers = self.navigationController?.viewControllers
        for view in viewControllers! {
            if view.isKind(of: WCQuestionViewController.self) {
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
    
    @objc fileprivate func othersButtonClick(_ sender: UIButton) {
        let viewControllers = self.navigationController?.viewControllers
        for view in viewControllers! {
            if view.isKind(of: WCExamChooseViewController.self) || view.isKind(of: EListTableViewController.self) {
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
}
