//
//  WCExamResultView.swift
//  Swallow
//
//  Created by Goston on 2016/4/10.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

// MARK: - Define
private let TopSpace: CGFloat = 40.0;
private let SideSpace: CGFloat = 30.0;
private let LineSideSpace: CGFloat = SideSpace / 2;
private let ButtonSpace: CGFloat = 30.0;

private let Result_Height_Ratio: CGFloat = 4 / 9;
private let Button_Height: CGFloat = 40.0;
private let Button_Width_Ratio: CGFloat = 3 / 5;

// Define Color
private let WC_Green_Color = UIColor (red: 72.0 / 255.0, green: 207.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0);
private let WC_Yellow_Color = UIColor (red: 254.0 / 255.0, green: 206.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0);
private let WC_DarkGray_Color = UIColor (red: 102.0 / 255.0, green: 108.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0);

// MARK: - Protocol
protocol WCExamResultViewDelegate
{
    /**
     按下重複測驗的按鈕
     */
    func didTapAgainButton();
    
    /**
     按下選擇其他單元的按鈕
     */
    func didTapOtherButton();
}

class WCExamResultView: UIView
{
    // Private variable
    fileprivate var resultView: UIView?;
    
    // Public variable
    var delegate: WCExamResultViewDelegate?;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        initialResultView();
        initialSeperateLine();
        initialAgainButton();
        initialOtherButton();
    }
    
    fileprivate func initialResultView()
    {
        // Result background view
        resultView = UIView(frame: CGRect(x: SideSpace, y: TopSpace, width: self.bounds.width - SideSpace * 2, height: self.bounds.height * Result_Height_Ratio));
        resultView!.layer.cornerRadius = 15.0;
        resultView!.backgroundColor = WC_Yellow_Color;
        
        // Image view
        let uiImage = UIImageView(image: UIImage(named: "TestImage"));
        
        // Result Label
        let answerRightLabel = UILabel(frame: CGRect(x: 0, y: resultView!.bounds.height * 2 / 3, width: resultView!.bounds.width, height: 21));
        answerRightLabel.textAlignment = NSTextAlignment.center;
        answerRightLabel.text = "答對5題";
        
        let answerRateLabel = UILabel(frame: CGRect(x: 0, y: answerRightLabel.frame.origin.y + 21 * 3 / 2, width: answerRightLabel.bounds.width, height: answerRightLabel.bounds.height));
        answerRateLabel.textAlignment = NSTextAlignment.center;
        answerRateLabel.text = "答對率50%";
        
        resultView!.addSubview(uiImage);
        resultView!.addSubview(answerRightLabel);
        resultView!.addSubview(answerRateLabel);
        
        self.addSubview(resultView!);
    }
    
    fileprivate func initialSeperateLine()
    {
        let resultViewLastPosition = (resultView?.frame.origin.y)! + (resultView?.bounds.height)!;
        
        let seperateLine = CALayer();
        seperateLine.frame = CGRect(x: LineSideSpace, y: resultViewLastPosition + ButtonSpace, width: self.bounds.width - LineSideSpace * 2, height: 2);
        seperateLine.backgroundColor = WC_Green_Color.cgColor;
        self.layer.addSublayer(seperateLine);
    }
    
    fileprivate func initialAgainButton()
    {
        let resultViewLastPosition = (resultView?.frame.origin.y)! + (resultView?.bounds.height)! + ButtonSpace * 2;
        let buttonPotisionX = (self.bounds.width - (resultView?.bounds.width)! * Button_Width_Ratio) / 2;
        
        let againButton = WCMaterialButton(frame: CGRect(x: buttonPotisionX, y: resultViewLastPosition, width: (resultView?.bounds.width)! * Button_Width_Ratio, height: Button_Height), cornerRadious: Button_Height / 2);
        againButton.backgroundColor = WC_DarkGray_Color;
        againButton.setTitle("再測一次", for: UIControlState());
        againButton.tag = 0;
        
        againButton.addTarget(self, action: #selector(WCExamResultView.examResultButtonAction(_:)), for: UIControlEvents.touchUpInside);
        
        self.addSubview(againButton);
    }
    
    fileprivate func initialOtherButton()
    {
        let againButtonLastPosition = (resultView?.frame.origin.y)! + (resultView?.bounds.height)! + ButtonSpace * 3 + Button_Height;
        let buttonPotisionX = (self.bounds.width - (resultView?.bounds.width)! * Button_Width_Ratio) / 2;
        
        let otherButton = WCMaterialButton(frame: CGRect(x: buttonPotisionX, y: againButtonLastPosition, width: (resultView?.bounds.width)! * Button_Width_Ratio, height: Button_Height), cornerRadious: Button_Height / 2);
        otherButton.backgroundColor = WC_DarkGray_Color;
        otherButton.setTitle("試試其他單元", for: UIControlState());
        otherButton.tag = 1;
        
        otherButton.addTarget(self, action: #selector(WCExamResultView.examResultButtonAction(_:)), for: UIControlEvents.touchUpInside);
        
        self.addSubview(otherButton);
    }
    
    // MARK: - Button Action
    @IBAction func examResultButtonAction(_ sender: WCMaterialButton)
    {
        switch sender.tag
        {
        case 0:
            delegate?.didTapAgainButton();
        case 1:
            delegate?.didTapOtherButton();
        default:
            return ;
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
