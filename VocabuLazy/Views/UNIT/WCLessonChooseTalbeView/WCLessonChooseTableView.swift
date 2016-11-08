//
//  WCLessonChooseTableView.swift
//  Swallow
//
//  Created by Goston on 2015/9/22.
//  Copyright © 2015年 WishCan. All rights reserved.
//

import UIKit

protocol WCLessonChooseTableViewDelegate
{
    /**
    WCLessonChooseTableView did select WCLessonChooseCell index path

    - parameter tableView: WCLessonChooseTableView
    - parameter indexPath: Selected index path
    */
    func tableView(_ tableView: WCLessonChooseTableView, didSelectItemAtIndexPath indexPath: IndexPath);
}

class WCLessonChooseTableView: UIView, UICollectionViewDelegate, UICollectionViewDataSource
{
    let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0);
    let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0);

    // Public variable
    var delegate : WCLessonChooseTableViewDelegate?;

    // Private variable
    fileprivate var lessonChooseFlowLayout : WCLessonChooseCollectionViewFlowLayout!;
    fileprivate var lessonChooseCollectionView : UICollectionView!;
    
    fileprivate var itemTotalNumber : Int = 0;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        
        lessonChooseFlowLayout = WCLessonChooseCollectionViewFlowLayout();
        lessonChooseFlowLayout.setCollectionViewSize(frame.size);
        lessonChooseCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: lessonChooseFlowLayout);
        lessonChooseCollectionView.dataSource = self;
        lessonChooseCollectionView.delegate = self;
        lessonChooseCollectionView.backgroundColor = UIColor.white;
        lessonChooseCollectionView.register(WCLessonChooseCell.self, forCellWithReuseIdentifier: "LessonChooseCell");
        self.addSubview(lessonChooseCollectionView);
    }
    
    convenience init(frame: CGRect, totalItemNumber: Int)
    {
        self.init(frame: frame);
        itemTotalNumber = totalItemNumber;
    }
    
    // MARK : - UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if ((itemTotalNumber % 5) > 0)
        {
            return itemTotalNumber / 5 + 1;
        }
        else
        {
            return itemTotalNumber / 5;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //FIXME: 內容需驗證2
        let tmpRow = (itemTotalNumber - section * 5);
        if(tmpRow < 5)
        {
            
            return itemTotalNumber % 5;
        }
        else
        {
            return 5;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonChooseCell", for: indexPath) as! WCLessonChooseCell;
        if ((indexPath as NSIndexPath).section % 2 == 0)
        {
            cell.setButtonColor(WC_Green_Color);
        }
        else
        {
            cell.setButtonColor(WC_Yellow_Color);
        }

        let buttonNumber = (indexPath as NSIndexPath).section * 5 + (indexPath as NSIndexPath).row + 1;
        cell.setButtonNumber(String(buttonNumber));
        
        return cell;
    }
    
    // MARK : - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        delegate?.tableView(self, didSelectItemAtIndexPath: indexPath);
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
