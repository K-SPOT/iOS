//
//  CategoryVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var celebrityBtn: CategoryToggleBtn!
    @IBOutlet weak var celebrityGreenView: UIView!
    @IBOutlet weak var broadcastBtn: CategoryToggleBtn!
    
    @IBOutlet weak var broadcastGreenView: UIView!
    
    
    private lazy var celebrityVC: CelebrityVC = {
        let storyboard = Storyboard.shared().categoryStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: CelebrityVC.reuseIdentifier) as! CelebrityVC
        return viewController
    }()
    
    private lazy var broadcastVC: BroadcastVC = {
        let storyboard = Storyboard.shared().categoryStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: BroadcastVC.reuseIdentifier) as! BroadcastVC
        return viewController
    }()
    
   
    @IBAction func switchView(_ sender: CategoryToggleBtn) {
        updateView(selected: sender.tag)
    }
    
     var keyboardDismissGesture: UITapGestureRecognizer?
    lazy var navSearchView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var searchGrayView : UIImageView = {
        let imgView = UIImageView()
        
        imgView.image = #imageLiteral(resourceName: "community_search_field_none")
        return imgView
    }()
    
    lazy var searchView : UIImageView = {
        let imgView = UIImageView()
        
        imgView.image = #imageLiteral(resourceName: "main_search")
        return imgView
    }()
    
    lazy var searchTxtField : UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "검색어를 입력하세요"
        txtField.font = UIFont.systemFont(ofSize: 14.0)
         txtField.addTarget(self, action: #selector(searchAction), for: .editingChanged)
        return txtField
    }()
    
    @objc func searchAction(){
        //실시간 통신
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        celebrityBtn.setBtn(another: broadcastBtn, bottomLine: celebrityGreenView)
        broadcastBtn.setBtn(another: celebrityBtn, bottomLine: broadcastGreenView)
        updateView(selected: 0)
        searchTxtField.delegate = self
        setDefaultNav()
         self.navigationController?.navigationBar.shadowImage = UIImage()
        setKeyboardSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = false
        //viewWillLayoutSubviews()
    }
}

//컨테이너뷰
extension CategoryVC{
    private func updateView(selected : Int) {
        if selected == 0 {
        
            removeChildView(containerView: containerView, asChildViewController: broadcastVC)
          
            addChildView(containerView: containerView, asChildViewController: celebrityVC)
        } else {
            removeChildView(containerView: containerView, asChildViewController: celebrityVC)
          
            addChildView(containerView: containerView, asChildViewController: broadcastVC)
        }
    }

}


//네비게이션 기본바 커스텀
extension CategoryVC {
    
    @objc func setDefaultNav(){
        //setupTitleNavImg
       /* let titleImageView = UIImageView(image: #imageLiteral(resourceName: "bimg"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.width.equalTo(52)
        }*/
        navigationItem.titleView = nil
        
       navigationItem.title = "K-Spot"
        navigationController?.navigationBar.isTranslucent = false
        
        //setupLeftNavItem
        let translateBtn = UIButton(type: .system)
        translateBtn.setImage(#imageLiteral(resourceName: "navigationbar_translation").withRenderingMode(.alwaysOriginal), for: .normal)
        translateBtn.addTarget(self, action:  #selector(CategoryVC.toTranslate(_sender:)), for: .touchUpInside)
        translateBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: translateBtn)
        
        //setupRightNavItem
        let searchBtn = UIButton(type: .system)
        searchBtn.setImage(#imageLiteral(resourceName: "main_search").withRenderingMode(.alwaysOriginal), for: .normal)
        searchBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        searchBtn.addTarget(self, action:  #selector(CategoryVC.search(_sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        
    }
    
    
    
}

//기본 네비게이션 바에서 오른쪽/왼쪽 아이템에 대한 행동
extension CategoryVC {
    @objc public func toTranslate(_sender: UIButton) {
        //1. 나중에 goFirst 했던 것처럼 해당 뷰로 exit 바로 할수 있도록 하기
        //마이페이지 통신
        
    }
    
    @objc public func search(_sender: UIButton) {
        makeSearchBarView()
        self.navigationItem.leftBarButtonItem = nil
        
    }
    
    
}

//네비게이션 서치바 커스텀
extension CategoryVC{
    func makeSearchBarView() {
        navSearchView.snp.makeConstraints { (make) in
            make.width.equalTo(311)
            make.height.equalTo(31)
            // make.leading.equalTo(self.)
        }
        navSearchView.addSubview(searchGrayView)
        navSearchView.addSubview(searchView)
        navSearchView.addSubview(searchTxtField)
        
        searchGrayView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(navSearchView)
        }
        
        searchView.snp.makeConstraints { (make) in
            make.leading.equalTo(searchGrayView).offset(10)
            make.width.height.equalTo(15)
            make.centerY.equalTo(searchGrayView)
        }
        
        searchTxtField.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalTo(searchGrayView)
            make.leading.equalTo(searchView.snp.trailing).offset(8)
        }
        
        searchTxtField.delegate = self
        navigationItem.titleView = navSearchView
        navigationController?.navigationBar.isTranslucent = false
        
        //rightBarBtn
        let rightBarButton = customBarbuttonItem(title: "취소", red: 112, green: 112, blue: 112, fontSize: 14, selector: #selector(setDefaultNav))
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

//txtField Delegate (엔터버튼 클릭시)
extension CategoryVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            simpleAlert(title: "오류", message: "검색어 입력")
            return false
        }
        
        if let myString = textField.text {
            let emptySpacesCount = myString.components(separatedBy: " ").count-1
            
            if emptySpacesCount == myString.count {
                
                simpleAlert(title: "오류", message: "검색어 입력")
                return false
            }
        }
        
        if let searchString_ = textField.text {
            //검색
        }
        return true
    }
}

//키보드 대응
extension CategoryVC{
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
       adjustKeyboardDismissGesture(isKeyboardVisible: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        searchTxtField.text = ""
        // setDefaultNav()
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        
    }
    
    //화면 바깥 터치했을때 키보드 없어지는 코드
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.navSearchView.endEditing(true)
    }
    
}

