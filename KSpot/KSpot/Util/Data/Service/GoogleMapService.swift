//
//  GoogleMapService.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON


struct GoogleMapService : GettableService {
    
    typealias NetworkData = GoogleMapVO
    static let shareInstance = GoogleMapService()
    func getAddress(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case 200 : completion(.networkSuccess(networkResult.resResult.results))
                case 401 :
                    completion(.accessDenied)
                case 500 :
                    completion(.serverErr)
                default :
                    print("no 200/401/500")
                    break
                }
                break
            case .error(let errMsg) :
                print(errMsg)
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
        
    }
}
