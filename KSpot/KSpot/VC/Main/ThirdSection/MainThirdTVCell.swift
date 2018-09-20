//
//  MainThirdTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MainThirdTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
   var delegate : SelectSectionDelegate?
    var popularPlaceData : [MainVODataMain]? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
      //  self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
}

extension MainThirdTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let popularPlaceData_ = popularPlaceData{
            return popularPlaceData_.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MainThirdCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainThirdCVCell.reuseIdentifier, for: indexPath) as? MainThirdCVCell
        {
            if let popularPlaceData_ = popularPlaceData {
                cell.configure(data: popularPlaceData_[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let popularPlaceData_ = popularPlaceData {
            delegate?.tap(section: .third, seledtedId: popularPlaceData_[indexPath.row].spotID)
        }
    }
    
   
}

extension MainThirdTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (252/375)*window!.frame.width, height: (262/667)*window!.frame.height)
    }
    
    //collectionView inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 33, 0, 33)
    }
    
    
}

extension MainThirdTVCell : UIScrollViewDelegate{
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        
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

