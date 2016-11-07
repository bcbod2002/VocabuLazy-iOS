//
//  WCLessonChooseViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/21.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

class WCLessonChooseViewController: UIViewController, WCLessonChooseTableViewDelegate
{
    let screenSize : CGSize = UIScreen.main.bounds.size;
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height;
    var levelString: String = ""
    var lessonsVocabularyArray = [WCVocabularyModel]()
    var oneLevelVocabularyArray = [[WCVocabularyModel]]()

    var lessonChooseTableView: WCLessonChooseTableView!;


    // MARK: - View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = levelString
        
        // BackButtonItem 不顯示任何的字
        let nillBackButtonItem = UIBarButtonItem()
        nillBackButtonItem.title = ""
        self.navigationItem.backBarButtonItem = nillBackButtonItem
        oneLevelVocabularyArray = rearrangeArrayDimension(lessonsVocabularyArray, partition: 40)!
        
        lessonChooseTableView = WCLessonChooseTableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), totalItemNumber: oneLevelVocabularyArray.count);
        lessonChooseTableView.delegate = self;
        self.navigationController?.setNavigationBarHidden(false, animated: true);

        self.view.addSubview(lessonChooseTableView);
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
    func tableView(_ tableView: WCLessonChooseTableView, didSelectItemAtIndexPath indexPath: IndexPath)
    {
        let lessonNumber = UInt((indexPath as NSIndexPath).section * 5 + (indexPath as NSIndexPath).row);
        let wordPlayViewController : WCWordPlayViewController = self.storyboard?.instantiateViewController(withIdentifier: "WordPlayPage") as! WCWordPlayViewController;

        wordPlayViewController.levelString = self.levelString
        wordPlayViewController.allLessonsArray = oneLevelVocabularyArray
        wordPlayViewController.foregroundLessonNumber = lessonNumber;
        self.navigationController?.pushViewController(wordPlayViewController, animated: true);
    }
}
