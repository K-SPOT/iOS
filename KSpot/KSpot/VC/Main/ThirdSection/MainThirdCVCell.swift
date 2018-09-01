//
//  MainThirdCVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//
import UIKit

class MainThirdCVCell: UICollectionViewCell {
    
    @IBOutlet weak var myImgView: UIImageView!

    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 17
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        self.contentView.layer.masksToBounds = true
    }
}

