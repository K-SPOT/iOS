//
//  MyPageFirstTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MypageFisrtTVCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
     var delegate : SelectSectionDelegate?
    var channelArr : [MypageVODataChannel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    private var indexOfCellBeforeDragging = 0
    var finalOffset : CGFloat = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    @IBAction func moreAction(_ sender: UIButton) {
        delegate?.tap(section: .first, seledtedId: -1)
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}


extension MypageFisrtTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let channelArr_ = channelArr{
            return channelArr_.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MypageCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageCVCell.reuseIdentifier, for: indexPath) as? MypageCVCell
        {
            if let channelArr_ = channelArr{
                cell.configure(data: channelArr_[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let channelArr_ = channelArr{
           delegate?.tap(section: .first, seledtedId: channelArr_[indexPath.row].channelID)
           
        }
       
    }
}


extension MypageFisrtTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (248/375)*window!.frame.width, height: (168/667)*window!.frame.height)
    }
    
}

extension MypageFisrtTVCell : UIScrollViewDelegate{
    
    private func indexOfMajorCell() -> Int {
        
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / (itemWidth)
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
        
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
}
