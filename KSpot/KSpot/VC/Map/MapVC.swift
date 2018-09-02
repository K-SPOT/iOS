//
//  MapVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MapVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    private lazy var mapContainerVC: MapContainerVC = {
        let storyboard = Storyboard.shared().mapStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: MapContainerVC.reuseIdentifier) as! MapContainerVC
        return viewController
    }()
    
    let filterView = MapFilterView.instanceFromNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        setFilterView(filterView)
        self.title = "defulat title"
       
    }
    
    func initContainerView(){
        addChildView(containerView: containerView, asChildViewController: mapContainerVC)
    }
    
    @IBAction func filterAction(_ sender: Any) {
      UIApplication.shared.keyWindow!.addSubview(filterView)
    }
    
    func setFilterView(_ filterView : MapFilterView){
        filterView.cancleBtn.addTarget(self, action: #selector(MapVC.cancleAction(_sender:)), for: .touchUpInside)
    }
    
    @objc public func cancleAction(_sender: UIButton) {
         self.filterView.removeFromSuperview()
    }
    
}
