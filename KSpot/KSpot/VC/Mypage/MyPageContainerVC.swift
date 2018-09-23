//
//  MyPageContainerVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 24..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MyPageContainerVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var currentSelectedLang = selectedLang
    var currentIsLogin = isLogin
    private lazy var mypageVC: MypageVC = {
        let storyboard = Storyboard.shared().mypageStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: MypageVC.reuseIdentifier) as! MypageVC

        return viewController
    }()
    
    private lazy var mypageLoginVC: MypageLoginVC = {
        let storyboard = Storyboard.shared().mypageStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: MypageLoginVC.reuseIdentifier) as! MypageLoginVC
        return viewController
    }()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FBSDKAccessToken.current() == nil {
            updateView(selected: 1)
        } else {
            updateView(selected: 0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         setTranslationBtn()
    }

    private func updateView(selected : Int) {
        if selected == 0 {
            
            removeChildView(containerView: containerView, asChildViewController: mypageLoginVC)
            
            addChildView(containerView: containerView, asChildViewController: mypageVC)
        } else {
            removeChildView(containerView: containerView, asChildViewController: mypageVC)
            
            addChildView(containerView: containerView, asChildViewController: mypageLoginVC)
        }
    }


}
