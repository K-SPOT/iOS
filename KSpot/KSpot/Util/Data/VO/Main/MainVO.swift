//
//  MainVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 20..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct MainVO: Codable {
    let message: String
    let data: MainVOData
}

struct MainVOData: Codable {
    let theme: [MainVODataTheme]
    let mainRecommandSpot, mainBestPlace, mainBestEvent: [MainVODataMain]
    
    enum CodingKeys: String, CodingKey {
        case theme
        case mainRecommandSpot = "main_recommand_spot"
        case mainBestPlace = "main_best_place"
        case mainBestEvent = "main_best_event"
    }
}


struct MainVODataTheme: Codable {
    let themeID: Int
    let title, subtitle: String
    let img: String
    
    enum CodingKeys: String, CodingKey {
        case themeID = "theme_id"
        case title, subtitle, img
    }
}

struct MainVODataMain: Codable {
    let spotID: Int
    let name, description: String
    let img: String
    
    enum CodingKeys: String, CodingKey {
        case spotID = "spot_id"
        case name, description, img
    }
}

