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
    
    func configure(data : ChannelDetailVODataRelatedChannel){
        
        setImgWithKF(url: data.img, imgView: myImgView, defaultImg: #imageLiteral(resourceName: "aimg"))
        titleLbl.text = data.name
        descLbl.text = data.description
        placeLbl.text = "\(data.addressGu) · \(data.station)"
        scrapCountLbl.text = data.scrapCnt.description
    }
    
    func configure2(data : SearchResultVODataPlace){
        
        setImgWithKF(url: data.img, imgView: myImgView, defaultImg: #imageLiteral(resourceName: "aimg"))
        titleLbl.text = data.name
        descLbl.text = data.description
        placeLbl.text = "\(data.addressGu) · \(data.station)"
        scrapCountLbl.text = data.scrapCnt.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myImgView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1))
        myImgView.makeRounded(cornerRadius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
