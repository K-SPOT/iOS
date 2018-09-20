//
//  SearchResultTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 21..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultTVCell: UITableViewCell {
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var spotLbl: UILabel!
    
    func configure(data : SearchResultVODataPlace){
        titleLbl.text = data.name
        spotLbl.text = "\(data.addressGu) · \(data.station)"
        switch data.type {
        //0 맛집 1 카페 2 명소 3 생일 4 기념 5 이벤트 기타 6 장소 기타
        case 0 :
            myImgView.image = #imageLiteral(resourceName: "search_result_place_icon")
        case 1 :
            myImgView.image = #imageLiteral(resourceName: "aimg")
        case 2 :
            myImgView.image = #imageLiteral(resourceName: "search_result_place_icon")
        case 3 :
            myImgView.image = #imageLiteral(resourceName: "bimg")
        case 4 :
            myImgView.image = #imageLiteral(resourceName: "search_result_event_birthday")
        case 5 :
            myImgView.image = #imageLiteral(resourceName: "cimg")
        case 6 :
            myImgView.image = #imageLiteral(resourceName: "search_result_event_birthday")
        default :
            break
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
