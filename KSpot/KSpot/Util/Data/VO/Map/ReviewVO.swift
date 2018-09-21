//
//  ReviewVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 21..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct ReviewVO: Codable {
    let message: String
    let data: [PlaceDetailVODataReview]
}
