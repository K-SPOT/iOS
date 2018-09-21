//
//  MapContainerVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MapContainerVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mapView : MapHeaderView?
    let sunglassArr = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension MapContainerVC : SelectRegionDelegate {
    func tap(_ region : Region) {
        var regionTxt = ""
        if selectedLang == .kor {
            regionTxt = region.rawValue
        } else {
            regionTxt = "\(region)"
        }
        mapView?.selectedRegionLbl.text = regionTxt
        let parentVC = self.parent as? MapVC
        parentVC?.isGoogleMapLocation = false
        
        
        //self.parent?.title = region.rawValue
        //self.parent?.navigationItem.title = region.rawValue
        //TODO - 통신 대비해서 case rawValue 뽑아내기 case gangsu -> gangsu
        
        
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
             ((mapView?.gangsuBtn)!, .gangsugu),
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
             ((mapView?.gangsuBtn1)!, .gangsugu),
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
        
        return sunglassArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MapContainerCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MapContainerCVCell.reuseIdentifier, for: indexPath) as? MapContainerCVCell
        {
            cell.myImgView.image = sunglassArr[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.goToPlaceDetailVC(selectedIdx: 0)
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
    
}




