//
//  SearchResultMorePlaceVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultMorePlaceVC: UIViewController, UIGestureRecognizerDelegate {
    
  
    var searchData : [SearchResultVODataPlace]?
    var headerTitle = ""
    @IBOutlet weak var tableView : UITableView!
    var isChange : Bool? {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        setBackBtn()
        tableView.reloadData()
    }
    
    
}

extension SearchResultMorePlaceVC : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchData_ = searchData {
            return searchData_.count
        }
        return 0
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
        if let searchData_ = searchData {
            cell.configure2(data: searchData_[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchData_ = searchData{
            var isPlace = true
            if self.headerTitle == "이벤트" {
               isPlace = false
            }
            self.goToPlaceDetailVC(selectedIdx: searchData_[indexPath.row].spotID, isPlace : isPlace)
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
