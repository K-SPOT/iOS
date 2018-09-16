//
//  ReviewNoImgTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class ReviewNoImgTVCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var writingInfoLbl: UILabel!
    var delegate : SelectDelegate?
    
    @IBAction func moreAction(_ sender: Any) {
        delegate?.tap(selected: 0)
    }
    //@IBOutlet weak var moreBtn: UIButton!
    
    //delegate?.tap()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLbl.setLineSpacing(lineSpacing: 6)
        ratingView.settings.fillMode = .half
        ratingView.rating = 3.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
