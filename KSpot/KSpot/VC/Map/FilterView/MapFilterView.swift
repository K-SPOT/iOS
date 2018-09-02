//
//  MapFilterView.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MapFilterView: UIView {
    
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var popularBtn: FilterToggleBtn!
    @IBOutlet weak var recentBtn: FilterToggleBtn!
    @IBOutlet weak var reviewBtn: FilterToggleBtn!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var restaurantBtn: UIButton!
    @IBOutlet weak var cafeBtn: UIButton!
    @IBOutlet weak var hotplaceBtn: UIButton!
    @IBOutlet weak var eventBtn: UIButton!
    @IBOutlet weak var etcBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    class func instanceFromNib() -> MapFilterView {
    let view = UINib(nibName: "MapFilterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapFilterView
        return view
    }

}
