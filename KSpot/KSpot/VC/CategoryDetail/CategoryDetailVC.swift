//
//  CategoryDetailVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CategoryDetailVC: UIViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var mainTitleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton!
    
    @IBOutlet weak var subscribeLbl: UILabel!
    @IBAction func scrollToTopAction(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    let sunglassArr = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        mainImg.makeImageRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hide navigationBar without losing slide-back ability
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let backBTN = UIBarButtonItem(image: UIImage(named: "category_detail_left_arrow"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.navigationController?.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = .white
       
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
}

extension CategoryDetailVC : UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return sunglassArr.count
        } else {
            return sunglassArr.count
        }
    }
    
    
    //header View 만드는 것
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVHeaderCell.reuseIdentifier) as! CategoryDetailSecondTVHeaderCell
        
        if section == 1 {
            header.titleLbl.text = "관련된 장소"
            return header
        } else if section == 2{
            header.titleLbl.text = "관련된 이벤트"
            return header
        } else {
            return nil
        }
    }
    
   
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 || section == 2  ? 79 : 0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailFirstTVCell.reuseIdentifier) as! CategoryDetailFirstTVCell
            return cell
            
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVCell.reuseIdentifier) as! CategoryDetailSecondTVCell
            if indexPath.section == 1 {
                //cell.configure
            } else {
                //cell.configure
            }
            return cell
        }
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let selectedUser:Profile
     if indexPath.section == 0 {
     selectedUser = myProfile
     } else {
     selectedUser = friend[indexPath.row]
     }
     
     let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ProfileViewController.reuseIdentifier) as! ProfileViewController
     secondVC.selectedUser = selectedUser
     self.present(secondVC, animated: true, completion: nil)
     }*/
}
