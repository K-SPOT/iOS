//
//  PlaceDetailVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 21..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct PlaceDetailVO: Codable {
    let message: String
    let data: [PlaceDetailVOData]
}

struct PlaceDetailVOData: Codable {
    let spotID: Int
    let img: [String]
    let name, description, address: String
    let reviewScore : Double
    let reviewCnt: Int
    let station, prevStation, nextStation, openTime: String
    let closeTime, contact: String
    let scrapCnt, isScrap: Int
    let channel: PlaceDetailVODataChannel
    let reviews: [PlaceDetailVODataReview]
  
    enum CodingKeys: String, CodingKey {
        case spotID = "spot_id"
        case img, name, description, address
        case reviewScore = "review_score"
        case reviewCnt = "review_cnt"
        case station
        case prevStation = "prev_station"
        case nextStation = "next_station"
        case openTime = "open_time"
        case closeTime = "close_time"
        case contact
        case scrapCnt = "scrap_cnt"
        case isScrap = "is_scrap"
        case channel, reviews
    }
}

struct PlaceDetailVODataChannel: Codable {
    let channelID, channelName: [String]
    let thumbnailImg: [String]
    let isSubscription: [String]
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName = "channel_name"
        case thumbnailImg = "thumbnail_img"
        case isSubscription = "is_subscription"
    }
}

struct PlaceDetailVODataReview: Codable {
    let title, content: String
    let img: String
    let reviewScore: Double
    let regTime: String
    
    enum CodingKeys: String, CodingKey {
        case title, content, img
        case reviewScore = "review_score"
        case regTime = "reg_time"
    }
}
