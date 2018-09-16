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
        let alert = UIAlertController(title: nil, message: "신고 사유를 선택해주세요", preferredStyle: .actionSheet)
        
        let report1 = UIAlertAction(title: "음란물", style: .default) { (_) in
            reportAction()
        }
        let report2 = UIAlertAction(title: "사칭 및 사기", style: .default) { (_) in
            reportAction()
        }
        let report3 = UIAlertAction(title: "허위사실 유포", style: .default) { (_) in
           reportAction()
        }
        let report4 = UIAlertAction(title: "상업적 광고 및 판매", style: .default) { (_) in
           reportAction()
        }
        let report5 = UIAlertAction(title: "욕설 및 불쾌감을 주는 표현", style: .default) { (_) in
            reportAction()
        }
        
        func reportAction(){
            self.simpleAlert(title: "신고접수", message: "신고가 완료되었습니다")
        }
      
        let cancleAction = UIAlertAction(title: "취소",style: .cancel)
        alert.addAction(report1)
        alert.addAction(report2)
        alert.addAction(report3)
        alert.addAction(report4)
        alert.addAction(report5)
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
