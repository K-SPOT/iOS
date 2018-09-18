//
//  CelebrityVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CelebrityVC: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    var delegate : SelectDelegate?
    var celebrityList : [ChannelVODataChannelList]? {
        didSet {
            tableView.reloadData()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
    }
}

extension CelebrityVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let celebrityList_ = celebrityList {
            return celebrityList_.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CelebrityTVCell.reuseIdentifier) as! CelebrityTVCell
        if let celebrityList_ = celebrityList {
            cell.delegate = parent as? SelectSenderDelegate
           cell.configure(data: celebrityList_[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tap(selected: 0)
    }
}

