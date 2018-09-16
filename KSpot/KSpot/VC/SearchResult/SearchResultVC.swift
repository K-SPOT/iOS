//
//  SearchResultVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController, UIGestureRecognizerDelegate {

    let sunglassArr1 = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    let sunglassArr2 : [UIImage] = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    let sunglassArr3 : [UIImage] = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        setBackBtn()
    }


}

extension SearchResultVC : UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sunglassArr1.count
        } else if section == 1{
            return sunglassArr2.count
        } else {
            return sunglassArr3.count
        }
    }
    
    
    //headerSection View 만드는 것
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVHeaderCell.reuseIdentifier) as! CategoryDetailSecondTVHeaderCell

        if section == 0  {
            if( sunglassArr1.count != 0) {
                header.titleLbl.text = "연예인 / 방송"
                return header
            } else {
                return nil
            }
        } else if section == 1 {
            if( sunglassArr2.count != 0) {
                header.titleLbl.text = "장소"
                header.morBtn.addTarget(self, action: #selector(goToPlaceMore(_:)), for: .touchUpInside)
                return header
            } else {
                return nil
            }
        } else {
            if( sunglassArr3.count != 0) {
                header.titleLbl.text = "이벤트"
                header.morBtn.addTarget(self, action: #selector(goToEventMore(_:)), for: .touchUpInside)
                return header
            } else {
                return nil
            }
        }
    }
    
    @objc func goToPlaceMore(_ sender : UIButton){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultMoreVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultMoreVC.reuseIdentifier) as? SearchResultMoreVC {
           
            self.navigationController?.pushViewController(searchResultMoreVC, animated: true)
        }
    }
    @objc func goToEventMore(_ sender : UIButton){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultMorePlaceVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultMorePlaceVC.reuseIdentifier) as? SearchResultMorePlaceVC {
        
            searchResultMorePlaceVC.headerTitle = "이벤트"
            self.navigationController?.pushViewController(searchResultMorePlaceVC, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0  {
            if( sunglassArr1.count != 0) {
                return 62
            } else {
                return 0
            }
        } else if section == 1 {
            if( sunglassArr2.count != 0) {
                return 62
            } else {
                return 0
            }
        } else {
            if( sunglassArr3.count != 0) {
                return 62
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BroadcastTVCell.reuseIdentifier) as! BroadcastTVCell
            return cell
            
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVCell.reuseIdentifier) as! CategoryDetailSecondTVCell
            if indexPath.section == 1 {
                //cell.configure
                 cell.myImgView.image = #imageLiteral(resourceName: "search_result_place_icon")
            } else {
                //cell.configure
                cell.myImgView.image = #imageLiteral(resourceName: "search_result_event_birthday")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        if section == 0 {
            goToCelebrityDetail()
        } else if section == 1 {
            goToPlaceDetailVC()
        } else {
            goToPlaceDetailVC()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
