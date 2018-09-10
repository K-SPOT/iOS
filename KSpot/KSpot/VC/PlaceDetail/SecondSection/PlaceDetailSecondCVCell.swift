//
//  PlaceDetailSecondCVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 5..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class PlaceDetailSecondCVCell: UICollectionViewCell {
    @IBOutlet weak var reviewImgView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var contentLabel : UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
   
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: 17)
        ratingView.settings.fillMode = .half
        ratingView.rating = 2.5
    }
}
