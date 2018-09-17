//
//  CategoryDetailMoreVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
class CategoryDetailMoreVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    var filterView = PlaceFilterView.instanceFromNib()
    private lazy var categoryDetailMorePlaceVC: CategoryDetailMorePlaceVC = {
        let storyboard = Storyboard.shared().categoryStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: CategoryDetailMorePlaceVC.reuseIdentifier) as! CategoryDetailMorePlaceVC
        return viewController
    }()

    var selectedFirstFilter : FilterToggleBtn?
    var selectedSecondFilter = Set<UIButton>()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        setFilterView(filterView)
        setBackBtn()
    }
    
    
    func initContainerView(){
        addChildView(containerView: containerView, asChildViewController: categoryDetailMorePlaceVC)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        UIApplication.shared.keyWindow!.addSubview(filterView)
    }

}

//필터 뷰 버튼 액션 적용
extension CategoryDetailMoreVC {
    
    private typealias btnNum = (UIButton, Int)
    
    private func addtarget(inputs : [btnNum]){
        inputs.forEach { (button, actionNum) in
            switch actionNum {
            case 0 :
                button.addTarget(self, action: #selector(CategoryDetailMoreVC.firstFilterAction(_sender:)), for: .touchUpInside)
            case 1 :
                button.addTarget(self, action: #selector(CategoryDetailMoreVC.secondFilterAction(_sender:)), for: .touchUpInside)
            default :
                break
            }
            
        }
    }
    
    func setFilterView(_ filterView : PlaceFilterView){
        
        filterView.cancleBtn.addTarget(self, action: #selector(CategoryDetailMoreVC.cancleAction(_sender:)), for: .touchUpInside)
        filterView.okBtn.addTarget(self, action: #selector(CategoryDetailMoreVC.okAction(_sender:)), for: .touchUpInside)
        let buttons : [btnNum] = [ (filterView.popularBtn, 0), (filterView.recentBtn, 0), (filterView.restaurantBtn, 1), (filterView.cafeBtn, 1), (filterView.hotplaceBtn, 1), (filterView.etcBtn, 1)]
        
        addtarget(inputs: buttons)
        
        //첫번째 섹션
        let popularBtn = filterView.popularBtn!
        let recentBtn = filterView.recentBtn!
        
        popularBtn.setOtherBtn(another: recentBtn)
        recentBtn.setOtherBtn(another: popularBtn)
         if let selectedBtn_ = selectedFirstFilter {
         selectedBtn_.selected()
         } else {
         popularBtn.selected()
         selectedFirstFilter = popularBtn
         }
        
        //두번째 섹션
        filterView.restaurantBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_restaurant_green"), unselected: #imageLiteral(resourceName: "map_filter_restaurant_gray"))
        filterView.hotplaceBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_hotplace_green"), unselected: #imageLiteral(resourceName: "map_filter_hotplace_gray"))
        filterView.etcBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_etc_green"), unselected: #imageLiteral(resourceName: "map_filter_etc_gray"))
        filterView.cafeBtn!.setImage(selected: #imageLiteral(resourceName: "map_filter_cafe_green"), unselected: #imageLiteral(resourceName: "map_filter_cafe_gray"))
        
    } //setFilterView
    
    
    //필터 뷰 버튼에 대한 액션 모음
    @objc public func cancleAction(_sender: UIButton) {
        self.filterView.removeFromSuperview()
    }
    
    @objc public func okAction(_sender: UIButton) {
        //여기서 통신
        //if selectedFirstFiler.tag == 0 이면 인기순
        print(selectedFirstFilter?.tag ?? -1)
        selectedSecondFilter.forEach({ (button) in
            print(button.tag)
        })
        self.filterView.removeFromSuperview()
    }
    
    @objc public func firstFilterAction(_sender: FilterToggleBtn) {
        //TODO - selectedFirstFiler 를 cache데이터로 만들어서 밑에서처럼 처리 가능하게 하기. 지금은 해당 뷰에서만 캐시 담고 있음
    
 
        selectedFirstFilter = _sender
        
    }

    @objc public func secondFilterAction(_sender: UIButton) {
        if(!_sender.isSelected) {
            _sender.isSelected = true
            selectedSecondFilter.insert(_sender)
        } else {
            _sender.isSelected = false
            selectedSecondFilter.remove(_sender)
        }
    }
}

