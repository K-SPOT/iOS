//
//  MainSearchVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 20..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct MainSearchVO: Codable {
    let message: String
    let data: MainSearchVOData
}

struct MainSearchVOData: Codable {
    let celebrity, broadcast, event: [MainSearchVODataCelebrity]
}

struct MainSearchVODataCelebrity: Codable {
    let name: String
}
