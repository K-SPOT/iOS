//
//  ChannelDetailService.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct ChannelDetailService: GettableService {
    
    typealias NetworkData = ChannelDetailVO
    static let shareInstance = ChannelDetailService()
    func getChannelDetail(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.POST_SUCCESS.rawValue : completion(.networkSuccess(networkResult.resResult.data))
                case HttpResponseCode.SELECT_ERROR.rawValue :
                    completion(.selectErr)
                case HttpResponseCode.SERVER_ERROR.rawValue :
                    completion(.serverErr)
                default :
                    print("no 200/300/500 rescode is \(networkResult.resCode)")
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
