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
    @IBOutlet weak var stackView: UIStackView!
    
    func setStackViewStar(rating : Double){
        var temp = rating
        for i in 0..<stackView.arrangedSubviews.count{
            if (temp - 1 >= 0){
                (stackView.arrangedSubviews[i] as! UIImageView).image = #imageLiteral(resourceName: "review_star_full")
                temp -= 1
            } else if (temp - 0.5 >= 0){
                (stackView.arrangedSubviews[i] as! UIImageView).image = #imageLiteral(resourceName: "review_star_half")
                temp -= 0.5
            } else {
                (stackView.arrangedSubviews[i] as! UIImageView).image = #imageLiteral(resourceName: "review_star_empty")
            }
        }
    }
    
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: 17)
        self.setStackViewStar(rating: 2.3)
    }
}
