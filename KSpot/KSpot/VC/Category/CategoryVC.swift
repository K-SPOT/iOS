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

    override func viewDidLoad() {
        super.viewDidLoad()
        celebrityBtn.setBtn(another: broadcastBtn, bottomLine: celebrityGreenView)
        broadcastBtn.setBtn(another: celebrityBtn, bottomLine: broadcastGreenView)
        updateView(selected: 0)
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
