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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
      
    }


}

extension BroadcastVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BroadcastTVCell.reuseIdentifier) as! BroadcastTVCell
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tap(selected: 1)
    }
}
