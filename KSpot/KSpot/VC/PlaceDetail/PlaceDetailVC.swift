//  PlaceDetailVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 4..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import MessageUI
//import FBSDKLoginKit

private let NAVBAR_COLORCHANGE_POINT:CGFloat = -80
private let IMAGE_HEIGHT:CGFloat = 232
private let SCROLL_DOWN_LIMIT:CGFloat = 100
private let LIMIT_OFFSET_Y:CGFloat = -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

class PlaceDetailVC: UIViewController, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var staionImgView: UIImageView!
    @IBOutlet weak var lineNumImgView: UIImageView!
    @IBOutlet weak var currentStationLbl: UILabel!
    @IBOutlet weak var prevStationLbl: UILabel!
    @IBOutlet weak var nextsStationLbl: UILabel!
    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactImgView: UIImageView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var openCloseLbl: UILabel!
    @IBOutlet weak var openLbl: UILabel!
    @IBOutlet weak var closeLbl: UILabel!
    @IBOutlet weak var openTimeLbl: UILabel!
    @IBOutlet weak var closeTimeLbl: UILabel!
    var whiteScrapBarBtn : UIBarButtonItem?
    var whiteFullScrapBarBtn : UIBarButtonItem?
    var blackScrapBarBtn : UIBarButtonItem?
    var greenScrapBarBtn : UIBarButtonItem?
    var selectedIdx = 0
    var scrapCount = 0
    var isPlace = true
    var isChange : Bool? {
        didSet {
            tableView.reloadData()
            if let placeData_ = placeData {
                setcycleScrollView(placeData : placeData_)
                setBarButtons(placeData: placeData_)
                setHeaderView(placeData: placeData_)
                setFooterView(placeData: placeData_)
            }
        }
    }
    var placeData : PlaceDetailVOData?
    
    lazy var cycleScrollView:WRCycleScrollView = {
        
        let frame = CGRect(x: 0, y: -IMAGE_HEIGHT, width: CGFloat(kScreenWidth), height: IMAGE_HEIGHT)
        let cycleView = WRCycleScrollView(frame: frame, type: .LOCAL, imgs: nil, descs: nil)
        return cycleView
    }()
    
    @IBAction func goToMapAction(_ sender: Any) {
        let mapStoryboard = Storyboard.shared().mapStoryboard
        if let googleMapVC = mapStoryboard.instantiateViewController(withIdentifier:GoogleMapVC.reuseIdentifier) as? GoogleMapVC {
            googleMapVC.chosenPlace = MyPlace(name: "대전히히", lat: 36.3504, long: 127.3845)
            googleMapVC.entryPoint = .searchSpecificLocation
            self.navigationController?.pushViewController(googleMapVC, animated: true)
        }
    }
    
    @IBAction func writeReviewAction(_ sender: Any) {
        if !isUserLogin() {
            goToLoginPage()
        } else {
            //리뷰 쓰기
            let mapStoryboard = Storyboard.shared().mapStoryboard
            if let reviewWriteVC = mapStoryboard.instantiateViewController(withIdentifier:ReviewWriteVC.reuseIdentifier) as? ReviewWriteVC {
                reviewWriteVC.selectedIdx = self.selectedIdx
                self.navigationController?.pushViewController(reviewWriteVC, animated: true)
            }
        }
    }
    
    @IBAction func phoneViewAction(_ sender: Any) {
        guard let contact = placeData?.contact else {return}
        if isPlace {
            contact.makeACall()
        } else {
            sendEmail(to : contact)
        }
    }
    
    
    @IBAction func scrollToTopAction(_ sender: Any) {
        tableView.setContentOffset(CGPoint(x: 0, y : -IMAGE_HEIGHT), animated: true)
    }
    
    
    func sendEmail(to : String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([to])
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
        //setcycleScrollView()
        setNavbar()
        if isPlace {
            openCloseLbl.text = "오픈/마감 시간"
            openLbl.text = "오픈"
            closeLbl.text = "마감"
            contactImgView.image = #imageLiteral(resourceName: "place_detail_phone")
        } else {
            openCloseLbl.text = "이벤트 시작일/종료일"
            openLbl.text = "시작일"
            closeLbl.text = "종료일"
            contactImgView.image = #imageLiteral(resourceName: "place_detail_user")
        }
        
        currentStationLbl.adjustsFontSizeToFitWidth = true
        titleLbl.adjustsFontSizeToFitWidth = true
        descLbl.adjustsFontSizeToFitWidth = true
        addressLbl.adjustsFontSizeToFitWidth = true
        locationView.makeRounded(cornerRadius: 17)
        contactView.makeRounded(cornerRadius: nil)
        contactView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlaceInfo(url: UrlPath.spot.getURL("\(selectedIdx)/detail"))
    }
    
    
    @objc public func scrapAction(_sender : UIBarButtonItem) {
        if !isUserLogin() {
            goToLoginPage()
        } else {
            //스크랩
            if navigationItem.rightBarButtonItems?[0] == whiteScrapBarBtn! || navigationItem.rightBarButtonItems?[0] == blackScrapBarBtn! {
                let param : [String : Any] = ["spot_id":selectedIdx]
                scrap(url: UrlPath.spotSubscription.getURL(), params: param, sender: _sender)
            } else {
                unscrap(url: UrlPath.spotSubscription.getURL(selectedIdx.description), sender: _sender)
            }
        }
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
        whiteScrapBarBtn?.tag = 0
        blackScrapBarBtn?.tag = 1
        whiteFullScrapBarBtn?.tag = 2
        greenScrapBarBtn?.tag = 3
        whiteScrapBarBtn = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "place_detail_unscrap"), target: self, action: #selector(PlaceDetailVC.scrapAction(_sender:)))
        blackScrapBarBtn = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "place_detail_unscrap_black"), target: self, action: #selector(PlaceDetailVC.scrapAction(_sender:)))
        whiteFullScrapBarBtn = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "place_detail_scrap"), target: self, action: #selector(PlaceDetailVC.scrapAction(_sender:)))
        greenScrapBarBtn = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "place_detail_scrap_green"), target: self, action: #selector(PlaceDetailVC.scrapAction(_sender:)))
        
        let titleBarBtn = UIBarButtonItem.titleBarbutton(title: "", red: 255, green: 255, blue: 255, fontSize: 14, fontName: NanumSquareOTF.NanumSquareOTFR.rawValue, selector: nil, target: self)
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
        tableView.addSubview(cycleScrollView)
        
    }
    
    func setcycleScrollView(placeData : PlaceDetailVOData){
        let serverImages = placeData.img
        var descs : [String]? = []
        for i in 0..<serverImages.count {
            descs?.append("\(i+1)/\(serverImages.count)")
        }
        cycleScrollView.serverImgArray = serverImages
        cycleScrollView.descTextArray = descs
        cycleScrollView.showPageControl = false
        
    } //setcycleScrollView
    
    func setBarButtons(placeData : PlaceDetailVOData){
        let titleBarBtn = UIBarButtonItem.titleBarbutton(title: placeData.scrapCnt.description, red: 255, green: 255, blue: 255, fontSize: 14, fontName: NanumSquareOTF.NanumSquareOTFR.rawValue, selector: nil, target: self)
        titleBarBtn.isEnabled = false
        if placeData.isScrap == 0{
            self.navigationItem.rightBarButtonItems = [whiteScrapBarBtn!, titleBarBtn]
        } else {
            self.navigationItem.rightBarButtonItems = [whiteFullScrapBarBtn!, titleBarBtn]
        }
    } //setBarButtons
    
    func setHeaderView(placeData : PlaceDetailVOData){
        scrapCount = placeData.scrapCnt
        ratingLbl.text = placeData.reviewScore.description
        titleLbl.text = placeData.name
        descLbl.text = placeData.description
        addressLbl.text = placeData.address
        currentStationLbl.text = placeData.station
        prevStationLbl.text = placeData.prevStation
        nextsStationLbl.text = placeData.nextStation
        if let lineNum = Int(placeData.lineNumber){
            staionImgView.image = UIImage(named: "place_detail_line_\(lineNum)")
            lineNumImgView.image = UIImage(named: "place_detail_dot_\(lineNum)")
        }
    } //setHeaderView
    
    func setFooterView(placeData : PlaceDetailVOData){
        openTimeLbl.text = placeData.openTime
        closeTimeLbl.text = placeData.closeTime
        contactLbl.text = placeData.contact
    } //setFooterView
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
            if navigationItem.rightBarButtonItems?[0] == whiteScrapBarBtn {
                navigationItem.rightBarButtonItems?[0] = blackScrapBarBtn!
            } else if navigationItem.rightBarButtonItems?[0] == whiteFullScrapBarBtn{
                 navigationItem.rightBarButtonItems?[0] = greenScrapBarBtn!
            }
            
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
        }
        else
        {
            navBarTintColor = .white
            navigationItem.leftBarButtonItem?.tintColor = .white
            navigationItem.rightBarButtonItems?[1].tintColor = .white
            if navigationItem.rightBarButtonItems?[0] == blackScrapBarBtn {
                navigationItem.rightBarButtonItems?[0] = whiteScrapBarBtn!
            } else if navigationItem.rightBarButtonItems?[0] == greenScrapBarBtn{
                navigationItem.rightBarButtonItems?[0] = whiteFullScrapBarBtn!
            }
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
        if let placeData_ = placeData{
            if section == 0 && placeData_.channel.channelID.count > 0{
                return 1
            } else if section == 1 && placeData_.reviews.count > 0{
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceDetailFirstTVCell.reuseIdentifier) as! PlaceDetailFirstTVCell
            cell.relatedChannel = placeData?.channel
            cell.delegate = self
            cell.senderDelegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceDetailSecondTVCell.reuseIdentifier) as! PlaceDetailSecondTVCell
            if let reviewScore = placeData?.reviewScore {
                cell.configure(reviewScore : reviewScore)
            }
            cell.reviewData = placeData?.reviews
            cell.delegate = self
            return cell
        }
    }
    
}

extension PlaceDetailVC : SelectSectionDelegate, SelectSenderDelegate {
    
    //SelectSenderDelegate
    func tap(section: Section, seledtedId: Int, sender: mySubscribeBtn) {
        if !isUserLogin() {
            goToLoginPage()
        } else {
            let params = ["channel_id" : sender.contentIdx]
            if sender.isSelected {
                self.unsubscribe(url: UrlPath.channelSubscription.getURL(sender.contentIdx?.description), sender: sender)
            } else {
                self.subscribe(url: UrlPath.channelSubscription.getURL(), params: params, sender: sender)
            }
        }
    }
    //SelectSectionDelegate
    func tap(section: Section, seledtedId: Int) {
        
        //관련/연예인 방송
        if section == .first {
            self.goToCelebrityDetail(selectedIdx : seledtedId)
        } else {
            //리뷰 보기
            let mapStoryboard = Storyboard.shared().mapStoryboard
            if let reviewContainerVC = mapStoryboard.instantiateViewController(withIdentifier:ReviewContainerVC.reuseIdentifier) as? ReviewContainerVC {
                
                reviewContainerVC.selectedIdx = self.selectedIdx
                
                if let reviewScore = placeData?.reviewScore {
                    reviewContainerVC.rating = reviewScore
                }
                self.navigationController?.pushViewController(reviewContainerVC, animated: true)
            }
            
            
        }
    }
}


//통신
extension PlaceDetailVC {
    func getPlaceInfo(url : String){
        PlaceDetailService.shareInstance.getPlaceData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let placeData):
                let placeData_ = placeData as! [PlaceDetailVOData]
                self.placeData = placeData_[0]
                self.isChange = true
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func scrap(url : String, params : [String:Any], sender : UIBarButtonItem){
        ChannelSubscribeService.shareInstance.subscribe(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                if self.navigationItem.rightBarButtonItems?[0] == self.whiteScrapBarBtn! {
                    self.navigationItem.rightBarButtonItems?[0] = self.whiteFullScrapBarBtn!
                } else {
                    self.navigationItem.rightBarButtonItems?[0] = self.greenScrapBarBtn!
                }
                var changed : Int = 0
                if self.navigationItem.rightBarButtonItems?[1].title == self.scrapCount.description {
                    changed = self.scrapCount+1
                } else {
                    changed = self.scrapCount
                }
                self.navigationItem.rightBarButtonItems?[1].title =  changed.description
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    } //subscribe
    
    func unscrap(url : String, sender : UIBarButtonItem){
        ChannelSubscribeService.shareInstance.unsubscribe(url: url, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                if self.navigationItem.rightBarButtonItems?[0] == self.whiteFullScrapBarBtn! {
                    self.navigationItem.rightBarButtonItems?[0] = self.whiteScrapBarBtn!
                } else {
                    self.navigationItem.rightBarButtonItems?[0] = self.blackScrapBarBtn!
                }
                var changed : Int = 0
                if self.navigationItem.rightBarButtonItems?[1].title == self.scrapCount.description {
                    changed = self.scrapCount-1
                } else {
                    changed = self.scrapCount
                }
                self.navigationItem.rightBarButtonItems?[1].title =  changed.description
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func subscribe(url : String, params : [String:Any], sender : mySubscribeBtn){
        ChannelSubscribeService.shareInstance.subscribe(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                sender.isSelected = true
                self.placeData?.channel.isSubscription[sender.indexPath!] = "1"
                /*let indexPath = IndexPath(item: sender.indexPath!, section: 0)
                 self.tableView.reloadRows(at: [indexPath], with: .top)*/
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    } //subscribe
    
    func unsubscribe(url : String, sender : mySubscribeBtn){
        ChannelSubscribeService.shareInstance.unsubscribe(url: url, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                sender.isSelected = false
                self.placeData?.channel.isSubscription[sender.indexPath!] = "0"
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
}



