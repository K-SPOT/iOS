//
//  SelectRegionDelegate.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
import UIKit

protocol SelectRegionDelegate {
    func tap(_ tag : Region)
}

protocol SelectDelegate {
    func tap(selected : Int?)
}

protocol SelectSectionDelegate {
    func tap(section : Section, seledtedId : Int)
}


protocol SelectSenderDelegate {
    func tap(section : Section, seledtedId : Int, sender : mySubscribeBtn)
}

extension SelectSenderDelegate where Self : UIViewController {
    func tap(section : Section, seledtedId : Int, sender : mySubscribeBtn){
        let params = ["channel_id" : seledtedId]
        if sender.isSelected {
            unsubscribe(url: UrlPath.channelSubscription.getURL(sender.contentIdx?.description), sender: sender)
        } else {
            subscribe(url: UrlPath.channelSubscription.getURL(), params: params, sender: sender)
        }
    }
    
    func subscribe(url : String, params : [String:Any], sender : mySubscribeBtn){
        ChannelSubscribeService.shareInstance.subscribe(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                sender.isSelected = true
                
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    } //subscribe
    
    func unsubscribe(url : String, sender : mySubscribeBtn){
        ChannelSubscribeService.shareInstance.unsubscribe(url: url, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                sender.isSelected = false
                
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}



enum Section {
    case first
    case second
    case third
}
