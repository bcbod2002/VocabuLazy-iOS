//
//  WCInformationViewController.swift
//  Swallow
//
//  Created by Goston on 2015/8/21.
//  Copyright (c) 2015年 WishCan. All rights reserved.
//

import UIKit

class WCInformationViewController: UIViewController, UIWebViewDelegate {

    // ---------------------------------------------------------------------------------------------
    // MARK: - Variables
    var screenSize : CGSize = UIScreen.main.bounds.size;

    // IBOutlet
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
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
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - IBOutlet Button action
    @IBAction func rateAppButtonAction(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id1138382163")!)
    }
    
    @IBAction func replyQuestionButtonAction(_ sender: AnyObject) {
        let replyViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "ReportPage")
        self.navigationController?.pushViewController(replyViewContoller!, animated: true)
    }
    
    @IBAction func introduceButtonAction(_ sender: AnyObject) {
        let introduceController = self.storyboard?.instantiateViewController(withIdentifier: "IntroducePage")
        self.navigationController?.pushViewController(introduceController!, animated: true)
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
