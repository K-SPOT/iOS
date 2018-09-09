//
//  SubBroadCastVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 10..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SubBroadCastVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}


extension SubBroadCastVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubBroadcastTVCell.reuseIdentifier) as! SubBroadcastTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryStoryboard = Storyboard.shared().categoryStoryboard
        if let categoryDetailVC = categoryStoryboard.instantiateViewController(withIdentifier:CategoryDetailVC.reuseIdentifier) as? CategoryDetailVC {
            self.navigationController?.pushViewController(categoryDetailVC, animated: true)
        }
    }
}
