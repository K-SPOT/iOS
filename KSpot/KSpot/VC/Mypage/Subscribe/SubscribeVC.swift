//
//  SubscribeVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 10..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SubscribeVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var celebrityBtn: CategoryToggleBtn!
    @IBOutlet weak var celebrityGreenView: UIView!
    @IBOutlet weak var broadcastBtn: CategoryToggleBtn!
    
    @IBOutlet weak var broadcastGreenView: UIView!
    
    
    private lazy var celebrityVC: SubCelebrityVC = {
        let storyboard = Storyboard.shared().mypageStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: SubCelebrityVC.reuseIdentifier) as! SubCelebrityVC
        return viewController
    }()
    
    private lazy var broadcastVC: SubBroadCastVC = {
        let storyboard = Storyboard.shared().mypageStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: SubBroadCastVC.reuseIdentifier) as! SubBroadCastVC
        return viewController
    }()
    
    
    @IBAction func switchView(_ sender: CategoryToggleBtn) {
        updateView(selected: sender.tag)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        celebrityBtn.setBtn(another: broadcastBtn, bottomLine: celebrityGreenView)
        broadcastBtn.setBtn(another: celebrityBtn, bottomLine: broadcastGreenView)
        updateView(selected: 0)
        setBackBtn()
        
    }
    

}


//컨테이너뷰
extension SubscribeVC{
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

