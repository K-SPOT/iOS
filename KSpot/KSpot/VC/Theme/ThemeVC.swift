//
//  ThemeVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 10..
//  Copyright © 2018년 강수진. All rights reserved.
//


import UIKit
import SnapKit

private let IMAGE_HEIGHT:CGFloat = 284
private let NAVBAR_COLORCHANGE_POINT:CGFloat = IMAGE_HEIGHT - CGFloat(kNavBarBottom * 2)

class ThemeVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView : UITableView!
    var whiteScrapBarBtn : UIBarButtonItem?
    var blackScrapBarBtn : UIBarButtonItem?
    
    lazy var titleLbl:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "방탄소년단's PICK! \n HOT PLACE 5"
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 10)
        label.textAlignment = .center
        label.font = UIFont(name: NanumSquareOTF.NanumSquareOTFB.rawValue, size: 22)
        return label
    }()
    lazy var subtitleLbl:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "#논현동 #압구정동 #신사동 #가락시장"
        label.textAlignment = .center
         label.font = UIFont(name: NanumSquareOTF.NanumSquareOTFR.rawValue, size: 15)
        return label
    }()
    
    lazy var topView:UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "aimg"))
        imgView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: IMAGE_HEIGHT)
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupTableView()
        setupNavView()
    }
    
    deinit {
        tableView.delegate = nil
        print("ThemeVC deinit")
    }
    
    func setupTableView(){
        tableView.contentInset = UIEdgeInsetsMake(-CGFloat(kNavBarBottom), 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        topView.addSubview(titleLbl)
        topView.addSubview(subtitleLbl)
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(topView)
        }
        subtitleLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLbl)
            make.top.equalTo(titleLbl.snp.bottom).offset(24)
        }
        
        tableView.tableHeaderView = topView
    }
    
    
}

//네비게이션 설정
extension ThemeVC {
    
    func setupNavView(){
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
}


// MARK: - 스크롤 할 때
extension ThemeVC
{
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
            navBarTintColor = UIColor.black.withAlphaComponent(alpha)
            navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            statusBarStyle = .default
        }
        else
        {
            
            navBarTintColor = .white
            navigationItem.leftBarButtonItem?.tintColor = .white
            navigationItem.rightBarButtonItems?[1].tintColor = .white
            navigationItem.rightBarButtonItems?[0] = whiteScrapBarBtn!
            navBarBackgroundAlpha = 0
            navBarTitleColor = .white
            statusBarStyle = .lightContent
        }
    }
}


//tableView dataSource, delegate
extension ThemeVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThemeTVCell.reuseIdentifier) as! ThemeTVCell
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}



