//
//  WCIntroduceViewController.swift
//  Swallow
//
//  Created by WishCan on 2016/10/27.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

class WCIntroduceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // ---------------------------------------------------------------------------------------------
    // MARK : - Variables
    var introduceCollectionView: UICollectionView?
    
    // ---------------------------------------------------------------------------------------------
    // MARK : - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height
        
        introduceCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - navigationBarHeight! - statusBarHeight), collectionViewLayout: UICollectionViewLayout())
        introduceCollectionView?.collectionViewLayout = WCIntroduceCollectionViewFlowLayout()
        introduceCollectionView?.register(WCIntroduceCollectionViewCell.self, forCellWithReuseIdentifier: "IntroduceCell")
        introduceCollectionView?.dataSource = self

        introduceCollectionView?.backgroundColor = UIColor.white
        self.view.addSubview(introduceCollectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK : - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroduceCell", for: indexPath) as! WCIntroduceCollectionViewCell
        switch indexPath.row {
        case 0:
            
            cell.pictureImageView?.image = UIImage(named: "ProfileSojier")
            cell.pictureLabel?.text = "Head - Sojier"
        case 1:
            cell.pictureImageView?.image = UIImage(named: "ProfileCarlos")
            cell.pictureLabel?.text = "Co-founder - Carlos"
        case 2:
            cell.pictureImageView?.image = UIImage(named: "ProfileAllen")
            cell.pictureLabel?.text = "Android Developer - Allen"
        case 3:
            cell.pictureImageView?.image = UIImage(named: "ProfileSwallow")
            cell.pictureLabel?.text = "Android Developer - Swallow"
        case 4:
            cell.pictureImageView?.image = UIImage(named: "ProfileGoston")
            cell.pictureLabel?.text = "iOS Developer - Goston"
        case 5:
            cell.pictureImageView?.image = UIImage(named: "ProfileJianhow")
            cell.pictureLabel?.text = "iOS Developer - Jian How"
        case 6:
            cell.pictureImageView?.image = UIImage(named: "ProfileTom")
            cell.pictureLabel?.text = "Designet - Tom"
        case 7:
            cell.pictureImageView?.image = UIImage(named: "ProfileDaisy")
            cell.pictureLabel?.text = "Designer - Daisy"
        default:
            cell.pictureImageView?.image = UIImage(named: "ProfileAllen")
            cell.pictureLabel?.text = "Android Developer - Allen"
        }
        
        return cell
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
