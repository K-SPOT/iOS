//
//  CategoryDetailFirstCVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CategoryDetailFirstCVCell: UICollectionViewCell {
    @IBOutlet weak var myImgView : UIImageView!
    @IBOutlet weak var placeLbl : UILabel!
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: 17)
    }
}

