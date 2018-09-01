//
//  Extensions.swift
//  KSpot
//
//  Created by 강수진 on 2018. 8. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
extension NSObject {
    static var reuseIdentifier:String {
        return String(describing:self)
    }
}
