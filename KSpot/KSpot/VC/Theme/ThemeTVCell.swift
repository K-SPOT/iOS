//
//  ThemeTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class ThemeTVCell: UITableViewCell {

    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var firstDesLbl: UILabel!
    @IBOutlet weak var secondDesLbl: UILabel!
    @IBOutlet weak var thirdDesLbl: UILabel!
    @IBOutlet weak var placeDetailBtn : UIButton!
    var delegate : SelectDelegate?
    
    func configure(data : ThemeVODataThemeContent, row : Int){
        countLbl.text = (row+1).description
        titleLbl.text = data.title
        placeDetailBtn.tag = data.spotID
        setImgWithKF(url: data.img, imgView: myImgView, defaultImg: #imageLiteral(resourceName: "aimg"))
        let desCount = data.description.count
        if desCount >= 1 {
            firstDesLbl.text = data.description[0]
        }
        if desCount >= 2 {
            secondDesLbl.text = data.description[1]
        }
        if desCount >= 3 {
            thirdDesLbl.text = data.description[2]
        }
        if selectedLang == .kor {
            placeDetailBtn.setImage(#imageLiteral(resourceName: "theme_place_more_button"), for: .normal)
        } else {
            placeDetailBtn.setImage(#imageLiteral(resourceName: "theme_place_more_button_eng"), for: .normal)
        }
    }
    
    @objc func placeDetailAction(_ sender : UIButton){
        delegate?.tap(selected: sender.tag)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        placeDetailBtn.addTarget(self, action: #selector(placeDetailAction(_:)), for: .touchUpInside)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
