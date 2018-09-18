//
//  MypageVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 9..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MypageVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutAction(_ sender: Any) {
        self.simpleAlertwithHandler(title: "로그아웃 하시겠습니까?", message: "") { (_) in
            //faceBookLogout
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            self.simpleAlert(title: "완료", message: "로그아웃이 완료되었습니다")
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if let subscribeVC = mypageStoryboard.instantiateViewController(withIdentifier:SubscribeVC.reuseIdentifier) as? SubscribeVC {
            self.navigationController?.pushViewController(subscribeVC, animated: true)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
  
    let sunglassArr = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg")]

    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        profileImgView.makeRounded(cornerRadius: profileImgView.frame.height/2)
    
    }

}

//tableView delegate, datasource
extension MypageVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: MypageTVCell.reuseIdentifier) as! MypageTVCell
        if indexPath.row == 0 {
           cell.myLbl.text = "스크랩"
        } else {
           cell.myLbl.text = "회원정보 수정"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if indexPath.row == 0 {
           
            if let scrapVC = mypageStoryboard.instantiateViewController(withIdentifier:ScrapVC.reuseIdentifier) as? ScrapVC {
                
                self.navigationController?.pushViewController(scrapVC, animated: true)
            }
        } else {
            if let editProfileVC = mypageStoryboard.instantiateViewController(withIdentifier:EditProfileVC.reuseIdentifier) as? EditProfileVC {
                
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
        }
    }
}



extension MypageVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sunglassArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MypageCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageCVCell.reuseIdentifier, for: indexPath) as? MypageCVCell
        {
            cell.myImgView.image = sunglassArr[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToCelebrityDetail()
    }
}


extension MypageVC: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (248/375)*self.view.frame.width, height: (168/667)*self.view.frame.height)
    }
    
}

extension MypageVC : UIScrollViewDelegate{
    
    private func indexOfMajorCell() -> Int {
        
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / (itemWidth)
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
        
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
}


