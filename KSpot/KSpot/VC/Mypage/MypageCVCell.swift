//
//  MypageCVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 9..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MypageCVCell: UICollectionViewCell {
    @IBOutlet weak var myImgView: UIImageView!
     @IBOutlet weak var engNameLbl: UILabel!
     @IBOutlet weak var koreanNameLbl: UILabel!
    override func awakeFromNib() {
        self.makeRounded(cornerRadius: 17)
    }
}
