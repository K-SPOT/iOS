//
//  CategoryVC.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var celebrityBtn: CategoryToggleBtn!
    @IBOutlet weak var celebrityGreenView: UIView!
    @IBOutlet weak var broadcastBtn: CategoryToggleBtn!
    var celebrityList : [ChannelVODataChannelList]? {
        didSet {
            celebrityVC.celebrityList = celebrityList
        }
    }
    var broadcastList : [ChannelVODataChannelList]? {
        didSet {
            broadcastVC.broadcastList = broadcastList
        }
    }
    
    @IBOutlet weak var broadcastGreenView: UIView!
    
    @IBAction func searchAction(_ sender: Any) {
        self.goToSearchVC()
    }
    
    
    private lazy var celebrityVC: CelebrityVC = {
        let storyboard = Storyboard.shared().categoryStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: CelebrityVC.reuseIdentifier) as! CelebrityVC
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var broadcastVC: BroadcastVC = {
        let storyboard = Storyboard.shared().categoryStoryboard
        var viewController = storyboard.instantiateViewController(withIdentifier: BroadcastVC.reuseIdentifier) as! BroadcastVC
        viewController.delegate = self
        return viewController
    }()
    
   
    @IBAction func switchView(_ sender: CategoryToggleBtn) {
        updateView(selected: sender.tag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        celebrityBtn.setBtn(another: broadcastBtn, bottomLine: celebrityGreenView)
        broadcastBtn.setBtn(another: celebrityBtn, bottomLine: broadcastGreenView)
        self.getMyChannel(url: UrlPath.ChannelList.getURL())
        updateView(selected: 0)
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = false
        //viewWillLayoutSubviews()
    }
}

//컨테이너뷰
extension CategoryVC{
    private func updateView(selected : Int) {
        if selected == 0 {
        
            removeChildView(containerView: containerView, asChildViewController: broadcastVC)
          
            addChildView(containerView: containerView, asChildViewController: celebrityVC)
        } else {
            removeChildView(containerView: containerView, asChildViewController: celebrityVC)
          
            addChildView(containerView: containerView, asChildViewController: broadcastVC)
        }
    }

}
extension CategoryVC : SelectDelegate {
    func tap(selected: Int?) {
        //selected 0 => celebrity / 1 = > broadcast
        let categoryStoryboard = Storyboard.shared().categoryStoryboard
        if let categoryDetailVC = categoryStoryboard.instantiateViewController(withIdentifier:CategoryDetailVC.reuseIdentifier) as? CategoryDetailVC {
            
            self.navigationController?.pushViewController(categoryDetailVC, animated: true)
        }
    }
   
}

//통신
extension CategoryVC  {
    func getMyChannel(url : String){
        ChannelService.shareInstance.getChannelList(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let channelList):
                let channelData = channelList as! ChannelVOData
               self.celebrityList = channelData.channelCelebrityList
               self.broadcastList = channelData.channelBroadcastList
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
}
