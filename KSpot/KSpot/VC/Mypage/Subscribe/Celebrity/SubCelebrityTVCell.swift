//
//  SubCelebrityTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 10..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SubCelebrityTVCell: UITableViewCell {

    @IBOutlet weak var greenView: CustomView!
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    func configure(data : UserSubcriptionVOBroadcast) {
        setImgWithKF(url: data.thumbnailImg, imgView: profileView, defaultImg: #imageLiteral(resourceName: "aimg"))
        nameLbl.text = data.korName
        greenView.isHidden = (data.newPostCheck == 0)
    }
    override func awakeFromNib() {
        profileView.makeRounded(cornerRadius: profileView.frame.height/2)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
