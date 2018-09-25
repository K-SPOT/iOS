//
//  SearchResultMoreVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultMoreVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var filterBtn : UIButton!
    @IBOutlet weak var containerView: UIView!
    var filterView = PlaceFilterView.instanceFromNib()
    var searchData : [SearchResultVODataPlace]? {
        didSet {
            searchResultMorePlaceVC.searchData = searchData
        }
    }
    var searchTxt = ""
    private lazy var searchResultMorePlaceVC: SearchResultMorePlaceVC = {
        let storyboard = Storyboard.shared().mainStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: SearchResultMorePlaceVC.reuseIdentifier) as! SearchResultMorePlaceVC
        if selectedLang == .kor {
            viewController.headerTitle = "장소"
        } else {
            viewController.headerTitle = "Spot"
        }
        
        return viewController
    }()
    
    var selectedFirstFilter : FilterToggleBtn?
    var selectedSecondFilter : Set<UIButton>?
    var selectedSecondFilter_ = Set<UIButton>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        setFilterView(filterView)
        setBackBtn()
        if selectedLang == .kor {
            filterBtn.setImage(#imageLiteral(resourceName: "map_filter"), for: .normal)
        } else {
            filterBtn.setImage(#imageLiteral(resourceName: "board_star_green"), for: .normal)
        }
    }
    
    
    func initContainerView(){
        addChildView(containerView: containerView, asChildViewController: searchResultMorePlaceVC)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        UIApplication.shared.keyWindow!.addSubview(filterView)
    }
    
}

//필터 뷰 버튼 액션 적용
extension SearchResultMoreVC {
    
    private typealias btnNum = (UIButton, Int)
    
    private func addtarget(inputs : [btnNum]){
        inputs.forEach { (button, actionNum) in
            switch actionNum {
            case 0 :
                button.addTarget(self, action: #selector(SearchResultMoreVC.firstFilterAction(_sender:)), for: .touchUpInside)
            case 1 :
                button.addTarget(self, action: #selector(SearchResultMoreVC.secondFilterAction(_sender:)), for: .touchUpInside)
            default :
                break
            }
            
        }
    }
    
    func setFilterView(_ filterView : PlaceFilterView){
        
        filterView.cancleBtn.addTarget(self, action: #selector(SearchResultMoreVC.cancleAction(_sender:)), for: .touchUpInside)
        filterView.okBtn.addTarget(self, action: #selector(SearchResultMoreVC.okAction(_sender:)), for: .touchUpInside)
        let buttons : [btnNum] = [ (filterView.popularBtn, 0), (filterView.recentBtn, 0), (filterView.restaurantBtn, 1), (filterView.cafeBtn, 1), (filterView.hotplaceBtn, 1), (filterView.etcBtn, 1)]
        
        addtarget(inputs: buttons)
        
        //첫번째 섹션
       
        let popularBtn = filterView.popularBtn!
        let recentBtn = filterView.recentBtn!
        if selectedLang == .eng {
            popularBtn.setTitle("popularity", for: .normal)
            recentBtn.setTitle("recent", for: .normal)
            filterView.okBtn.setTitle("Check", for: .normal)
        }
        popularBtn.setOtherBtn(another: recentBtn)
        recentBtn.setOtherBtn(another: popularBtn)
        if let selectedBtn_ = selectedFirstFilter {
            selectedBtn_.selected()
        } else {
            popularBtn.selected()
            selectedFirstFilter = popularBtn
        }
        
        //두번째 섹션
        if selectedLang == .kor {
            filterView.restaurantBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_restaurant_green"), unselected: #imageLiteral(resourceName: "map_filter_restaurant_gray"))
            filterView.hotplaceBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_hotplace_green"), unselected: #imageLiteral(resourceName: "map_filter_hotplace_gray"))
            filterView.etcBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_etc_green"), unselected: #imageLiteral(resourceName: "map_filter_etc_gray"))
            filterView.cafeBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_cafe_green"), unselected: #imageLiteral(resourceName: "map_filter_cafe_gray"))
        } else {
            filterView.restaurantBtn!.setImage(selected: #imageLiteral(resourceName: "board_star_green"), unselected: #imageLiteral(resourceName: "board_star_gray"))
             filterView.hotplaceBtn!.setImage(selected: #imageLiteral(resourceName: "board_star_green"), unselected: #imageLiteral(resourceName: "board_star_gray"))
             filterView.cafeBtn!.setImage(selected: #imageLiteral(resourceName: "board_star_green"), unselected: #imageLiteral(resourceName: "board_star_gray"))
             filterView.etcBtn!.setImage(selected: #imageLiteral(resourceName: "board_star_green"), unselected: #imageLiteral(resourceName: "board_star_gray"))
        }
        
    
        
        
    } //setFilterView
    
    
    //필터 뷰 버튼에 대한 액션 모음
    @objc public func cancleAction(_sender: UIButton) {
        self.filterView.removeFromSuperview()
    }
    
    @objc public func okAction(_sender: UIButton) {
        //여기서 통신
        //if selectedFirstFiler.tag == 0 이면 인기순
        print(selectedFirstFilter?.tag ?? -1)
        /*selectedSecondFilter.forEach({ (button) in
            print(button.tag)
        })*/
        ///search/:keyword/filter/place/:order/:is_food/:is_cafe/:is_sights/:is_etc
        var isFood : Int = 1
        var isCafe : Int = 1
        var isSights : Int = 1
        var isEtc : Int = 1
        var order = -1
        if let first = (selectedFirstFilter?.tag) {
            order = first
        }
        
        let keyword = searchTxt
        if let selectedSecondFilter_ = selectedSecondFilter {
            
            let buttonTagArr = selectedSecondFilter_.map({ (button) in
                return button.tag
            })
            isFood =  buttonTagArr.contains(0) ? 1: 0
            isCafe = buttonTagArr.contains(1) ? 1 : 0
            isSights = buttonTagArr.contains(2) ? 1 : 0
            isEtc = buttonTagArr.contains(3) ? 1 : 0
        }
        getFilteredData(url: UrlPath.searchResult.getURL("\(keyword)/filter/place/\(order)/\(isFood)/\(isCafe)/\(isSights)/\(isEtc)"))
        self.filterView.removeFromSuperview()
    }
    
    @objc public func firstFilterAction(_sender: FilterToggleBtn) {
        //TODO - selectedFirstFiler 를 cache데이터로 만들어서 밑에서처럼 처리 가능하게 하기. 지금은 해당 뷰에서만 캐시 담고 있음
        
        
        selectedFirstFilter = _sender
        
    }
    
    @objc public func secondFilterAction(_sender: UIButton) {
        if(!_sender.isSelected) {
            _sender.isSelected = true
            selectedSecondFilter_.insert(_sender)
        } else {
            _sender.isSelected = false
            selectedSecondFilter_.remove(_sender)
        }
        selectedSecondFilter = selectedSecondFilter_
    }
}

extension SearchResultMoreVC {
    func getFilteredData(url : String){
        SearchResultPlaceMoreService.shareInstance.getSearchResultPlaceMore(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let searchResultData):
                let searchResultData_ = searchResultData as? [SearchResultVODataPlace]
                self.searchData = searchResultData_
                self.searchResultMorePlaceVC.isChange = true
            case .networkFail :
                self.networkSimpleAlert()
                
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
