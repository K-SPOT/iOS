//
//  SearchResultMorePlaceVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultMorePlaceVC: UIViewController, UIGestureRecognizerDelegate {
    
    let sunglassArr = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
  
    var headerTitle = ""
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        setBackBtn()
    }
    
    
}

extension SearchResultMorePlaceVC : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sunglassArr.count
    }
    
    
    //headerSection View 만드는 것
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "SearchResultHeaderCell") as! CategoryDetailSecondTVHeaderCell
        header.titleLbl.text = headerTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVCell.reuseIdentifier) as! CategoryDetailSecondTVCell
        cell.myImgView.image = sunglassArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.goToPlaceDetailVC(selectedIdx: 0)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
