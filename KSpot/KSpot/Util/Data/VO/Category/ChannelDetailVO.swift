//
//  ChannelDetailVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct ChannelDetailVO: Codable {
    let message: String
    let data: ChannelDetailVOData
}

struct ChannelDetailVOData: Codable {
    let channelInfo: [ChannelDetailVODataChannelInfo]
    let placeRecommendedByChannel: [ChannelDetailVODataPlaceRecommendedByChannel]
    let placeRelatedChannel, eventRelatedChannel: [ChannelDetailVODataRelatedChannel]
    
    enum CodingKeys: String, CodingKey {
        case channelInfo = "channel_info"
        case placeRecommendedByChannel = "place_recommended_by_channel"
        case placeRelatedChannel = "place_related_channel"
        case eventRelatedChannel = "event_related_channel"
    }
}

struct ChannelDetailVODataChannelInfo: Codable {
    let id: Int
    let korName, engName, korCompany, backgroundImg: String
    let thumbnailImg: String
    let subscriptionCnt, subscription: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case korName = "kor_name"
        case engName = "eng_name"
        case korCompany = "kor_company"
        case backgroundImg = "background_img"
        case thumbnailImg = "thumbnail_img"
        case subscriptionCnt = "subscription_cnt"
        case subscription
    }
}

struct ChannelDetailVODataPlaceRecommendedByChannel: Codable {
    let spotID: Int
    let korName, engName, img: String
    
    enum CodingKeys: String, CodingKey {
        case spotID = "spot_id"
        case korName = "kor_name"
        case engName = "eng_name"
        case img
    }
}

struct ChannelDetailVODataRelatedChannel: Codable {
    let spotID: Int
    let name, description, addressGu, station: String
    let img: String
    let scrapCnt: Int
    
    enum CodingKeys: String, CodingKey {
        case spotID = "spot_id"
        case name, description
        case addressGu = "address_gu"
        case station, img
        case scrapCnt = "scrap_cnt"
    }
}


