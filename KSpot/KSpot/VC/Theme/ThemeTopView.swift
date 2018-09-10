//
//  ThemeTopView.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 10..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit


class ThemeTopView : UIView {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
   
    
    class func instanceFromNib() -> ThemeTopView {
        return UINib(nibName: "ThemeTopView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ThemeTopView
    }
    
}

