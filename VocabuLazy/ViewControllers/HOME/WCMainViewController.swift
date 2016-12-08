//
//  WCMainViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/21.
//  Copyright (c) 2015年 Wishcan. All rights reserved.
//

import UIKit

class WCMainViewController: UIViewController {

    // ---------------------------------------------------------------------------------------------
    // MARK : - Variables
    // Define
    let Button_Top_Inset_Ratio = CGFloat(30.0 / 960.0)
    let Button_Left_Inset_Ratio = CGFloat(44.0 / 540.0)
    let Button_Right_Inset_Ratio = CGFloat(44.0 / 540.0)
    let Button_Middle_Inset_Ratio = CGFloat(85.0 / 540.0)
    let Button_Bottom_Inset_Ratio = CGFloat(87.0 / 960.0)
    let Button_Size_Ratio = CGFloat(203.0 / 960.0)

    let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
    let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    
    let screenSize : CGSize = UIScreen.main.bounds.size
    
    // Public variable
    var levelsArray = [[WCVocabularyModel]]()
    var rawData = [WCVocabularyModel]()
    
    var toeic_toeflCategory = [WCToeicToeflCategoryModel]()
    var toeicData = [WCVocabularyModel]()
    var toeflData = [WCVocabularyModel]()
    var levelTitleString = [String]()
    
    dynamic var isViewAppear = true

    @IBOutlet var backgroundScrollView: UIScrollView!


    // ---------------------------------------------------------------------------------------------
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 清除下一個 ViewController 的 BackButtonItem 的字
        let nillBackButtonItem = UIBarButtonItem()
        nillBackButtonItem.title = ""
        self.navigationItem.backBarButtonItem = nillBackButtonItem
        
        readToeic_ToeflCategory()
        
        readVocabularyFromStorage()
        readToeicVocabularyFromStorage()
        readToeflVocabularyFromStorage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewAppear = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Read vocabularies from Vocabulary.json
    fileprivate func readVocabularyFromStorage() {
        StorageManager.getVocabularyDataFromFileWithSuccess { (data) -> Void in
            do {
                let vocabularyArray : NSArray = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSArray;
                for vocabulary in vocabularyArray {
                    self.rawData.append(
                        WCVocabularyModel(vocabularyNSDictionary: vocabulary as! NSDictionary)
                    )
                }
                self.levelsArray = self.classifyVocabularies()
                
                // 新增高職單字的 Level
                for levelNumber in 0 ... 3 {
                    self.levelsArray.append(self.levelsArray[levelNumber])
                }
                
                self.setLevelButtons()
            }
            catch let error as NSError {
                printLog("error = ", error)
            }
        };
    }
    
    fileprivate func readToeicVocabularyFromStorage() {
        StorageManager.getToeicDataFromFileWithSuccess { (data) in
            do {
                let toeicArray: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in toeicArray {
                    self.toeicData.append(WCVocabularyModel(vocabularyNSDictionary: jsonData))
                }
            }
            catch let error as NSError {
                printLog("error = %@", error.description)
            }
        }
    }
    
    fileprivate func readToeflVocabularyFromStorage() {
        StorageManager.getToeflDataFromFileWithSuccess { (data) in
            do {
                let toeicArray: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in toeicArray {
                    self.toeflData.append(WCVocabularyModel(vocabularyNSDictionary: jsonData))
                }
            }
            catch let error as NSError {
                printLog("error = %@", error.description)
            }
        }
    }
    
    fileprivate func readToeic_ToeflCategory() {
        StorageManager.getToeic_ToeflCategoryWithSuccess { (data) in
            do {
                let categoryArray: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [NSDictionary]
                for jsonData in categoryArray {
                    self.toeic_toeflCategory.append(WCToeicToeflCategoryModel(toeicToeflCatrgoryNSDictionary: jsonData))
                }
            }
            catch let error as NSError {
                printLog("error = %@", error.description)
            }
        }
    }
    
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Set UI
    /**
     設定 WCMaterialButton 的位置
     */
    fileprivate func setLevelButtons() {
        let buttonTopInset = screenSize.height * Button_Top_Inset_Ratio
        let buttonLeftInset = screenSize.width * Button_Left_Inset_Ratio
        let buttonRightInset = screenSize.width * Button_Right_Inset_Ratio
        let buttonButtomInset = screenSize.height * Button_Bottom_Inset_Ratio
        let buttonSize = CGSize(width: screenSize.height * Button_Size_Ratio, height: screenSize.height * Button_Size_Ratio)
        
        var levelStringArray: [String] = [String]()
        
        for toeicToeflNumber in toeic_toeflCategory {
            levelStringArray.append(toeicToeflNumber.textbookType)
        }
        
        for lessonNumber in 1 ... levelsArray.count {
            var levelString: String
            if lessonNumber < 7 {
                // 必考 7000 單字
                levelString = "必考7000單字\n Level " + String(lessonNumber)
            }
            else {
                // 高職單字
                levelString = "高職單字\n Level " + String(lessonNumber - 6)
            }
            levelStringArray.append(levelString)
        }
        
        // Toeic and Toefl vocabulaires
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let buttonItemHeight = buttonTopInset + buttonSize.height + buttonButtomInset
        backgroundScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: buttonItemHeight * (CGFloat(levelStringArray.count / 2)) + tabBarHeight!)
        
        // 排列 button 位置
        for i in 0..<levelStringArray.count {
            var levelButton : WCMaterialButton!
            let row = i / 2
            
            let y = buttonTopInset + (buttonButtomInset + buttonSize.height) * CGFloat(row)
            levelButton = WCMaterialButton(frame: (i % 2 == 0) ? CGRect(x: buttonLeftInset, y: y, width: buttonSize.width, height: buttonSize.height) : CGRect(x: screenSize.width - buttonRightInset - buttonSize.width, y: y, width: buttonSize.width, height: buttonSize.height))
            
            if (row % 2 != 0) {
                levelButton.backgroundColor = WC_Yellow_Color
            }
            else {
                levelButton.backgroundColor = WC_Green_Color
            }
            levelButton.tag = i;
            levelButton.setTitle(levelStringArray[i], for: UIControlState())
            levelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            levelButton.addTarget(self, action: #selector(WCMainViewController.levelButtonsAction(_:)), for: UIControlEvents.touchUpInside)
            
            backgroundScrollView.addSubview(levelButton)
            
            levelTitleString.append(levelStringArray[i])
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Classfy vocabularies
    /**
     單字分類
     
     - returns: Array of array of WCVocabularyModels
     */
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

    // ---------------------------------------------------------------------------------------------
    // MARK: - Buttons action
    @IBAction func levelButtonsAction(_ sender: UIButton) {

        // Navigation controller push view controller
        let lessonChooseViewController : WCLessonChooseViewController = (self.storyboard!.instantiateViewController(withIdentifier: "LessonChoosePage") as! WCLessonChooseViewController)
        
        if sender.tag < 3 {
            lessonChooseViewController.levelString = levelTitleString[sender.tag]
            if sender.tag == 0 {
                lessonChooseViewController.toeicOrToeflData = toeicData
            }
            else {
                lessonChooseViewController.toeicOrToeflData = toeflData
            }
            lessonChooseViewController.toeicOrToeflCategory = toeic_toeflCategory[sender.tag]
        }
        else {
            lessonChooseViewController.levelString = levelTitleString[sender.tag].replacingOccurrences(of: "\n", with: "")
            lessonChooseViewController.lessonsVocabularyArray = levelsArray[sender.tag - 3]
        }
        
        self.navigationController!.pushViewController(lessonChooseViewController, animated: true)
        
        isViewAppear = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
