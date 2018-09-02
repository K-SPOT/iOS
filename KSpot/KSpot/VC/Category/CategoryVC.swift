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
    
   
    @IBAction func switchView(_ sender: UIButton) {
        updateView(selected: sender.tag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(selected: 0)
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
