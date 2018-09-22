//
//  MapContainerVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
enum EntryPoint {
    case local
    case google
}
class MapContainerVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedFirstFilter : FilterToggleBtn?
    var selectedSecondFilter : Int?
    var selectedThirdFilter : Set<UIButton>?
    var selectedRegion : Region?
    var entryPoint : EntryPoint = .local {
        didSet {
            if entryPoint == .local {
                getDefualtMapData()
            }
        }
    }
    var mapView : MapHeaderView?
    var defaultSpot : [UserScrapVOData]? {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func getDefualtMapData(){
        var isFood = 1
        var isCafe = 1
        var isSights = 1
        var isEvent = 1
        var isEtc = 1
        if let selectedThirdFilter_ = selectedThirdFilter {
            
                let buttonTagArr = selectedThirdFilter_.map({ (button) in
                    return button.tag
                })
                isFood =  buttonTagArr.contains(0) ? 1: 0
                isCafe = buttonTagArr.contains(1) ? 1 : 0
                isSights = buttonTagArr.contains(2) ? 1 : 0
                isEvent = buttonTagArr.contains(3) ? 1 : 0
                isEtc = buttonTagArr.contains(4) ? 1 : 0
                
            
        }
        
        let parentVC = self.parent as? MapVC
            var regionTxt = ""
            if let selectedRegion_ = selectedRegion{
                if selectedLang == .kor {
                    regionTxt = selectedRegion_.rawValue
                } else {
                    regionTxt = "\(selectedRegion_)"
                }
            }
            mapView?.selectedRegionLbl.text = regionTxt
            parentVC?.isGoogleMapLocation = false
            
            let addressGu = regionTxt
            let order = selectedFirstFilter?.tag ?? 0
            getDefaultSpot(url: UrlPath.spot.getURL("\(addressGu)/\(order)/\(isFood)/\(isCafe)/\(isSights)/\(isEvent)/\(isEtc)/"))
        
    } 
    
}

extension MapContainerVC : SelectRegionDelegate {
    func tap(_ region : Region) {
        selectedRegion = region
        let parentVC = self.parent as? MapVC
        parentVC?.entryPoint = .local
        entryPoint = .local
        getDefualtMapData()
    }
    
    
}

extension MapContainerVC : UICollectionViewDataSource, UICollectionViewDelegate{
    private typealias buttonRegion = (RegionBtn, Region)
    private func setDelegate(buttons : [RegionBtn]){
        buttons.forEach { (button) in
            button.delegate = self
        }
    }
    
    private func setRegion(inputs : [buttonRegion]){
        inputs.forEach { (input) in
            input.0.region = input.1
        }
    }
    
    //headerView 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        mapView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MapHeaderView.reuseIdentifier, for: indexPath) as? MapHeaderView
        let buttons : [buttonRegion] =
            [((mapView?.gangnamBtn)!, .gangnamgu),
             ((mapView?.seodaemunBtn)!, .seodaemungu),
             ((mapView?.mapoBtn)!, .mapogu),
             ((mapView?.yongsanBtn)!, .yongsangu),
             ((mapView?.dongjakBtn)!, .dongjakgu),
             ((mapView?.gwanakBtn)!, .gwanakgu),
             ((mapView?.geumcheonBtn)!, .geumcheongu),
             ((mapView?.yeongdeungpoBtn)!, .yeongdeungpogu),
             ((mapView?.guroBtn)!, .gurogu),
             ((mapView?.yangcheonBtn)!, .yangcheongu),
             ((mapView?.gangsuBtn)!, .gangseogu),
             ((mapView?.gangbukBtn)!, .gangbukgu),
             ((mapView?.seongbukBtn)!, .seongbukgu),
             ((mapView?.jongroBtn)!, .jongrogu),
             ((mapView?.eunpyeongBtn)!, .eunpyeonggu),
             ((mapView?.jungguBtn)!, .junggu),
             ((mapView?.seochoBtn)!, .seochogu),
             ((mapView?.dobongBtn)!, .dobonggu),
             ((mapView?.nowonBtn)!, .nowongu),
             ((mapView?.jungnangBtn)!, .jungnanggu),
             ((mapView?.dongdaemunBtn)!, .dongdaemungu),
             ((mapView?.seongdongBtn)!, .seongdonggu),
             ((mapView?.gwangjinBtn)!, .gwangjingu),
             ((mapView?.songpaBtn)!, .songpagu),
             ((mapView?.gangdongBtn)!, .gangdonggu),
             
             ((mapView?.guroBtn1)!, .gurogu),
             ((mapView?.gangsuBtn1)!, .gangseogu),
             ((mapView?.yeongdeungpoBtn1)!, .yeongdeungpogu),
             ((mapView?.gwanakBtn1)!, .gwanakgu),
             ((mapView?.mapoBtn1)!, .mapogu),
             ((mapView?.gangnamBtn1)!, .gangnamgu),
             ((mapView?.seochoBtn1)!, .seochogu),
             ((mapView?.seochoBtn2)!, .seochogu),
             ((mapView?.jongroBtn1)!, .jongrogu),
             ((mapView?.seongbukBtn1)!, .seongbukgu),
             ((mapView?.seongbukBtn2)!, .seongbukgu),
             ((mapView?.gangbukBtn1)!, .gangbukgu),
             ((mapView?.songpaBtn1)!, .songpagu)]
        setRegion(inputs: buttons)
        setDelegate(buttons: buttons.map({ (btn, region)  in
            return btn
        }))
        return mapView!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let defaultSpot_ = defaultSpot{
            return defaultSpot_.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MapContainerCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MapContainerCVCell.reuseIdentifier, for: indexPath) as? MapContainerCVCell
        {
            if let defaultSpot_ = defaultSpot{
                cell.configure(data : defaultSpot_[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let defaultSpot_ = defaultSpot{
            self.goToPlaceDetailVC(selectedIdx: defaultSpot_[indexPath.row].spotID)
        }
        
    }
}

extension MapContainerVC: UICollectionViewDelegateFlowLayout {
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
extension MapContainerVC {
    func getDefaultSpot(url : String){
        DefaultSpotService.shareInstance.getDefaultSpot(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let defaultSpot):
                self.defaultSpot = defaultSpot as? [UserScrapVOData]
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}




