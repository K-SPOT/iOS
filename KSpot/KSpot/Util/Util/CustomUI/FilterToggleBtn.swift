//
//  FilterToggleBtn.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 3..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class FilterToggleBtn : UIButton {
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBtnClickEvent()
        setDefaultBtn()
    }
    
    var anotherBtn : FilterToggleBtn?
    var theOtherBtn : FilterToggleBtn?
    
    func setBtnClickEvent() {
        self.addTarget(self, action: #selector(FilterToggleBtn.touchBtn(_:)), for: UIControlEvents.touchUpInside)
    }

    @objc func touchBtn(_ sender: FilterToggleBtn){
        sender.selected()
        sender.anotherBtn?.unSelected()
        sender.theOtherBtn?.unSelected()
    }

    func setDefaultBtn(){
        self.isSelected = false
    }
}

extension FilterToggleBtn{
    func selected(){
     self.setTitleColor(ColorChip.shared().mainColor, for: .normal)
       
//        self.isSelected = true
    }
    func unSelected(){
        
        self.setTitleColor(#colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1), for: .normal)
        self.isSelected = false
    }
    
    func setOtherBtn(another : FilterToggleBtn, theOther : FilterToggleBtn){
        self.anotherBtn = another
        self.theOtherBtn = theOther
    }
}