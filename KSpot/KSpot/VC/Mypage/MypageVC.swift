//
//  MypageVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 9..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher

class MypageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var numberofRows = 0
    @IBAction func logoutAction(_ sender: Any) {
        self.simpleAlertwithHandler(title: "로그아웃 하시겠습니까?", message: "") { (_) in
            //faceBookLogout
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            let parentVC = self.parent as? MyPageContainerVC
            parentVC?.viewWillAppear(false)
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    
    
    var channelArr : [MypageVODataChannel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMyInfo(url: UrlPath.mypage.getURL())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        profileImgView.makeRounded(cornerRadius: profileImgView.frame.height/2)
        
    }
    
}

//tableView delegate, datasource
extension MypageVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if channelArr?.count != 0 {
            numberofRows = 3
        } else {
            numberofRows = 2
        }
        return numberofRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberofRows == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MypageTVCell.reuseIdentifier) as! MypageTVCell
            if indexPath.row == 0 {
                cell.myLbl.text = "스크랩"
            } else {
                cell.myLbl.text = "회원정보 수정"
            }
            return cell
        } else {
           
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MypageFisrtTVCell.reuseIdentifier) as! MypageFisrtTVCell
                cell.channelArr = self.channelArr
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MypageTVCell.reuseIdentifier) as! MypageTVCell
                if indexPath.row == 1 {
                    cell.myLbl.text = "스크랩"
                } else {
                    cell.myLbl.text = "회원정보 수정"
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if (indexPath.row == 0 && numberofRows == 2) || (indexPath.row == 1 && numberofRows == 3){
            
            if let scrapVC = mypageStoryboard.instantiateViewController(withIdentifier:ScrapVC.reuseIdentifier) as? ScrapVC {
                
                self.navigationController?.pushViewController(scrapVC, animated: true)
            }
        } else if (indexPath.row == 1 && numberofRows == 2) || (indexPath.row == 2 && numberofRows == 3) {
            if let editProfileVC = mypageStoryboard.instantiateViewController(withIdentifier:EditProfileVC.reuseIdentifier) as? EditProfileVC {
                editProfileVC.profileImg = self.profileImgView.image
                if let nameTxt = nameLbl.text {
                    editProfileVC.nameTxt = (self.nameLbl.text?.prefix((nameTxt.count)-5).description) ?? ""
                }
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension MypageVC : SelectSectionDelegate{
    func tap(section: Section, seledtedId: Int) {
        //more action
        if (seledtedId == 0){
            let mypageStoryboard = Storyboard.shared().mypageStoryboard
            if let subscribeVC = mypageStoryboard.instantiateViewController(withIdentifier:SubscribeVC.reuseIdentifier) as? SubscribeVC {
               
                self.navigationController?.pushViewController(subscribeVC, animated: true)
            }
        } else {
             self.goToCelebrityDetail(selectedIdx : 0)
        }
    }
}



//통신
extension MypageVC {
    func getMyInfo(url : String){
        MypageService.shareInstance.getMypageInfo(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let mypageData):
                let userData = mypageData as! MypageVOData
                self.nameLbl.text = "\(userData.user.name) 고객님,"
                self.setImgWithKF(url: self.gsno(userData.user.profileImg), imgView: self.profileImgView, defaultImg: #imageLiteral(resourceName: "mypage_membership_edit_default_img"))
                self.channelArr = userData.channel
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    } //getmyinfo
}



