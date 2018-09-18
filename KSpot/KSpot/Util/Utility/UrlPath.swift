//
//  UrlPath.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//
import Foundation

import Foundation

enum UrlPath : String {
    //로그인
    case FacebookLogin = "/user/facebook/signin"
    
    //마이페이지
    case Mypage = "/user/mypage"
    case UserSubscription = "/user/subscription"
    case UserScrap = "/user/scrap"
    case UserEdit = "/user/edit"
    

    
    //카테고리
    case ChannelList = "/channel/list" //get
    case ChannelSubscription = "/channel/subscription/"
    
    

    

    
    
    
    func getURL(_ parameter : String? = nil) -> String{
        return "http://13.209.35.110:3000\(self.rawValue)\(parameter ?? "")"
    }
}



