//
//  WCExamChooseViewController.swift
//  Swallow
//
//  Created by Goston on 2016/4/7.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCExamChooseViewController: UIViewController, WCLessonChooseTableViewDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var levelNumber : UInt = 0
    var lessonsVocabularyArray = [WCVocabularyModel]()    
    var oneLevelVocabularyArray = [[WCVocabularyModel]]()
    
    // Toeic and Toefl vocabularies
    var toeicOrToeflData = [WCVocabularyModel]()
    var toeicOrToeflCategory = WCToeicToeflCategoryModel()
    
    // Private variable
    fileprivate var examChooseTableView: WCLessonChooseTableView?
    fileprivate let screenSize: CGSize = UIScreen.main.bounds.size
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        if lessonsVocabularyArray.count > 0 {
            oneLevelVocabularyArray = rearrangeArrayDimension(lessonsVocabularyArray, partition: 40)!
        }
        else {
            oneLevelVocabularyArray = mapToeic_ToeflDimension()!
        }
        
        self.title = "選擇冊次"
        examChooseTableView = WCLessonChooseTableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - navigationBarHeight! - statusBarHeight), totalItemNumber: oneLevelVocabularyArray.count)
        examChooseTableView?.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.addSubview(examChooseTableView!)
        
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Rearrange vocabularies array dimension
    fileprivate func rearrangeArrayDimension<T>(_ rearrangeArray: [T], partition: Int) -> [[T]]? {
        guard partition > 0 else {
            return nil
        }
        
        var boundary = 0
        var twoDimensionBucket = [[T]]()
        var oneDimensionBucket = [T]()
        
        for object in rearrangeArray {
            if boundary < (partition - 1) {
                oneDimensionBucket.append(object)
                boundary += 1
            }
            else {
                oneDimensionBucket.append(object)
                let tmpBucket = [T](oneDimensionBucket)
                twoDimensionBucket.append(tmpBucket)
                
                oneDimensionBucket.removeAll()
                boundary = 0
            }
        }
        
        return twoDimensionBucket
    }
    
    fileprivate func mapToeic_ToeflDimension() -> [[WCVocabularyModel]]? {
        guard toeicOrToeflData.count > 0 else {
            return nil
        }
        var twoDimensionBucket = [[WCVocabularyModel]]()
        for category in toeicOrToeflCategory.textbookContent {
            var oneDimensionBucket = [WCVocabularyModel]()
            for content in category.lessonContent {
                for vocabulary in toeicOrToeflData {
                    if content == vocabulary.identity {
                        oneDimensionBucket.append(vocabulary)
                    }
                }
            }
            twoDimensionBucket.append(oneDimensionBucket)
        }
        
        return twoDimensionBucket
    }

    // ---------------------------------------------------------------------------------------------
    // MARK: - WCLessonChooseTableViewDelegate
    func tableView(_ tableView: WCLessonChooseTableView, didSelectItemAtIndexPath indexPath: IndexPath){
        let questionViewController = storyboard?.instantiateViewController(withIdentifier: "QuestionPage") as! WCQuestionViewController
        questionViewController.vocabularyArray = oneLevelVocabularyArray[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(questionViewController, animated: true)
    }
}
