//
//  ReviewVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import MessageUI
//import FBSDKLoginKit


class ReviewVC: UIViewController {
 @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var reviewCountLbl: UILabel!
    
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectedIdx : Int = 0
    var rating : Double = 0.0
    var reviewData : ReviewVOData? {
        didSet {
            if let reviewData_ = reviewData{
                tableView.reloadData()
                reviewCountLbl.text = reviewData_.spotReview.reviewCnt.description+"개"
                ratingLbl.text = reviewData_.spotReview.reviewScore.description
                ratingView.rating = reviewData_.spotReview.reviewScore
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        
        if !isUserLogin() {
            goToLoginPage()
        } else {
            //신고하기
            let alert = UIAlertController(title: nil, message: "신고 사유를 선택해주세요", preferredStyle: .actionSheet)
            
            let report1 = UIAlertAction(title: "음란물", style: .default) { (re1) in
                reportAction(reportReason: re1.title!)
            }
            let report2 = UIAlertAction(title: "사칭 및 사기", style: .default) { (re2) in
                reportAction(reportReason: re2.title!)
            }
            let report3 = UIAlertAction(title: "허위사실 유포", style: .default) { (re3) in
                reportAction(reportReason: re3.title!)
            }
            let report4 = UIAlertAction(title: "상업적 광고 및 판매", style: .default) { (re4) in
                reportAction(reportReason: re4.title!)
            }
            let report5 = UIAlertAction(title: "욕설 및 불쾌감을 주는 표현", style: .default) { (re5) in
                reportAction(reportReason: re5.title!)
            }
            
            func reportAction(reportReason : String){
                guard let selectedMailId = selected else {return}
                sendMail(selectedId: selectedMailId, reason : reportReason)
            }
            
            let cancleAction = UIAlertAction(title: "취소",style: .cancel)
            alert.addAction(report1)
            alert.addAction(report2)
            alert.addAction(report3)
            alert.addAction(report4)
            alert.addAction(report5)
            alert.addAction(cancleAction)
            present(alert, animated: true)
        } // else - 신고
    } //tap
}

extension ReviewVC : MFMailComposeViewControllerDelegate{
    func sendMail(selectedId : Int, reason : String){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["rkdthd1234@naver.com"])
            mail.setSubject("신고 등록")
            mail.setMessageBody("<p>'ID Number. \(selectedId)' 신고 등록</p><p>신고 사유는 \(reason)입니다.</p>", isHTML: true)
            self.present(mail, animated: true)
        } else {
            self.simpleAlert(title: "실패", message: "신고 메일을 보낼 수 없습니다. 다시 시도해주세요")
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
    
}

//tableView dataSource, delegate
extension ReviewVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let reviewData_ = reviewData{
            return reviewData_.reviews.count
        }
        return 0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewNoImgTVCell.reuseIdentifier) as! ReviewNoImgTVCell
        if let reviewData_ = reviewData {
            if reviewData_.reviews[indexPath.row].img == "" {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewNoImgTVCell.reuseIdentifier) as! ReviewNoImgTVCell
                cell.delegate = self
                cell.configure(data : reviewData_.reviews[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewImgTVCell.reuseIdentifier) as! ReviewImgTVCell
                cell.delegate = self
                cell.configure(data : reviewData_.reviews[indexPath.row])
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
                self.reviewData = reviewData as? ReviewVOData
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
