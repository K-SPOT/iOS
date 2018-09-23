//
//  Extensions.swift
//  KSpot
//
//  Created by 강수진 on 2018. 8. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher

/*---------------------NSObject---------------------------*/
extension NSObject {
    static var reuseIdentifier:String {
        return String(describing:self)
    }
}



/*---------------------UIViewController---------------------------*/


//화면 이동
extension UIViewController {
    func goToPlaceDetailVC(selectedIdx : Int, isPlace : Bool = true, title : String = ""){
        let mapStoryboard = Storyboard.shared().mapStoryboard
        if let placeDetailVC = mapStoryboard.instantiateViewController(withIdentifier:PlaceDetailVC.reuseIdentifier) as? PlaceDetailVC {
            placeDetailVC.navigationItem.title = title
            placeDetailVC.isPlace = isPlace
            placeDetailVC.selectedIdx = selectedIdx
            self.navigationController?.pushViewController(placeDetailVC, animated: true)
        }
    } //goToPlaceDetailVC
    
    func goToCelebrityDetail(selectedIdx : Int, title : String = ""){
        let categoryStoryboard = Storyboard.shared().categoryStoryboard
        if let categoryDetailVC = categoryStoryboard.instantiateViewController(withIdentifier:CategoryDetailVC.reuseIdentifier) as? CategoryDetailVC {
            categoryDetailVC.navigationItem.title = title
            categoryDetailVC.selectedIdx = selectedIdx
            self.navigationController?.pushViewController(categoryDetailVC, animated: true)
        }
    } //goToCelebrityDetail
    
    func goToSearchVC(){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let mainSearchVC = mainStoryboard.instantiateViewController(withIdentifier:MainSearchVC.reuseIdentifier) as? MainSearchVC {
            
            self.navigationController?.pushViewController(mainSearchVC, animated: true)
        }
    } //goToSearchVC
    
    func goToLoginPage(){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let loginVC = mainStoryboard.instantiateViewController(withIdentifier:LoginVC.reuseIdentifier) as? LoginVC {
            
            self.present(loginVC, animated: true, completion: nil)
        }
    } //goToLoginPage
    
    //백버튼
    func setBackBtn(color : UIColor? = ColorChip.shared().barbuttonColor){
        let backBTN = UIBarButtonItem(image: UIImage(named: "category_detail_left_arrow"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
        } else {
            imgView.image = defaultImg
        }
    }
    func gsno(_ value : String?) -> String{
        return value ?? ""
    }
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    
    func setLanguageFlag(langugae : Language ){
        UserDefaults.standard.set(langugae.rawValue.description, forKey : "flag")
    }
    
    func isUserLogin() -> Bool {
        return FBSDKAccessToken.currentAccessTokenIsActive()
            // &&UserDefaults.standard.string(forKey: "userAuth") != "-1"
    }
    
    func simpleAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
      
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func simpleAlertwithHandler(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소",style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addChildView(containerView : UIView, asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    func removeChildView(containerView : UIView, asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func customBarbuttonItem(title : String, red : Double, green : Double, blue : Double, fontSize : Int, selector : Selector?)->UIBarButtonItem{
        let customBarbuttonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        let fontSize = UIFont.systemFont(ofSize: CGFloat(fontSize))
        customBarbuttonItem.setTitleTextAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): fontSize,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1.0) )
            ], for: UIControlState.normal)
        return customBarbuttonItem
    }
    
}

/*---------------------UIView---------------------------*/

extension UIView {
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
             self.layer.cornerRadius = self.layer.frame.height/2
        }
        self.layer.masksToBounds = true
    }
    
    
    
    func makeViewBorder(width : Double, color : UIColor){
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}

/*---------------------UIImageView---------------------------*/
/*extension UIImageView {
    func makeImageRound(){
        self.layer.cornerRadius = self.layer.frame.width/2
        self.layer.masksToBounds = true
    }
    
    func makeImgBorder(width : Double, color : UIColor){
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
}*/


/*---------------------UIButton---------------------------*/
extension UIButton{
    func setImage(selected : UIImage, unselected : UIImage){
        self.setImage(selected, for: .selected)
        self.setImage(unselected, for: .normal)
    }
}

/*---------------------UIBarButtonItem---------------------------*/
extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    class func titleBarbutton(title : String, red : Double, green : Double, blue : Double, fontSize : CGFloat, fontName : String, selector : Selector?, target: AnyObject)->UIBarButtonItem{
        let customBarbuttonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        let customFont = UIFont(name: fontName, size: fontSize)!
        customBarbuttonItem.setTitleTextAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): customFont,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1.0) )
            ], for: UIControlState.normal)
        customBarbuttonItem.setTitleTextAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): customFont,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1.0) )
            ], for: UIControlState.selected)
        
        return customBarbuttonItem
    }
}

/*---------------------UICollectionViewCell---------------------------*/
extension UICollectionViewCell {
    func makeCornerRound(cornerRadius : CGFloat){
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        self.contentView.layer.masksToBounds = true
    }
    
    
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
        } else {
            imgView.image = defaultImg
        }
    }
 
}

extension UITableViewCell {
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
        } else {
            imgView.image = defaultImg
        }
    }
  
}

extension mySubscribeBtn {
    func setSubscribeBtn(idx : Int, isSubscribe : Int){
        self.setImage(UIImage(named: "category_subscription_white"), for: .normal)
        self.setImage(
            UIImage(named: "category_subscription_green"), for: .selected)
        self.contentIdx = idx
        if isSubscribe == 0 {
            self.isSelected = false
        } else {
            self.isSelected = true
        }
    }
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

/*---------------------String---------------------------*/
extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}



