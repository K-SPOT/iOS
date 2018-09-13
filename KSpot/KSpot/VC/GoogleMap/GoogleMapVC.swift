//
//  GoogleMapVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 11..
//  Copyright © 2018년 강수진. All rights reserved.


import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class GoogleMapVC: UIViewController, UIGestureRecognizerDelegate, GMSMapViewDelegate {
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var address : [Result]?
    @IBOutlet var myMapView: GMSMapView!
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="찾고 싶은 장소를 입력해주세요"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "map_gps_gps"), for: .normal)
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let okBtn: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = ColorChip.shared().mainColor
        btn.setTitle("이 위치로 장소 설정",for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: NanumSquareOTF.NanumSquareOTFR.rawValue, size: 20)
        btn.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    
        navBarBackgroundAlpha = 0
        myMapView.delegate=self
        txtFieldSearch.delegate=self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        setBackBtn()
        setupViews()
        initGoogleMaps()
    }
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if let location_ = location {
            let lat = location_.coordinate.latitude
            let long = location_.coordinate.longitude
            chosenPlace = MyPlace(name: "", lat: lat, long: long)
            myMapView.animate(toLocation: (location_.coordinate))
        }
    }
    
    @objc func okAction() {
        if let chosenPlace_ = chosenPlace {
            //let addressName = getAddressForLatLng(latitude: chosenPlace_.lat.description, longitude: chosenPlace_.long.description)
            let lat = chosenPlace_.lat.description
            let long = chosenPlace_.long.description
            self.getAddress(url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=\(NetworkConfiguration.shared().googleMapAPIKey)")
            
//            print("여기예요 여기 1 \(addressName)")
//            print("선택된 내 위도 : \(chosenPlace_.lat)")
//            print("선택된 내 경도 : \(chosenPlace_.long)")
        } else {
            //현재 위치
            let location: CLLocation? = myMapView.myLocation
            if let location_ = location {
                let lat = location_.coordinate.latitude.description
                let long = location_.coordinate.longitude.description
                self.getAddress(url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=\(NetworkConfiguration.shared().googleMapAPIKey)")
               // let addressName = getAddressForLatLng(latitude: lat.description, longitude: long.description)
                
               // print("여기예요 여기 2 \(addressName)")
            }
        }
        self.pop()
    }
}

extension GoogleMapVC {
    func getAddress(url : String){
        GoogleMapService.shareInstance.getAddress(url: url) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .networkSuccess(let getAddress):
                
                self.address = getAddress as? [Result]
                print("잘들어옴")
                print(self.address)
                for addressComponent in self.address![0].addressComponents{
                    if addressComponent.types.contains("sublocality_level_1"){
                         print("여기용~ \(addressComponent.shortName)")
                    }
                   
                }
                //print("여기용~ \(name)")
                
                break
            case .nullValue :
                self.simpleAlert(title: "오류", message: "검색 결과가 없습니다")
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                break
            }
        }
    }
}

//get address from lat/long
extension GoogleMapVC {
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


extension GoogleMapVC : GMSAutocompleteViewControllerDelegate {
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.icon = #imageLiteral(resourceName: "map_gps_dot")
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
}

//CLLocationManagerDelegate
extension GoogleMapVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.myMapView.animate(to: camera)

    }
}

//UITextFieldDelegate
extension GoogleMapVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
}

//컨스트레인
extension GoogleMapVC {
    func setupViews() {
        
        myMapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
        }
        
        self.view.addSubview(txtFieldSearch)
        txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
        txtFieldSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(35)
        }
        setupTextField(textField: txtFieldSearch, img: #imageLiteral(resourceName: "main_search"))
        
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.snp.makeConstraints { (make) in
            make.width.height.equalTo(51)
            make.top.equalTo(txtFieldSearch.snp.bottom).offset(10)
            make.trailing.equalTo(txtFieldSearch.snp.trailing)
        }
        
        
        self.view.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(58)
        }
    }
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 7, width: 15, height: 15))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
}


