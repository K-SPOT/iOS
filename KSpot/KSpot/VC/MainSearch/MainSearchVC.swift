//
//  MainSearchVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 9..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MainSearchVC: UIViewController, UIGestureRecognizerDelegate {
    var keyboardDismissGesture: UITapGestureRecognizer?
    
    @IBOutlet weak var searchIconBtn: UIButton!
    @IBOutlet weak var searchTxtfield: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var celebrityStack: UIStackView!
    
    @IBOutlet weak var broadcastStack: UIStackView!
    
    @IBOutlet weak var eventStack: UIStackView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        setKeyboardSetting()
        setStackViewAction()
        searchTxtfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchBtn.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        searchIconBtn.addTarget(self, action: #selector(searchIconAction(_:)), for: .touchUpInside)
        getSearchData(url: UrlPath.mainSearch.getURL())
        // textfeild.delegate = self 하기
    }
    
    func setStackViewContent(searchData : MainSearchVOData?){
        guard let searchData = searchData else {return}
        for i in 0..<searchData.celebrity.count {
            let button = celebrityStack.arrangedSubviews[i] as! UIButton
            button.setTitle(searchData.celebrity[i].name, for: .normal)
            button.tag = searchData.celebrity[i].channelId
        }
        for i in 0..<searchData.broadcast.count {
            let button = broadcastStack.arrangedSubviews[i] as! UIButton
            button.setTitle(searchData.broadcast[i].name, for: .normal)
            button.tag = searchData.broadcast[i].channelId
        }
        for i in 0..<searchData.event.count {
            let button = eventStack.arrangedSubviews[i] as! UIButton
            button.setTitle(searchData.event[i].name, for: .normal)
            button.tag = searchData.event[i].spotID
        }
    }
    
    func setStackViewAction(){
        for celebrityBtn in celebrityStack.arrangedSubviews as! [UIButton]{
            celebrityBtn.addTarget(self, action: #selector(MainSearchVC.goToCelebrityDetail(_:)), for: .touchUpInside)
        }
        for broadcastBtn in broadcastStack.arrangedSubviews as! [UIButton]{
            broadcastBtn.addTarget(self, action: #selector(MainSearchVC.goToCelebrityDetail(_:)), for: .touchUpInside)
        }
        for eventBtn in eventStack.arrangedSubviews as! [UIButton]{
            eventBtn.addTarget(self, action: #selector(MainSearchVC.goToPlaceDetailVC(_:)), for: .touchUpInside)
        }
       
    }
    
    @objc func goToCelebrityDetail(_ sender : UIButton){
        self.goToCelebrityDetail(selectedIdx : sender.tag)
    }
    
    @objc func goToPlaceDetailVC(_ sender : UIButton){
        self.goToPlaceDetailVC(selectedIdx: sender.tag)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !(searchTxtfield.text?.isEmpty)! {
            searchBtn.backgroundColor = ColorChip.shared().mainColor
            searchBtn.isEnabled = true
            searchIconBtn.setImage(#imageLiteral(resourceName: "map_filter_x_button"), for: .normal)
        } else {
            searchBtn.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
            searchBtn.isEnabled = false
            searchIconBtn.setImage(#imageLiteral(resourceName: "main_search"), for: .normal)
        }
    }
    
    @objc func searchAction(_ button : UIButton) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultVC.reuseIdentifier) as? SearchResultVC {
            //네비게이션 타이틀
            guard let searchTxt = searchTxtfield.text else{return}
            if ((searchTxt.count) < 10) {
                 searchResultVC.navigationItem.title = searchTxtfield.text
            } else {
                searchResultVC.navigationItem.title = "\(searchTxt.prefix(9))..."
            }
            searchResultVC.searchTxt = searchTxt
            self.navigationController?.pushViewController(searchResultVC, animated: true)
        }
    }
    
    @objc func searchIconAction(_ button : UIButton) {
        searchTxtfield.text = ""
        textFieldDidChange(searchTxtfield)
        
    }


}
//키보드 대응
extension MainSearchVC{
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
       
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            searchBtn.snp.remakeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-keyboardSize.height)
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
            searchBtn.snp.remakeConstraints({ (make) in
                make.bottom.equalToSuperview()
            })
        
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
        self.view.endEditing(true)
    }
    
}

//txtField Delegate (엔터버튼 클릭시)
extension MainSearchVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        return true
    }
}

//통신
extension MainSearchVC {
    func getSearchData(url : String){
        MainSearchService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let mainSearchData):
                let searchData = mainSearchData as? MainSearchVOData
                self.setStackViewContent(searchData: searchData)
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}


