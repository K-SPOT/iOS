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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let recentAction = UIAlertAction(title: "최신순", style: .default) { (_) in
            print("최신순 선택")
        }
        let popularAction = UIAlertAction(title: "인기순", style: .default) { (_) in
            print("인기순 선택")
        }
        let cancleAction = UIAlertAction(title: "취소",style: .cancel)
        alert.addAction(recentAction)
        alert.addAction(popularAction)
        alert.addAction(cancleAction)
        present(alert, animated: true)
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

extension ReviewVC : SelectDelegate {
    func tap(selected : Int?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "신고", style: .default) { (_) in
            print("신고 선택")
        }
      
        let cancleAction = UIAlertAction(title: "취소",style: .cancel)
        alert.addAction(reportAction)
        alert.addAction(cancleAction)
        present(alert, animated: true)
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
