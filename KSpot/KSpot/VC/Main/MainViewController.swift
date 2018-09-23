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

/*struct SampleStruct {
    var image : InputSource
    var id : String
}*/
var selectedLang : Language = .kor
var isLogin : Bool = false

class MainViewController: UIViewController {
    @IBAction func searchAction(_ sender: Any) {
        self.goToSearchVC()
    }
    
    @IBOutlet weak var tableView: UITableView!
    var mainData : MainVOData? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var currentSelectedLang = selectedLang
    
    fileprivate func reloadRootViewController() {
        //isUserLogin()
        //if FBSDKAccessToken.current() == nil
        if FBSDKAccessToken.current() == nil {
            goToLoginPage(entryPoint: 1)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getLangInfo(_:)), name: NSNotification.Name("GetLanguageValue"), object: nil)
        reloadRootViewController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        getMainData(url: UrlPath.main.getURL())
        setTranslationBtn()
    }
    
    @objc func getLangInfo(_ notification : Notification) {
        getMainData(url: UrlPath.main.getURL())
    }
}

extension MainViewController : SelectSectionDelegate {
    func tap(section: Section, seledtedId: Int) {
        if (section == .first){
            let mainStoryboard = Storyboard.shared().mainStoryboard
          

            if let themeVC = mainStoryboard.instantiateViewController(withIdentifier:ThemeVC.reuseIdentifier) as? ThemeVC {
                themeVC.selectedId = (mainData?.theme[seledtedId].themeID)
                self.navigationController?.pushViewController(themeVC, animated: true)
            }
        } else {
            self.goToPlaceDetailVC(selectedIdx: seledtedId)
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
          
            
            if let mainData_ = mainData{
                let imageArr : [InputSource] = mainData_.theme.flatMap({ (data) in
                    KingfisherSource(urlString: data.mainImg)
                })
                cell.imageSource = imageArr
            }
            cell.awakeFromNib()
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondTVCell.reuseIdentifier) as! MainSecondTVCell
            cell.recommendPlaceData = mainData?.mainRecommandSpot
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdTVCell.reuseIdentifier) as! MainThirdTVCell
            cell.popularPlaceData = mainData?.mainBestPlace
            cell.delegate = self
            return cell
        }
      
    }
    
}

//통신
extension MainViewController {
    func getMainData(url : String){
        MainService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let mainData):
                self.mainData = mainData as? MainVOData
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}

