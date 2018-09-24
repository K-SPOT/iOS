//
//  SearchResultMoreCelebrityVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultMoreCelebrityVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    var searchData : [ChannelVODataChannelList]?
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

extension SearchResultMoreCelebrityVC : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchData_ = searchData {
            return searchData_.count
        }
        return 0
    }
    
    
    //headerSection View 만드는 것
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "SearchResultHeaderCell2") as! CategoryDetailSecondTVHeaderCell
        header.titleLbl.text = headerTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BroadcastTVCell2") as! BroadcastTVCell
        if let searchData_ = searchData {
            cell.configure(data: searchData_[indexPath.row], index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchData_ = searchData{
           self.goToCelebrityDetail(selectedIdx: searchData_[indexPath.row].channelID)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

