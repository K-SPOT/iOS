//
//  UserScrapVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct UserScrapVO: Codable {
    let message: String
    let data: [UserScrapVOData]
}

struct UserScrapVOData: Codable {
    let spotID: Int
    let reviewScore: Double
    let name, description, addressGu, station: String
    let img: String
    let channel: UserScrapVODataChannel
    
    enum CodingKeys: String, CodingKey {
        case spotID = "spot_id"
        case reviewScore = "review_score"
        case name, description
        case addressGu = "address_gu"
        case station, img, channel
    }
}

struct UserScrapVODataChannel: Codable {
    let channelID, thubnailImg: [String]
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case thubnailImg = "thubnail_img"
    }
}
