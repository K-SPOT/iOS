//
//  LoginVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore


class LoginVC: UIViewController {

  
  //  var dict : [String : AnyObject]!
     @IBOutlet weak var skipBtn: UIButton!
     @IBOutlet weak var xBtn: UIButton!
    var entryPoint = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       // setLanguageFlag(langugae: .kor)
      
        skipBtn.addTarget(self, action: #selector(self.dismiss(_:)), for: .touchUpInside)
        xBtn.addTarget(self, action: #selector(self.dismiss(_:)), for: .touchUpInside)
        //처음으로 들어온 것
        if entryPoint == 1 {
            skipBtn.isHidden = false
            xBtn.isHidden = true
        } else {
            skipBtn.isHidden = true
            xBtn.isHidden = false
        }
    }
    
    @objc func dismiss(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func facebookLoginAction(_ sender: UIButton) {
        
        /* Facebook SDK 사용합니다. */
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = .native // .web, .brower, .systemAccount

        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.isCancelled {
                    print("취소됨")
                } else {
                    let currentToken = AccessToken.current?.authenticationToken ?? ""
                    let param = ["access_token" : currentToken]
                    self.facebookLogin(url: UrlPath.facebookLogin.getURL(), params: param)
                }
            }
        }
    }
}

//통신
extension LoginVC {
    func facebookLogin(url : String, params : [String:Any]){
        FacebookLoginService.shareInstance.login(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let loginData):
                //유저 값 설정
                let userData = loginData as? FacebookLoginVOData
                 UserDefaults.standard.set(userData?.id, forKey: "userId")
                 UserDefaults.standard.set(userData?.authorization, forKey : "userAuth")
                //isLogin = true
                self.dismiss(animated: false, completion: nil)
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    } //login
}
