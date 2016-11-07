//
//  WCExamViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/21.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

class WCExamViewController: UIViewController {

    // MARK : - Define
    let Button_Top_Inset_Ratio = CGFloat(30.0 / 960.0);
    let Button_Left_Inset_Ratio = CGFloat(44.0 / 540.0);
    let Button_Right_Inset_Ratio = CGFloat(44.0 / 540.0);
    let Button_Middle_Inset_Ratio = CGFloat(85.0 / 540.0);
    let Button_Bottom_Inset_Ratio = CGFloat(87.0 / 960.0);
    let Button_Size_Ratio = CGFloat(203.0 / 960.0);
    
    let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0);
    let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0);
    
    var screenSize : CGSize = UIScreen.main.bounds.size;
    
    dynamic var isViewAppear = true

    // MARK: - View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setExamTypeButtons();
        
        let backButton = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        isViewAppear = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setExamTypeButtons()
    {
        let buttonTopInset = screenSize.height * Button_Top_Inset_Ratio;
        let buttonLeftInset = screenSize.width * Button_Left_Inset_Ratio;
        let buttonRightInset = screenSize.width * Button_Right_Inset_Ratio;
        let buttonButtomInset = screenSize.height * Button_Bottom_Inset_Ratio;
        let buttonSize = CGSize(width: screenSize.height * Button_Size_Ratio, height: screenSize.height * Button_Size_Ratio);
        
        for i in 0...1
        {
            var examTypeButton : WCMaterialButton?;
            let row = i / 2;
            if i % 2 != 0
            {
                examTypeButton = WCMaterialButton(frame: CGRect(x: screenSize.width - buttonRightInset - buttonSize.width, y: buttonTopInset + (buttonButtomInset + buttonSize.height) * CGFloat(row), width: buttonSize.width, height: buttonSize.height), cornerRadious: 10);
                examTypeButton?.setTitle("清單測驗", for: UIControlState());
                examTypeButton?.tag = 1;
            }
            else
            {
                examTypeButton = WCMaterialButton(frame: CGRect(x: buttonLeftInset, y: buttonTopInset + (buttonButtomInset + buttonSize.height) * CGFloat(row), width: buttonSize.width, height: buttonSize.height), cornerRadious: 10);
                examTypeButton?.setTitle("單元練習", for: UIControlState());
                examTypeButton?.tag = 0;
            }
            
            examTypeButton?.backgroundColor = WC_Green_Color;
            examTypeButton?.addTarget(self, action: #selector(WCExamViewController.examButtonAction(_:)), for: UIControlEvents.touchUpInside);
            
            view.addSubview(examTypeButton!);
        }
    }
    
    // MARK: - Buttons action
    @IBAction func examButtonAction(_ sender: UIButton)
    {
        let button = sender
        if button.tag == 0 {
            let examChooseViewController = self.storyboard?.instantiateViewController(withIdentifier: "EHome") as! EHomeViewController;
//            examChooseViewController.examType = ExamType(rawValue: sender.tag)!;
            self.navigationController?.pushViewController(examChooseViewController, animated: true);
            
        } else {
            let listTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "EList") as! EListTableViewController;
            //            listTableViewController.examType = ExamType(rawValue: sender.tag)!;
            self.navigationController?.pushViewController(listTableViewController, animated: true);
        }
        
        
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
