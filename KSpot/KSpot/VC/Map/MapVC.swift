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
        //허용 됐을때
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            
            guard let lat = currentLocation?.coordinate.latitude,
                let long = currentLocation?.coordinate.longitude else {
                    return
            }
            let addressName = getAddressForLatLng(latitude: lat.description, longitude: long.description)
            print(addressName)
        }
    }
    @IBAction func searchAction(_ sender: Any) {
        let mapStoryboard = Storyboard.shared().mapStoryboard
        if let googleMapVC = mapStoryboard.instantiateViewController(withIdentifier:GoogleMapVC.reuseIdentifier) as? GoogleMapVC {
            googleMapVC.delegate = self
            self.navigationController?.pushViewController(googleMapVC, animated: true)
        }
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


//get address from lat/long
extension MapVC {
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(NetworkConfiguration.shared().googleMapAPIKey)")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            print(JSON(json))
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 6) {
                                zip =  (address.object(at: 6) as! NSDictionary)["short_name"] as! String
                            }
                            newaddress = "\(number) \(street), \(city), \(state) \(zip)"
                            //newaddress = street.description
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
        
    }
}


