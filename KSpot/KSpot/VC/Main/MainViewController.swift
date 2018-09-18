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
import ImageSlideshow

struct SampleStruct {
    var image : InputSource
    var id : String
}

class MainViewController: UIViewController {
    @IBAction func searchAction(_ sender: Any) {
        self.goToSearchVC()
    }
    
    @IBOutlet weak var tableView: UITableView!


    var sampleData : [SampleStruct] = [SampleStruct(image: KingfisherSource(urlString: "https://t1.daumcdn.net/cfile/tistory/240636455780D09234")!, id: "80"), SampleStruct(image: KingfisherSource(urlString: "https://i.pinimg.com/originals/f7/eb/e1/f7ebe1de2088de46229b163747e1a40a.gif")!, id: "10"), SampleStruct(image: KingfisherSource(urlString: "https://i.pinimg.com/originals/05/b5/c1/05b5c164be2121b2271b5c5ec7a59770.gif")!, id: "820")]
    
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
            print("id는 \(sampleData[seledtedId].id)")
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
            cell.localSource = sampleData.map({ (data) in
                data.image
            })
    
            cell.awakeFromNib()
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

