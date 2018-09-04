//
//  PlaceDetailFirstCVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 5..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class PlaceDetailFirstCVCell: UICollectionViewCell {
    @IBOutlet weak var logoImgView : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var subscribeBtn: UIButton!
    
    override func awakeFromNib() {
        logoImgView.makeRounded(cornerRadius: nil)
        logoImgView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1))
        self.makeCornerRound(cornerRadius: 6)
    }
}

