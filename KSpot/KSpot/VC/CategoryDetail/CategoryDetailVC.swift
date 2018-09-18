//
//  CategoryDetailVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

private let TOPVIEW_HEIGHT:CGFloat = 269
private let NAVBAR_COLORCHANGE_POINT:CGFloat = TOPVIEW_HEIGHT - CGFloat(kNavBarBottom * 2)

class CategoryDetailVC: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var backgroundImg :UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "cimg"))
        
        return imgView
    }()
    lazy var logoImg :UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "aimg"))
        
        return imgView
    }()
    
    lazy var mainTitleLbl:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = .black
        label.text = "짱절미"
        label.textAlignment = .left
        label.font = UIFont(name: NanumSquareOTF.NanumSquareOTFB.rawValue, size: 20)
        return label
    }()
    lazy var subTitleLbl:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        label.text = "절미쓰 엔터테이먼트"
        label.textAlignment = .left
        label.font = UIFont(name: NanumSquareOTF.NanumSquareOTFR.rawValue, size: 14)
        return label
    }()
    
    lazy var subscribeLbl:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        label.text = "1,445,054"
        label.textAlignment = .left
        label.font = UIFont(name: NanumSquareOTF.NanumSquareOTFR.rawValue, size: 14)
        return label
    }()
    
    lazy var subscribeBtn:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "category_subscription_white"), for: .normal)
        button.addTarget(self, action: #selector(CategoryDetailVC.subscribeAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var bottomGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: TOPVIEW_HEIGHT)
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    
    @IBAction func scrollToTopAction(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    @objc func subscribeAction(_ : UIButton){
        print("구독버튼 클릭")
    }
    
    
    let sunglassArr1 = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    let sunglassArr2 : [UIImage] =  [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    override func viewDidLoad() {
        
        setupTableView()
        setupNavView()
    }
    
    func setupTableView(){
        tableView.contentInset = UIEdgeInsetsMake(-CGFloat(kNavBarBottom), 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        makeTopViewConstraint()
        tableView.tableHeaderView = topView
    }
    
}

//네비게이션 및 탑 뷰 설정
extension CategoryDetailVC {
    //네비게이션 설정
    func setupNavView(){
        setBackBtn(color: .white)
        self.navigationItem.title = ""
        //네비게이션바 컬러
        navBarBarTintColor = .white
        navBarBackgroundAlpha = 0
        //네비게이션 바 안의 아이템 컬러
        navBarTintColor = .white
    }
    //탑뷰 설정
    func makeTopViewConstraint(){
        
        topView.addSubview(backgroundImg)
        topView.addSubview(logoImg)
        topView.addSubview(mainTitleLbl)
        topView.addSubview(subTitleLbl)
        topView.addSubview(subscribeLbl)
        topView.addSubview(subscribeBtn)
        topView.addSubview(bottomGrayView)
        
        backgroundImg.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(165)
            
        }
        
        logoImg.snp.makeConstraints { (make) in
            make.height.width.equalTo(74)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(backgroundImg.snp.bottom) //centerVertically
        }
        logoImg.makeRounded(cornerRadius: 37)
        mainTitleLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(logoImg.snp.trailing).offset(8)
            make.top.equalTo(backgroundImg.snp.bottom).offset(16)
        }
        subTitleLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(mainTitleLbl.snp.leading)
            make.top.equalTo(mainTitleLbl.snp.bottom).offset(9)
        }
        subscribeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(57)
            make.centerY.equalTo(mainTitleLbl.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            
        }
        subscribeLbl.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(subscribeBtn.snp.bottom).offset(9)
        }
        bottomGrayView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    } //setConstraint
}


// MARK: - 스크롤 할 때
extension CategoryDetailVC
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        if (offsetY > NAVBAR_COLORCHANGE_POINT)
        {
            
            navBarTintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
            navBarTintColor = UIColor.black.withAlphaComponent(alpha)
            navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            statusBarStyle = .default
        }
        else
        {
            
            navBarTintColor = .white
            navigationItem.leftBarButtonItem?.tintColor = .white
            
            navBarBackgroundAlpha = 0
            navBarTitleColor = .white
            statusBarStyle = .lightContent
        }
    }
}


extension CategoryDetailVC : UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return sunglassArr1.count
        } else {
            return sunglassArr2.count
        }
    }
    
    
    //headerSection View 만드는 것
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVHeaderCell.reuseIdentifier) as! CategoryDetailSecondTVHeaderCell
        
        if section == 1 {
            header.titleLbl.text = "관련된 장소"
            header.morBtn.addTarget(self, action: #selector(placeMoreAction(_:)), for: .touchUpInside)
            
            return header
        } else if section == 2{
            header.titleLbl.text = "관련된 이벤트"
            header.morBtn.addTarget(self, action: #selector(eventMoreAction(_:)), for: .touchUpInside)
            return header
        } else {
            return nil
        }
    }
    
    @objc func placeMoreAction(_ sender : UIButton){
        let categoryStoryboard = Storyboard.shared().categoryStoryboard
        if let categoryDetailMoreVC = categoryStoryboard.instantiateViewController(withIdentifier:CategoryDetailMoreVC.reuseIdentifier) as? CategoryDetailMoreVC {
            categoryDetailMoreVC.title = "장소"
            self.navigationController?.pushViewController(categoryDetailMoreVC, animated: true)
        }
    }
    
    @objc func eventMoreAction(_ sender : UIButton){
        let categoryStoryboard = Storyboard.shared().categoryStoryboard
        if let categoryDetailMoreEventVC = categoryStoryboard.instantiateViewController(withIdentifier:CategoryDetailMoreEventVC.reuseIdentifier) as? CategoryDetailMoreEventVC {
            
            categoryDetailMoreEventVC.title = "이벤트"
            self.navigationController?.pushViewController(categoryDetailMoreEventVC, animated: true)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return heightForHeaderInSection(arr : sunglassArr1)
        } else if section == 2 {
            return heightForHeaderInSection(arr : sunglassArr2)
        } else {
            return 0
        }
        //return section == 1 || section == 2  ? 79 : 0
    }
    
    private func heightForHeaderInSection(arr : [UIImage]) -> CGFloat {
        if (arr.count > 0){
            return 62
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailFirstTVCell.reuseIdentifier) as! CategoryDetailFirstTVCell
            cell.delegate = self
            return cell
            
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVCell.reuseIdentifier) as! CategoryDetailSecondTVCell
            if indexPath.section == 1 {
                //cell.configure
            } else {
                //cell.configure
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1  {
            goToPlaceDetailVC()
        } else if indexPath.section == 2 {
            goToCelebrityDetail()
        }
    }
    
}

extension CategoryDetailVC : SelectSectionDelegate {
    func tap(section: Section, seledtedId: Int) {
        if section == .first {
            goToPlaceDetailVC()
        }
    }
}
