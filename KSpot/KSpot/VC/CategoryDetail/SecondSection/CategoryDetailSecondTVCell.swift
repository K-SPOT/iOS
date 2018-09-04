//
//  CategoryDetailSecondTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CategoryDetailSecondTVCell: UITableViewCell {

    @IBOutlet weak var myImgView : UIImageView!
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var placeLbl : UILabel!
    @IBOutlet weak var scrapCountLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myImgView.layer.cornerRadius = 17
        self.myImgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}