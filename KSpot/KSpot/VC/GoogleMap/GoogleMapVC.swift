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

enum MapEntryPoint {
    case searchSpecificLocation
    case currentLocation
}

class GoogleMapVC: UIViewController, UIGestureRecognizerDelegate, GMSMapViewDelegate {
    typealias latLong = (lat : Double, long : Double)
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var delegate : SelectDelegate?
    var entryPoint : MapEntryPoint = .currentLocation
    let defualtLat = 36.3504
    let defualtLong = 127.3845

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
        //locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        setBackBtn()
        setupViews()
        initGoogleMaps()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if entryPoint == .currentLocation {
            locationManager.startUpdatingLocation()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                let myLocation = getMyLatLong()
                chosenPlace = MyPlace(name: "", lat: myLocation.lat, long: myLocation.long)
            } else {
                chosenPlace = MyPlace(name: "대전", lat: defualtLat, long: defualtLong)
            }
        } else {
            let lat = chosenPlace?.lat
            let long = chosenPlace?.long
            if let lat_ = lat, let long_ = long {
                goToSelectedMapView(lat : lat_, long : long_)
            }
        }

    }
    
    func goToSelectedMapView(lat : Double, long : Double){
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.myMapView.animate(to: camera)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.icon = #imageLiteral(resourceName: "map_gps_dot")
        marker.title = "\(chosenPlace?.name ?? "")"
        marker.map = myMapView
        
    }
    
    @objc func btnMyLocationAction() {

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           
            let myLocation = getMyLatLong()
            chosenPlace = MyPlace(name: "", lat: myLocation.lat, long: myLocation.long)
            let camera = GMSCameraPosition.camera(withLatitude: myLocation.lat, longitude: myLocation.long, zoom: 17.0)
            self.myMapView.animate(to: camera)
        } else {
            showLocationDisableAlert()
        }
        
    }

    func getMyLatLong() -> latLong {
        let location: CLLocation? = myMapView.myLocation
        if let location_ = location {
            let lat = location_.coordinate.latitude
            let long = location_.coordinate.longitude
            return (lat, long)
        }
        return (defualtLat, defualtLong)
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
    
    @objc func okAction() {
        delegate?.tap(selected: 0)
        if let chosenPlace_ = chosenPlace {
            //1. 만약 위치 정보 허용 안해서 defualt 로 대전이 설정되어 있을때
            //2. 위치 정보 허용해서 현재 위치가 설정 되어 있을 때
            //3. 구글 맵 상에서 위치를 설정 했을 때
            let lat = chosenPlace_.lat.description
            let long = chosenPlace_.long.description
        
        }
        self.pop()
      
       
    }
}

/*extension GoogleMapVC {
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
}*/

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
        let camera = GMSCameraPosition.camera(withLatitude: defualtLat, longitude: defualtLong, zoom: 17.0)
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


