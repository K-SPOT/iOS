//
//  MainViewController.swift
//  KSpot
//
//  Created by 강수진 on 2018. 8. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController {
    @IBAction func searchAction(_ sender: Any) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let mainSearchVC = mainStoryboard.instantiateViewController(withIdentifier:MainSearchVC.reuseIdentifier) as? MainSearchVC {
            self.navigationController?.pushViewController(mainSearchVC, animated: true)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

   
    fileprivate func reloadRootViewController() {
        let isOpened = FBSDKAccessToken.currentAccessTokenIsActive()
        if !isOpened {
            let mainStoryboard = Storyboard.shared().mainStoryboard
            if let loginVC = mainStoryboard.instantiateViewController(withIdentifier:LoginVC.reuseIdentifier) as? LoginVC {
                 self.present(loginVC, animated: false, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadRootViewController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)

        
    }
}

extension MainViewController : SelectSectionelegate {
    func tap(section: Section, seledtedId: Int) {
        if (section == .first){
            let mainStoryboard = Storyboard.shared().mainStoryboard
            if let themeVC = mainStoryboard.instantiateViewController(withIdentifier:ThemeVC.reuseIdentifier) as? ThemeVC {
                
                self.navigationController?.pushViewController(themeVC, animated: true)
            }
        } else {
            print("taped")
            self.goToPlaceDetailVC()
        }
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstTVCell.reuseIdentifier) as! MainFirstTVCell
            cell.delegate = self
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

