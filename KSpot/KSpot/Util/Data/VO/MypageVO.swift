//
//  MypageVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct MypageVO: Codable {
    let message: String
    let data: MypageVOData
}

struct MypageVOData: Codable {
    let user: MypageVODataUser
    let channel: [MypageVODataChannel]
}

struct MypageVODataChannel: Codable {
    let name, engName, backgroundImg: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case engName = "eng_name"
        case backgroundImg = "background_img"
    }
}

struct MypageVODataUser: Codable {
    let name: String
    let profileImg: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImg = "profile_img"
    }
}
