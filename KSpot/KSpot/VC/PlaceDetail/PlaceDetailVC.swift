//
//  PlaceDetailVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 4..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import MessageUI

private let NAVBAR_COLORCHANGE_POINT:CGFloat = -80
private let IMAGE_HEIGHT:CGFloat = 232
private let SCROLL_DOWN_LIMIT:CGFloat = 100
private let LIMIT_OFFSET_Y:CGFloat = -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

class PlaceDetailVC: UIViewController, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var emailView: UIView!

    @IBOutlet weak var subwayLbl: UILabel!
    var whiteScrapBarBtn : UIBarButtonItem?
    var blackScrapBarBtn : UIBarButtonItem?
    lazy var cycleScrollView:WRCycleScrollView = {
    
        let frame = CGRect(x: 0, y: -IMAGE_HEIGHT, width: CGFloat(kScreenWidth), height: IMAGE_HEIGHT)
        let cycleView = WRCycleScrollView(frame: frame, type: .LOCAL, imgs: nil, descs: nil)
        return cycleView
    }()
    
    @IBAction func phoneViewAction(_ sender: Any) {
        "01025010258".makeACall()
    }
    
    
    @IBAction func emailViewAction(_ sender: Any) {
        sendEmail()
    }
    
    @IBAction func scrollToTopAction(_ sender: Any) {
        tableView.setContentOffset(CGPoint(x: 0, y : -IMAGE_HEIGHT), animated: true)
    }
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["rkdthd1234@naver.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       
        controller.dismiss(animated: true)
    }

   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setTableView()
        setcycleScrollView()
        setNavbar()
    
        subwayLbl.adjustsFontSizeToFitWidth = true
        locationView.makeRounded(cornerRadius: 17)
        phoneView.makeRounded(cornerRadius: nil)
        phoneView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1))
        emailView.makeRounded(cornerRadius: nil)
        emailView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1))
    }
    
    
    @objc public func sample(_sender : UIBarButtonItem) {
        
    }
    
    deinit {
        tableView.delegate = nil
        print("ZhiHuVC deinit")
    }
}

//네비게이션 바, 테이블뷰, 스크롤뷰 설정
extension PlaceDetailVC {
    func setNavbar(){
        //오른쪽 바버튼 아이템 설정
        whiteScrapBarBtn = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "place_detail_unscrap"), target: self, action: #selector(PlaceDetailVC.sample(_sender:)))
        blackScrapBarBtn = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "place_detail_unscrap_black"), target: self, action: #selector(PlaceDetailVC.sample(_sender:)))
        
        let titleBarBtn = UIBarButtonItem.titleBarbutton(title: "23,341", red: 255, green: 255, blue: 255, fontSize: 14, fontName: NanumSquareOTF.NanumSquareOTFR.rawValue, selector: nil)
        titleBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItems = [whiteScrapBarBtn!, titleBarBtn]
        
        //왼쪽 백버튼 아이템 설정
        setBackBtn(color: .white)
        
        self.navigationItem.title = ""
        
        //네비게이션바 컬러
        navBarBarTintColor = .white
        navBarBackgroundAlpha = 0
        //네비게이션 바 안의 아이템 컬러
        navBarTintColor = .white
        
    }
    
    func setTableView(){
        tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-CGFloat(kNavBarBottom), 0, 0, 0);
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        //view.backgroundColor = UIColor.white
        tableView.addSubview(cycleScrollView)
       
    }
    
    func setcycleScrollView(){
        let serverImages = ["https://pbs.twimg.com/profile_images/799445590614495232/ii6eBROd_400x400.jpg", "https://t1.daumcdn.net/cfile/tistory/990BDE4C5A7DB27A2B"]
        var descs : [String]? = []
        for i in 1...serverImages.count {
            descs?.append("\(i)/\(serverImages.count)")
        }
        cycleScrollView.serverImgArray = serverImages
        cycleScrollView.descTextArray = descs
        cycleScrollView.showPageControl = false
    }
}

// MARK: - ScrollViewDidScroll
extension PlaceDetailVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        
        if (offsetY > NAVBAR_COLORCHANGE_POINT)
        {
             navBarTintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            navigationItem.rightBarButtonItems?[1].tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            navigationItem.rightBarButtonItems?[0] = blackScrapBarBtn!
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
        }
        else
        {
            navBarTintColor = .white
            navigationItem.leftBarButtonItem?.tintColor = .white
            navigationItem.rightBarButtonItems?[1].tintColor = .white
            navigationItem.rightBarButtonItems?[0] = whiteScrapBarBtn!
            navBarBackgroundAlpha = 0
        }
        
        // 限制下拉距离
        if (offsetY < LIMIT_OFFSET_Y) {
            scrollView.contentOffset = CGPoint.init(x: 0, y: LIMIT_OFFSET_Y)
        }
        
        // 改变图片框的大小 (上滑的时候不改变)
        // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
        let newOffsetY = scrollView.contentOffset.y
        if (newOffsetY < -IMAGE_HEIGHT)
        {
            cycleScrollView.frame = CGRect(x: 0, y: newOffsetY, width: CGFloat(kScreenWidth), height: -newOffsetY)
        }
    }
    
    // private
    fileprivate func imageScaledToSize(image:UIImage, newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: newSize.width * 2.0, height: newSize.height * 2.0))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width * 2.0, height: newSize.height * 2.0))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension PlaceDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceDetailFirstTVCell.reuseIdentifier) as! PlaceDetailFirstTVCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceDetailSecondTVCell.reuseIdentifier) as! PlaceDetailSecondTVCell
            cell.delegate = self
            return cell
        }
    }
    
}

extension PlaceDetailVC : SelectSectionelegate {
    func tap(section: Section, seledtedId: Int) {
        //리뷰 쓰는 버튼
        if (seledtedId == -1){
            let mapStoryboard = Storyboard.shared().mapStoryboard
            if let reviewWriteVC = mapStoryboard.instantiateViewController(withIdentifier:ReviewWriteVC.reuseIdentifier) as? ReviewWriteVC {
                
                self.navigationController?.pushViewController(reviewWriteVC, animated: true)
            }
        }
    }
    
    
}



