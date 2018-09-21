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
    var selectedIdx : Int = 0
    var rating : Double = 0.0
    var reviewData : [PlaceDetailVODataReview]? {
        didSet {
            if let reviewData_ = reviewData{
                tableView.reloadData()
                reviewCountLbl.text = reviewData_.count.description+"개"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ratingView.rating = rating
        ratingLbl.text = rating.description
        getReviews(url: UrlPath.spot.getURL("\(selectedIdx)/review"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        if let reviewData_ = reviewData{
            return reviewData_.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewNoImgTVCell.reuseIdentifier) as! ReviewNoImgTVCell
        if let reviewData_ = reviewData {
            if reviewData_[indexPath.row].img == "" {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewNoImgTVCell.reuseIdentifier) as! ReviewNoImgTVCell
                cell.delegate = self
                cell.configure(data : reviewData_[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewImgTVCell.reuseIdentifier) as! ReviewImgTVCell
                cell.delegate = self
                cell.configure(data : reviewData_[indexPath.row])
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//통신
extension ReviewVC {
    func getReviews(url : String){
        ReviewService.shareInstance.getReviewData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let reviewData):
                self.reviewData = reviewData as? [PlaceDetailVODataReview]
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
