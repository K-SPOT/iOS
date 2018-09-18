//
//  BroadcastTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class BroadcastTVCell: UITableViewCell {

    @IBOutlet weak var mainImgView : UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var subscribeBtn : mySubscribeBtn!
    
    func configure(data : ChannelVODataChannelList){
        self.setImgWithKF(url: data.thumbnailImg, imgView: mainImgView, defaultImg: #imageLiteral(resourceName: "aimg"))
        titleLbl.text = data.name
        subtitleLbl.text = "\(data.subscriptionCnt.description) · \(data.spotCnt.description)"
        self.setSubscribeBtn(subscribeBtn: subscribeBtn, idx: data.channelID, isSubscribe: data.subscription)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
