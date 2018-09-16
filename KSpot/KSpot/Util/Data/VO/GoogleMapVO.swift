//
//  GoogleMapVO.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct GoogleMapVO : Codable {
    let results: [Result]
    let status: String
    let plusCode: PlusCode
    
    enum CodingKeys: String, CodingKey {
        case results, status
        case plusCode = "plus_code"
    }
}

struct PlusCode: Codable {
    let globalCode, compoundCode: String
    
    enum CodingKeys: String, CodingKey {
        case globalCode = "global_code"
        case compoundCode = "compound_code"
    }
}

struct Result: Codable {
    let geometry: Geometry
    let formattedAddress: String
    let plusCode: PlusCode?
    let types: [String]
    let addressComponents: [AddressComponent]
    let placeID: String
    
    enum CodingKeys: String, CodingKey {
        case geometry
        case formattedAddress = "formatted_address"
        case plusCode = "plus_code"
        case types
        case addressComponents = "address_components"
        case placeID = "place_id"
    }
}

struct AddressComponent: Codable {
    let types: [String]
    let shortName, longName: String
    
    enum CodingKeys: String, CodingKey {
        case types
        case shortName = "short_name"
        case longName = "long_name"
    }
}

struct Geometry: Codable {
    let locationType: String
    let viewport: Bounds
    let location: Location
    let bounds: Bounds?
    
    enum CodingKeys: String, CodingKey {
        case locationType = "location_type"
        case viewport, location, bounds
    }
}

struct Bounds: Codable {
    let northeast, southwest: Location
}

struct Location: Codable {
    let lat, lng: Double
}
