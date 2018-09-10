//
//  ReviewContainerVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class ReviewContainerVC: UIViewController, UIGestureRecognizerDelegate {

    @IBAction func writeReviewAction(_ sender: Any) {
        let mapStoryboard = Storyboard.shared().mapStoryboard
        if let reviewWriteVC = mapStoryboard.instantiateViewController(withIdentifier:ReviewWriteVC.reuseIdentifier) as? ReviewWriteVC {
            
            self.navigationController?.pushViewController(reviewWriteVC, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackBtn()
        // Do any additional setup after loading the view.
    }

  
}
