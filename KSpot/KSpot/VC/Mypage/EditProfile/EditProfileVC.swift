//
//  EditProfileVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 10..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nameTxtfield: UITextField!
    @IBOutlet weak var nameCountLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    
    var keyboardDismissGesture: UITapGestureRecognizer?
   
    var greenDoneBtn : UIBarButtonItem?
    var grayDoneBtn : UIBarButtonItem?
    //let imagePicker : UIImagePickerController = UIImagePickerController()
    var profileImg : UIImage?
    var nameTxt : String = ""
    var imageData : Data? {
        didSet {
            if imageData != nil {
                if let imageData_ = imageData {
                    //makeImgView()
                    profileImgView.image =  UIImage(data: imageData_)
                    //isValid()
                }
            }
        }
    }
    
    @IBAction func imageTapAction(_ sender: Any) {
        print("tapped")
        openGallery()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         grayDoneBtn = UIBarButtonItem.titleBarbutton(title: "완료", red: 236, green: 236, blue: 236, fontSize: 18, fontName: NanumSquareOTF.NanumSquareOTFB.rawValue, selector: nil, target: self)
        greenDoneBtn = UIBarButtonItem.titleBarbutton(title: "완료", red: 64, green: 211, blue: 159, fontSize: 18, fontName: NanumSquareOTF.NanumSquareOTFB.rawValue, selector: #selector(EditProfileVC.doneAction(_sender:)), target: self)
        self.navigationItem.rightBarButtonItem = greenDoneBtn
        profileImgView.makeRounded(cornerRadius: nil)
        nameTxtfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameCountLbl.text = nameTxt.count.description
        nameTxtfield.text = nameTxt
        profileImgView.image = profileImg
        setBackBtn()
        setKeyboardSetting()
    }
    
    @objc func doneAction(_sender : UIBarButtonItem) {
        editProfile(url: UrlPath.userEdit.getURL(), editedName: nameTxtfield.text!)
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
       
        if let text = nameTxtfield.text {
            nameCountLbl.text = text.count.description
        } else {
            nameCountLbl.text = "0"
        }
        guard let contentTxt = nameTxtfield.text else {return}

        if contentTxt.count < 2 {
            self.navigationItem.rightBarButtonItem = grayDoneBtn
        } else {
            self.navigationItem.rightBarButtonItem = greenDoneBtn
        }
        if(contentTxt.count > 20) {
            simpleAlert(title: "오류", message: "20글자 초과")
            nameTxtfield.text = String(describing: contentTxt.prefix(19))
            nameCountLbl.text = nameTxtfield.text?.count.description
        }
    }
    
    private func simpleOKAlert(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default, handler: okHandler)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


//앨범 열기 위함
extension EditProfileVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //사용자 취소
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //크롭한 이미지
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(editedImage, 0.1)
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageData = UIImageJPEGRepresentation(originalImage, 0.1)
        }
        
        self.dismiss(animated: true)
    }
    
    // Method
    func openGallery(){
        let selectAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let defualtAction = UIAlertAction(title: "기본 이미지 선택", style: .default) {
            _ in
            self.imageData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "mypage_membership_edit_default_img"), 0.1)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        selectAlert.addAction(libraryAction)
        selectAlert.addAction(defualtAction)
        selectAlert.addAction(cancelAction)
        self.present(selectAlert, animated: true, completion: nil)
    }
    
}


//키보드 대응
extension EditProfileVC{
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        self.editBtn.isHidden = true
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        self.editBtn.isHidden = false
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

//통신
extension EditProfileVC {
    func editProfile(url : String, editedName : String ){
       
        
        let params : [String : Any] = [
            "name" : editedName
        ]
        
        var images : [String : Data]?
        if let image = imageData {
            images = [
                "profile_img" : image
            ]
        }
        
        UserEditService.shareInstance.editProfile(url: url, params: params, image: images, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                self.simpleOKAlert(title: "확인", message: "프로필 변경이 완료되었습니다", okHandler: { (_) in
                     self.pop()
                })
            case .duplicated :
                self.simpleAlert(title: "오류", message: "중복된 아이디입니다")
            case .networkFail :
                self.simpleAlert(title: "오류", message: "인터넷 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
        
        
    }
}
