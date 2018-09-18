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
    var delegate : SelectSenderDelegate?
    
    func configure(data : ChannelVODataChannelList){
        self.setImgWithKF(url: data.thumbnailImg, imgView: mainImgView, defaultImg: #imageLiteral(resourceName: "aimg"))
        titleLbl.text = data.name
         subtitleLbl.text = "구독자 \(data.subscriptionCnt.description) · 게시물 \(data.spotCnt.description)"

        subscribeBtn.setSubscribeBtn(idx: data.channelID, isSubscribe: data.subscription)
        subscribeBtn.addTarget(self, action: #selector(subscribeAction(_:)), for: .touchUpInside)
    }
    
    @objc func subscribeAction(_ sender : mySubscribeBtn){
        delegate?.tap(section: .second, seledtedId: sender.contentIdx!, sender: sender)
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
