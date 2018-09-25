//
//  ReviewContainerVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

class ReviewContainerVC: UIViewController, UIGestureRecognizerDelegate {

    var selectedIdx = 0
    var rating = 0.0
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    private lazy var reviewVC: ReviewVC = {
        let storyboard = Storyboard.shared().mapStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: ReviewVC.reuseIdentifier) as! ReviewVC
        viewController.rating = rating
        viewController.selectedIdx = selectedIdx
        return viewController
    }()
    
    @IBAction func writeReviewAction(_ sender: Any) {
        if !isUserLogin() {
            goToLoginPage()
        } else {
            //리뷰 쓰기
            let mapStoryboard = Storyboard.shared().mapStoryboard
            if let reviewWriteVC = mapStoryboard.instantiateViewController(withIdentifier:ReviewWriteVC.reuseIdentifier) as? ReviewWriteVC {
                reviewWriteVC.selectedIdx = self.selectedIdx
                self.navigationController?.pushViewController(reviewWriteVC, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedLang == .eng {
              writeReviewBtn.setImage(#imageLiteral(resourceName: "board_star_green"), for: .normal)
        }
        setBackBtn()
        initContainerView()
    }
    
    func initContainerView(){
        addChildView(containerView: containerView, asChildViewController: reviewVC)
    }

  
}
