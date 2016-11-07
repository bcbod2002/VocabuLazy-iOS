//
//  EHomeViewController.swift
//  Swallow
//
//  Created by 蘇健豪1 on 2016/9/1.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class EHomeViewController: UIViewController {
    var levelsArray = [[WCVocabularyModel]]()
    var rawData = [WCVocabularyModel]()
    var levelTitleString = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "單元練習"
        
        loadData()
        
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
    }
    
    fileprivate func drawView() {
        let Button_Top_Inset_Ratio = CGFloat(30.0 / 960.0);
        let Button_Left_Inset_Ratio = CGFloat(44.0 / 540.0);
        let Button_Right_Inset_Ratio = CGFloat(44.0 / 540.0);
        let Button_Bottom_Inset_Ratio = CGFloat(87.0 / 960.0);
        let Button_Size_Ratio = CGFloat(203.0 / 960.0);
        
        let screenSize = UIScreen.main.bounds.size;
        let buttonTopInset = screenSize.height * Button_Top_Inset_Ratio;
        let buttonLeftInset = screenSize.width * Button_Left_Inset_Ratio;
        let buttonRightInset = screenSize.width * Button_Right_Inset_Ratio;
        let buttonButtomInset = screenSize.height * Button_Bottom_Inset_Ratio;
        let buttonSize = CGSize(width: screenSize.height * Button_Size_Ratio, height: screenSize.height * Button_Size_Ratio);
        
        let buttonItemHeight = buttonTopInset + (buttonSize.height + (buttonButtomInset / 2));
        
        let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0);
        let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0);
        
        let c = levelsArray.count
        let scrollView = UIScrollView.init()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: buttonItemHeight * CGFloat((c+1) / 2) + buttonTopInset + buttonButtomInset * 2)
        self.view.addSubview(scrollView);
        
        var button : WCMaterialButton?
        for i in 0...(c - 1) {
            
            // 區分 必考7000單字 與 高職單字
            var levelString: String
            if i < 6 {
                levelString = "必考7000單字\n Level " + String(i + 1)
            }
            else {
                levelString = "高職單字\n Level " + String(i - 5)
            }
            
            let row = i / 2;
            let y = buttonTopInset + (buttonButtomInset + buttonSize.height) * CGFloat(row)
            
            button = WCMaterialButton(frame: (i % 2 == 0) ? CGRect(x: buttonLeftInset, y: y, width: buttonSize.width, height: buttonSize.height) : CGRect(x: screenSize.width - buttonRightInset - buttonSize.width, y: y, width: buttonSize.width, height: buttonSize.height))
            button?.backgroundColor = (row % 2 == 0) ? WC_Green_Color : WC_Yellow_Color
            button?.setTitle(levelString, for: UIControlState())
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            scrollView.addSubview(button!);
            
            button?.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            button?.tag = i;
        }
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Unit") as! WCExamChooseViewController
        nextViewController.levelNumber = UInt(sender.tag)
        nextViewController.lessonsVocabularyArray = levelsArray[sender.tag]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    fileprivate func loadData() {
        StorageManager.getVocabularyDataFromFileWithSuccess { (data) -> Void in
            do {
                let vocabularyArray : NSArray = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSArray;
                for vocabulary in vocabularyArray {
                    self.rawData.append(WCVocabularyModel(vocabularyNSDictionary: vocabulary as! NSDictionary))
                }
                self.levelsArray = self.classifyVocabularies()
                
                // 新增高職單字的 Level
                for levelNumber in 0 ... 3 {
                    self.levelsArray.append(self.levelsArray[levelNumber])
                }
                
                self.drawView()
            }
            catch let error as NSError {
                printLog("error = ", error)
            }
        }
    }
    
    fileprivate func classifyVocabularies() -> [[WCVocabularyModel]] {
        rawData.sort(by: { $0.level < $1.level })
        
        var levelBoundary: UInt = 1
        var bigBucket = [[WCVocabularyModel]]()
        var oneLevelBucket = [WCVocabularyModel]()
        
        for vocabularyModel in rawData {
            if vocabularyModel.level != levelBoundary {
                let tmpBucket = [WCVocabularyModel](oneLevelBucket)
                bigBucket.append(tmpBucket)
                
                levelBoundary = vocabularyModel.level
                oneLevelBucket.removeAll()
                oneLevelBucket.append(vocabularyModel)
            }
            else {
                oneLevelBucket.append(vocabularyModel)
            }
        }
        // 把最後一組加進去
        bigBucket.append(oneLevelBucket)
        
        return bigBucket
    }
}
