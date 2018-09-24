//
//  SearchResultVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController, UIGestureRecognizerDelegate {

    var isChange : Bool? {
        didSet {
            tableView.reloadData()
        }
    }
    var searchResultData : SearchResultVOData?
    var searchTxt = ""
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        setBackBtn()
        getSearchData(url: UrlPath.searchResult.getURL(searchTxt))
    }


}

extension SearchResultVC : UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResultData_ = searchResultData {
            if section == 0 {
                return searchResultData_.channel.count <= 3 ? searchResultData_.channel.count : 3
            } else if section == 1{
                return searchResultData_.place.count <= 4 ? searchResultData_.place.count :  4
            } else {
                return searchResultData_.event.count <= 4 ? searchResultData_.event.count :  4
            }
        }
        return 0
    }
    
    
    //headerSection View 만드는 것
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: CategoryDetailSecondTVHeaderCell.reuseIdentifier) as! CategoryDetailSecondTVHeaderCell

        guard let searchResultData_ = searchResultData else {return nil}
        if section == 0  {
            if( searchResultData_.channel.count != 0) {
                header.titleLbl.text = "연예인 / 방송"
                header.morBtn.addTarget(self, action: #selector(goToCelebrityMore(_:)), for: .touchUpInside)
                return header
            } else {
                return nil
            }
        } else if section == 1 {
            if( searchResultData_.place.count != 0) {
                header.titleLbl.text = "장소"
                header.morBtn.addTarget(self, action: #selector(goToPlaceMore(_:)), for: .touchUpInside)
                return header
            } else {
                return nil
            }
        } else {
            if( searchResultData_.event.count != 0) {
                header.titleLbl.text = "이벤트"
                header.morBtn.addTarget(self, action: #selector(goToEventMore(_:)), for: .touchUpInside)
                return header
            } else {
                return nil
            }
        }
    }
    
    @objc func goToCelebrityMore(_ sender : UIButton) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultMoreCelebrityVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultMoreCelebrityVC.reuseIdentifier) as? SearchResultMoreCelebrityVC {
            searchResultMoreCelebrityVC.headerTitle = "연예인 / 방송"
            guard let navTitle = self.navigationItem.title else{return}
            if ((navTitle.count) < 10) {
                searchResultMoreCelebrityVC.navigationItem.title = "'\(navTitle)' 검색결과"
            } else {
                searchResultMoreCelebrityVC.navigationItem.title = "'\(navTitle.prefix(9))...' 검색결과"
            }
            searchResultMoreCelebrityVC.searchData = searchResultData?.channel
            self.navigationController?.pushViewController(searchResultMoreCelebrityVC, animated: true)
        }
    }
    
    @objc func goToPlaceMore(_ sender : UIButton){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultMoreVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultMoreVC.reuseIdentifier) as? SearchResultMoreVC {
           
            guard let navTitle = self.navigationItem.title else{return}
            if ((navTitle.count) < 10) {
                searchResultMoreVC.navigationItem.title = "'\(navTitle)' 검색결과"
            } else {
                searchResultMoreVC.navigationItem.title = "'\(navTitle.prefix(9))...' 검색결과"
            }
            searchResultMoreVC.searchData = searchResultData?.place
            self.navigationController?.pushViewController(searchResultMoreVC, animated: true)
        }
    }
    @objc func goToEventMore(_ sender : UIButton){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultMorePlaceVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultMorePlaceVC.reuseIdentifier) as? SearchResultMorePlaceVC {
        
            searchResultMorePlaceVC.headerTitle = "이벤트"
            guard let navTitle = self.navigationItem.title else{return}
            if ((navTitle.count) < 10) {
                searchResultMorePlaceVC.navigationItem.title = "'\(navTitle)' 검색결과"
            } else {
                searchResultMorePlaceVC.navigationItem.title = "'\(navTitle.prefix(9))...' 검색결과"
            }
           searchResultMorePlaceVC.searchData = searchResultData?.event
            self.navigationController?.pushViewController(searchResultMorePlaceVC, animated: true)
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         guard let searchResultData_ = searchResultData else {return 0}
        if section == 0  {
            return heightForHeaderInSection(arr: searchResultData_.channel)
        } else if section == 1 {
           return heightForHeaderInSection(arr: searchResultData_.place)
        } else {
            return heightForHeaderInSection(arr: searchResultData_.event)
        }
    }
    
    private func heightForHeaderInSection(arr : [Any]) -> CGFloat {
        if (arr.count > 0){
            return 62
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BroadcastTVCell.reuseIdentifier) as! BroadcastTVCell
            if let channelData = searchResultData?.channel {
                cell.delegate = self
                cell.configure(data: channelData[indexPath.row], index : indexPath.row)
            }
            return cell
            
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTVCell.reuseIdentifier) as! SearchResultTVCell
            if indexPath.section == 1 {
                if let placeData = searchResultData?.place {
                    cell.configure(data: placeData[indexPath.row])
                }
            } else {
                if let eventData = searchResultData?.event {
                    cell.configure(data: eventData[indexPath.row])
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            if let channelData = searchResultData?.channel {
                self.goToCelebrityDetail(selectedIdx : channelData[indexPath.row].channelID)
            }
            
        } else if section == 1 {
            if let placeData = searchResultData?.place {
                self.goToPlaceDetailVC(selectedIdx : placeData[indexPath.row].spotID)
            }
        } else {
            if let eventData = searchResultData?.event {
                self.goToPlaceDetailVC(selectedIdx : eventData[indexPath.row].spotID, isPlace : false)
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension SearchResultVC : SelectSenderDelegate{
    func tap(section: Section, seledtedId: Int, sender: mySubscribeBtn) {
        if sender.isSelected {
            unsubscribe(url: UrlPath.channelSubscription.getURL(sender.contentIdx?.description), sender: sender)
        } else {
             let params = ["channel_id" : seledtedId]
            subscribe(url: UrlPath.channelSubscription.getURL(), params: params, sender: sender)
        }
    }
}

//통신
extension SearchResultVC {
    func getSearchData(url : String){
        SearchResultService.shareInstance.getSearchResult(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let searchResultData):
                self.searchResultData = searchResultData as? SearchResultVOData
                self.isChange = true
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func subscribe(url : String, params : [String:Any], sender : mySubscribeBtn){
        ChannelSubscribeService.shareInstance.subscribe(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                sender.isSelected = true
                self.searchResultData?.channel[sender.indexPath!].subscription = 1
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    } //subscribe
    
    func unsubscribe(url : String, sender : mySubscribeBtn){
        ChannelSubscribeService.shareInstance.unsubscribe(url: url, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                
                sender.isSelected = false
                self.searchResultData?.channel[sender.indexPath!].subscription = 0
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
