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

  
    var dict : [String : AnyObject]!
    var dict1 : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                    print("user token :")
                    print(AccessToken.current?.authenticationToken ?? "")
                    self.getFBUserData()
                }
                
               
               /* if(fbloginresult.grantedPermissions.contains("email")){
                    print("11")
                    //self.getFBUserData()
                    //fbLoginManager.logOut()
                    
                }*/
            }
        }
        
        
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                if(error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    print(self.dict["name"])
                    self.dismiss(animated: false, completion: nil)
                    //self.performSegue(withIdentifier: "ToSettings", sender: self)
                } else {
                    print("??")
                }
            })
        }
    }
    

}
