//
//  WCReportViewController.swift
//  VocabuLazy
//
//  Created by Goston on 12/11/2016.
//  Copyright © 2016 WishCan. All rights reserved.
//

import UIKit

class WCReportViewController: UIViewController, UITextViewDelegate {

    // ---------------------------------------------------------------------------------------------
    // MARK : - Variables
    
    // IBOutlet
    @IBOutlet weak var reportTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Buttons action
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
