//
//  CategoryDetailMorePlaceVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CategoryDetailMorePlaceVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var channelMoreData : [UserScrapVOData]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var isPlace = true
    var selectedIdx = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        collectionView.delegate = self
        collectionView.dataSource = self
        let isEvent = isPlace ? 0 : 1
        getChannelSpotMore(url: UrlPath.channelSpotMore.getSpotMoreURL(channelId: selectedIdx, isEvent: isEvent))
        
    }
    
}

extension CategoryDetailMorePlaceVC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let channelMoreData_ = channelMoreData{
            return channelMoreData_.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MapContainerCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceMoreCVCell", for: indexPath) as? MapContainerCVCell
        {
            if let channelMoreData_ = channelMoreData{
               cell.configure(data: channelMoreData_[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let channelMoreData_ = channelMoreData{
            if self.title == "이벤트" {
                self.goToPlaceDetailVC(selectedIdx: channelMoreData_[indexPath.row].spotID, isPlace: false)
            } else {
              self.goToPlaceDetailVC(selectedIdx: channelMoreData_[indexPath.row].spotID)
            }
        }
    }
}

extension CategoryDetailMorePlaceVC: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (343/375)*view.frame.width, height: (371/375)*view.frame.width)
        //return CGSize(width: 375, height: 375)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 16, 0)
    }
}

//통신
extension CategoryDetailMorePlaceVC {
    func getChannelSpotMore(url : String){
        UserScrapService.shareInstance.getScrapList(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let channelMoreData):
                self.channelMoreData = channelMoreData as? [UserScrapVOData]
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}

