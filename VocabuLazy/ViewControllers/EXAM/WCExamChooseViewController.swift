//
//  WCExamChooseViewController.swift
//  Swallow
//
//  Created by Goston on 2016/4/7.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

enum ExamType: Int
{
    case unitExam = 0
    case listExam
}

class WCExamChooseViewController: UIViewController, WCLessonChooseTableViewDelegate
{
    var levelNumber : UInt = 0;
    var lessonsVocabularyArray = [WCVocabularyModel]()    
    var oneLevelVocabularyArray = [[WCVocabularyModel]]()
    
    // Private variable
    fileprivate var examChooseTableView: WCLessonChooseTableView?;
    fileprivate let screenSize: CGSize = UIScreen.main.bounds.size;
    
    // Public variable
    var examType: ExamType = ExamType(rawValue: 0)!;
    
    
    // MARK: - View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        oneLevelVocabularyArray = rearrangeArrayDimension(lessonsVocabularyArray, partition: 40)!
        
        self.title = "選擇冊次";
        examChooseTableView = WCLessonChooseTableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), totalItemNumber: oneLevelVocabularyArray.count);
        examChooseTableView?.delegate = self;
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.view.addSubview(examChooseTableView!);
        
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
    }
    
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

    // MARK: - WCLessonChooseTableView Delegate
    func tableView(_ tableView: WCLessonChooseTableView, didSelectItemAtIndexPath indexPath: IndexPath){
        let questionViewController = storyboard?.instantiateViewController(withIdentifier: "QuestionPage") as! WCQuestionViewController
        questionViewController.vocabularyArray = oneLevelVocabularyArray[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(questionViewController, animated: true)
    }
}
