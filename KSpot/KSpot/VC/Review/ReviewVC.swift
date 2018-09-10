//
//  ReviewVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {
 @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var reviewCountLbl: UILabel!
    
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sortingAction(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ratingView.rating = 2.3
        ratingView.settings.fillMode = .precise
    }
    
    func update(_ rating: Double) {
        ratingView.rating = rating
    }
}


//tableView dataSource, delegate
extension ReviewVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewImgTVCell.reuseIdentifier) as! ReviewImgTVCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
