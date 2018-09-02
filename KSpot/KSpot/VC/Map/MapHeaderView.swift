//
//  MapHeaderView.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MapHeaderView: UICollectionReusableView {
    
    var delegate : selectRegionDelegate?
    @IBOutlet weak var selectedRegionLbl: UILabel!
    @IBOutlet weak var dobongBtn: RegionBtn!

}
protocol selectRegionDelegate {
    func tap(_ tag : Region)
}
