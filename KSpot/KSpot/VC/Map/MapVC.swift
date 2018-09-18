//
//  MapVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
class MapVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    private lazy var mapContainerVC: MapContainerVC = {
        let storyboard = Storyboard.shared().mapStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: MapContainerVC.reuseIdentifier) as! MapContainerVC
        return viewController
    }()
    
    
    var filterView = MapFilterView.instanceFromNib()
    var selectedFirstFilter : FilterToggleBtn?
    var selectedSecondFilter : Int?
    var selectedThirdFilter = Set<UIButton>()
    var isGoogleMapLocation : Bool = true {
        didSet {
            filterView.isGoogle = isGoogleMapLocation
            if isGoogleMapLocation {
                //구글 맵에서 선택했을 때는 거리 인덱스 활성화
                 setDistanceIdx(index: selectedSecondFilter ?? 3)
            } else {
                  filterView.distanceLbl.text = "1k 까지 설정"
                //지도에서 클릭해서 선택했을 때는 버튼 활성화
                 if let selectedBtn_ = selectedFirstFilter {
                 selectedBtn_.selected()
                 } else {
                 filterView.popularBtn.selected()
                 selectedFirstFilter = filterView.popularBtn
                 }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        locationInit()
        setFilterView(filterView)
       
        //네비게이션 타이틀
        self.navigationItem.title = "K-Spot"
    }
   
    
    func initContainerView(){
        addChildView(containerView: containerView, asChildViewController: mapContainerVC)
    }
    
    @IBAction func filterAction(_ sender: Any) {
   
        UIApplication.shared.keyWindow!.addSubview(filterView)
    }
    
   
    @IBAction func locationAction(_ sender: Any) {
        
        isGoogleMapLocation = true
        let mapStoryboard = Storyboard.shared().mapStoryboard
        if let googleMapVC = mapStoryboard.instantiateViewController(withIdentifier:GoogleMapVC.reuseIdentifier) as? GoogleMapVC {
            googleMapVC.delegate = self
            
            googleMapVC.entryPoint = .currentLocation
            self.navigationController?.pushViewController(googleMapVC, animated: true)
        }
        
    }
    @IBAction func searchAction(_ sender: Any) {
        goToSearchVC()
    }
    
    
}
extension MapVC : SelectDelegate {
    func tap(selected: Int?) {
        isGoogleMapLocation = true
        mapContainerVC.mapView?.selectedRegionLbl.text = "내 주변"
        
    }
}
//필터 뷰 버튼 액션 적용
extension MapVC {
    
    private typealias btnNum = (UIButton, Int)
    
    private func addtarget(inputs : [btnNum]){
        inputs.forEach { (button, actionNum) in
            switch actionNum {
            case 0 :
                button.addTarget(self, action: #selector(MapVC.firstFilterAction(_sender:)), for: .touchUpInside)
            case 1 :
                button.addTarget(self, action: #selector(MapVC.secondFilterAction(_sender:)), for: .touchUpInside)
            case 2 :
                button.addTarget(self, action: #selector(MapVC.thirdFilterAction(_sender:)), for: .touchUpInside)
            default :
                break
            }
            
        }
    }
    
    func setDistanceIdx(index : Int){
        let descArr : [String] = ["100m", "300m", "500m", "1k", "3k"]
        let numberOfItems = descArr.count
        let safeIndex = max(0, min(numberOfItems - 1, index))
        
        if (safeIndex == 0){
            filterView.leftBtn.isHidden = true
        } else if (safeIndex == descArr.count - 1){
             filterView.rightBtn.isHidden = true
        } else {
            filterView.leftBtn.isHidden = false
            filterView.rightBtn.isHidden = false
        }
        
        selectedSecondFilter = safeIndex
        filterView.distanceLbl.text = "\(descArr[safeIndex]) 까지 설정"
    }
    
    
    func setFilterView(_ filterView : MapFilterView){
       
        filterView.cancleBtn.addTarget(self, action: #selector(MapVC.cancleAction(_sender:)), for: .touchUpInside)
        filterView.okBtn.addTarget(self, action: #selector(MapVC.okAction(_sender:)), for: .touchUpInside)
        let buttons : [btnNum] = [ (filterView.popularBtn, 0), (filterView.recentBtn, 0), (filterView.leftBtn, 1), (filterView.rightBtn, 1), (filterView.restaurantBtn, 2), (filterView.cafeBtn, 2), (filterView.hotplaceBtn, 2), (filterView.eventBtn, 2), (filterView.etcBtn, 2)]
        
        addtarget(inputs: buttons)

        filterView.isGoogle = isGoogleMapLocation
        
        //첫번째 섹션
        let popularBtn = filterView.popularBtn!
        let recentBtn = filterView.recentBtn!
      
        popularBtn.setOtherBtn(another: recentBtn)
        recentBtn.setOtherBtn(another: popularBtn)
     
      /*  if let selectedBtn_ = selectedFirstFilter {
            selectedBtn_.selected()
        } else {
            popularBtn.selected()
            selectedFirstFilter = popularBtn
        }*/
        
        //두번째 섹션 - default 는 1km
        setDistanceIdx(index: selectedSecondFilter ?? 3)
        
        //세번째 섹션
        filterView.restaurantBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_restaurant_green"), unselected: #imageLiteral(resourceName: "map_filter_restaurant_gray"))
        filterView.hotplaceBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_hotplace_green"), unselected: #imageLiteral(resourceName: "map_filter_hotplace_gray"))
        filterView.etcBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_etc_green"), unselected: #imageLiteral(resourceName: "map_filter_etc_gray"))
        filterView.cafeBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_cafe_green"), unselected: #imageLiteral(resourceName: "map_filter_cafe_gray"))
        filterView.eventBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_event_green"), unselected: #imageLiteral(resourceName: "map_filter_event_gray"))
        
    } //setFilterView
    
    
    //필터 뷰 버튼에 대한 액션 모음
    @objc public func cancleAction(_sender: UIButton) {
        self.filterView.removeFromSuperview()
    }
    
    @objc public func okAction(_sender: UIButton) {
        //여기서 통신
        //if selectedFirstFiler.tag == 0 이면 인기순
        print(selectedFirstFilter?.tag ?? -1)
        print(selectedSecondFilter ?? -1)
        selectedThirdFilter.forEach({ (button) in
            print(button.tag)
        })
        self.filterView.removeFromSuperview()
    }
    
    @objc public func firstFilterAction(_sender: FilterToggleBtn) {
        //TODO - selectedFirstFiler 를 cache데이터로 만들어서 밑에서처럼 처리 가능하게 하기. 지금은 해당 뷰에서만 캐시 담고 있음
        /*
         if let selectedBtn_ = selectedFirstFiler {
         selectedBtn_.selected()
         } else {
         popularBtn.selected()
         }
         */
        selectedFirstFilter = _sender
        
    }
    @objc public func secondFilterAction(_sender: UIButton) {
        var index = selectedSecondFilter ?? 3
        if _sender.tag == 0 {
            index -= 1
        } else {
            index += 1
        }
        setDistanceIdx(index: index)
    }
    @objc public func thirdFilterAction(_sender: UIButton) {
        if(!_sender.isSelected) {
            _sender.isSelected = true
            selectedThirdFilter.insert(_sender)
        } else {
            _sender.isSelected = false
            selectedThirdFilter.remove(_sender)
        }
    }
}


//위치 정보
extension MapVC : CLLocationManagerDelegate{
    
    func locationInit(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    //location 허용 안했을 때
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            showLocationDisableAlert()
            //이때 디폴트 세팅
        } else {
            //self.locationAction(0)
            
        }
    }
    
    func showLocationDisableAlert() {
        let alertController = UIAlertController(title: "위치 접근이 제한되었습니다.", message: "위치 정보가 필요합니다.", preferredStyle: .alert)
        let openAction = UIAlertAction(title: "설정으로 가기", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}




