//
//  BroadcastVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class BroadcastVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var delegate : SelectDelegate?
    var broadcastList : [ChannelVODataChannelList]? {
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

extension BroadcastVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let broadcastList_ = broadcastList {
            return broadcastList_.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BroadcastTVCell.reuseIdentifier) as! BroadcastTVCell
        if let broadcastList_ = broadcastList {
            cell.configure(data: broadcastList_[indexPath.row])
             cell.delegate = parent as? SelectSenderDelegate
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tap(selected: 1)
    }
}
