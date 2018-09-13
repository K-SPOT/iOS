//
//  NetworkConfiguration.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
class NetworkConfiguration {
    
    let googleMapAPIKey = "AIzaSyAjENH3Hb6jDbi_X6Qca7NhlUNsOKz12gg"
    let baseURL = "http://52.78.205.45:3000"
    
    struct StaticInstance {
        static var instance: NetworkConfiguration?
    }
    
    class func shared() -> NetworkConfiguration {
        if StaticInstance.instance == nil {
            StaticInstance.instance = NetworkConfiguration()
        }
        return StaticInstance.instance!
    }
}



enum NetResult<T> {
    case success(T)
    case error(String)
    case failure(Error)
}

enum NetworkResult<T> {
    case networkSuccess(T)
    case nullValue
    case duplicated
    case serverErr
    case networkFail
    case wrongInput
    case accessDenied
    case noCoin
    case noPoint
    case failInsert
}
