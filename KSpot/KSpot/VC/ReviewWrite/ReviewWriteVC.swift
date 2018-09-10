//
//  ReviewWriteVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 9..
//  Copyright © 2018년 강수진. All rights reserved.


import UIKit
import SnapKit

class ReviewWriteVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var scrollTopView: UIView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var writeCountLbl: UILabel!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var contentImgView: UIImageView = UIImageView()
    var images : [String : Data]?
    var keyboardDismissGesture: UITapGestureRecognizer?
    let imagePicker : UIImagePickerController = UIImagePickerController()
    let defaultTxtMsg = "생각을 공유해보세요"
    lazy var deleteImgBtn : UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.setImage(#imageLiteral(resourceName: "review_write_x"), for: .normal)
        button.addTarget(self, action: #selector(ReviewWriteVC.deleteImg(_sender:)), for: .touchUpInside)
        return button
    }()
    
    var imageData : Data? {
        didSet {
            if imageData != nil {
                if let imageData_ = imageData {
                    makeImgView()
                    contentImgView.image =  UIImage(data: imageData_)
                    isValid()
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardSetting()
        setToolbar()
        titleTxtField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        contentTxtView.delegate = self
        contentTxtView.text = defaultTxtMsg
        contentTxtView.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        doneBtn.isEnabled = false
        doneBtn.tintColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        ratingView.settings.fillMode = .half
        ratingView.didTouchCosmos = didTouchCosmos
        
        ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos
    }
    
    
    @objc func clickImg(){
        openGallery()
    }
    @objc public func deleteImg (_sender: UIButton) {
        removeImgView()
    }
    
    @objc func isValid(){
        if (!(titleTxtField.text?.isEmpty)! && !(contentTxtView.text.isEmpty)){
            
            doneBtn.isEnabled = true
            doneBtn.tintColor = ColorChip.shared().mainColor
            
        } else {
            doneBtn.isEnabled = false
            doneBtn.tintColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        }
    } //isValid
    
}

extension ReviewWriteVC {
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
       
        self.ratingLbl.text = ReviewWriteVC.formatValue(rating)
    
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.ratingLbl.text = ReviewWriteVC.formatValue(rating)
       
    }
}

//이미지뷰에 대한 추가 및 삭제
extension ReviewWriteVC {
    func makeImgView(){
        self.scrollTopView.addSubview(contentImgView)
        self.scrollTopView.addSubview(deleteImgBtn)
        deleteImgBtn.contentMode = .scaleAspectFit
        contentImgView.snp.makeConstraints { (make) in
            //make.height.equalTo(302)
            make.top.equalTo(writeCountLbl.snp.bottom).offset(22.5)
            make.bottom.equalToSuperview().offset(-23)
            make.leading.trailing.equalTo(contentTxtView)
            make.height.equalTo(contentImgView.snp.width)
            
        }
        
        deleteImgBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
            make.trailing.equalTo(contentImgView.snp.trailing).offset(-16)
            make.top.equalTo(contentImgView.snp.top).offset(16)
        }
    }
    
    func removeImgView(){
        self.imageData = nil
        self.contentImgView.removeFromSuperview()
        self.deleteImgBtn.removeFromSuperview()
    }
    
}


//custom toolbar
extension ReviewWriteVC {
    func setToolbar(){
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        let pictureImg = UIImage(named: "review_write_picture_upload")?.withRenderingMode(.alwaysOriginal)
        let pictureBtn = UIBarButtonItem(image: pictureImg, style: .plain, target: self, action: #selector(clickImg))
        
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
            target: nil,
            action: nil
        )
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        fixedSpace.width = 20
        toolbar.items = [pictureBtn, flexibleSpace]
        toolbar.barTintColor = .white
        toolbar.sizeToFit()
        contentTxtView.inputAccessoryView = toolbar
    }
}


//TextView delegate
extension ReviewWriteVC : UITextViewDelegate{
    
    //텍스트뷰 플레이스 홀더처럼
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = defaultTxtMsg
            textView.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        }
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        /*if let myString = textView.text {
         let emptySpacesCount = myString.components(separatedBy: " ").count-1
         if emptySpacesCount == myString.count {
         doneBtn.tintColor = .gray
         doneBtn.isEnabled = false
         return
         }
         
         let nCount = myString.components(separatedBy: "\n").count-1
         if nCount == myString.count {
         doneBtn.tintColor = .gray
         doneBtn.isEnabled = false
         return
         }
         
         let nCount_emptySpaceCount = nCount+emptySpacesCount
         if nCount_emptySpaceCount == myString.count {
         doneBtn.tintColor = .gray
         doneBtn.isEnabled = false
         return
         }
         }*/
        isValid()
        if let text = contentTxtView.text {
            writeCountLbl.text = text.count.description
        } else {
            writeCountLbl.text = "0"
        }
        guard let contentTxt = contentTxtView.text else {return}
        if(contentTxt.count > 1000) {
            simpleAlert(title: "오류", message: "1000글자 초과")
            contentTxtView.text = String(describing: contentTxt.prefix(999))
            isValid()
            //doneBtn.tintColor = .green
            //doneBtn.isEnabled = true
        }
    }
}


//키보드 대응
extension ReviewWriteVC {
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardEndframe = self.view.convert(keyboardSize, from: nil)
            self.scrollView.contentInset.bottom = keyboardEndframe.height
            self.scrollView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        self.view.layoutIfNeeded()
    }
    
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


//앨범 열기 위함
extension ReviewWriteVC : UIImagePickerControllerDelegate,
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
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            //false 로 되어있으면 이미지 자르지 않고 오리지널로 들어감
            //이거 true로 하면 crop 가능
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
}


