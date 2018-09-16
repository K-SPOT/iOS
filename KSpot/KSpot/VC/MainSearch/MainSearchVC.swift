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
    
    @IBOutlet weak var searchTxtfield: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        setKeyboardSetting()
        searchTxtfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchBtn.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        // textfeild.delegate = self 하기
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !(searchTxtfield.text?.isEmpty)! {
            searchBtn.backgroundColor = ColorChip.shared().mainColor
            searchBtn.isEnabled = true
        } else {
            searchBtn.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
            searchBtn.isEnabled = false
        }
    }
    
    @objc func searchAction(_ button : UIButton) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let mainSearchVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultVC.reuseIdentifier) as? SearchResultVC {
            //네비게이션 타이틀
            mainSearchVC.title = searchTxtfield.text
            self.navigationController?.pushViewController(mainSearchVC, animated: true)
        }
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
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
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
        self.view.endEditing(true)
    }
    
}

//txtField Delegate (엔터버튼 클릭시)
extension MainSearchVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        return true
    }
}


