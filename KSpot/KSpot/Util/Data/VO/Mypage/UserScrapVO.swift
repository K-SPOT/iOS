//
//  UserScrapVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

/*struct UserScrapVO: Codable {
    let message: String
    let data: [UserScrapVOData]
}

struct UserScrapVOData: Codable {
    let spotID: Int
    let reviewScore: Int
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
}*/


struct UserScrapVO: Codable {
    let data: [UserScrapVOData]
    let message: String
}

struct UserScrapVOData: Codable {
    let img: String
    let name, addressGu: String
    let spotID: Int
    let description: String
    let channel: UserScrapVODataChannel
    let station: String
    let reviewScore: Double
    
    enum CodingKeys: String, CodingKey {
        case img, name
        case addressGu = "address_gu"
        case spotID = "spot_id"
        case description, channel, station
        case reviewScore = "review_score"
    }
}

struct UserScrapVODataChannel: Codable {
    let channelID: [String]
    let thumbnailImg: [String]
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case thumbnailImg = "thumbnail_img"
    }
}

