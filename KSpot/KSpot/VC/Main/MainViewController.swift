//
//  MainViewController.swift
//  KSpot
//
//  Created by 강수진 on 2018. 8. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBAction func searchAction(_ sender: Any) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let mainSearchVC = mainStoryboard.instantiateViewController(withIdentifier:MainSearchVC.reuseIdentifier) as? MainSearchVC {
            self.navigationController?.pushViewController(mainSearchVC, animated: true)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame : .zero)
        
    }
    
   

}

extension MainViewController : SelectDelegate {
    func tap(selected: Int?) {
        print("taped")
        self.goToPlaceDetailVC()
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstTVCell.reuseIdentifier) as! MainFirstTVCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondTVCell.reuseIdentifier) as! MainSecondTVCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdTVCell.reuseIdentifier) as! MainThirdTVCell
            cell.delegate = self
            return cell
        }
      
    }

    
    
}

