//
//  MainSecondTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 2..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MainSecondTVCell: UITableViewCell {
    
    @IBOutlet weak var thisWeekLbl: UILabel!
    
    @IBOutlet weak var recommendPlaceLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var indexOfCellBeforeDragging = 0
    var finalOffset : CGFloat = 0

    
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    var delegate : SelectSectionDelegate?
    var recommendPlaceData : [MainVODataMain]? {
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
        if selectedLang == .kor {
            thisWeekLbl.text = "이번주 올라온"
            recommendPlaceLbl.text = "따끈따끈 추천 PLACE"
        } else {
            thisWeekLbl.text = "This week,"
            recommendPlaceLbl.text = "we recommend this PLACE"
        }
        //self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    
}

extension MainSecondTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let recommendPlaceData_ = recommendPlaceData{
            return recommendPlaceData_.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MainSecondCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSecondCVCell.reuseIdentifier, for: indexPath) as? MainSecondCVCell
        {
            if let recommendPlaceData_ = recommendPlaceData {
                 cell.configure(data: recommendPlaceData_[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recommendPlaceData_ = recommendPlaceData {
             delegate?.tap(section: .second, seledtedId: recommendPlaceData_[indexPath.row].spotID)
        }
       
    }
}


extension MainSecondTVCell: UICollectionViewDelegateFlowLayout {
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

extension MainSecondTVCell : UIScrollViewDelegate{
    
    private func indexOfMajorCell() -> Int {
      /*var index = 0
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let offset = collectionView.contentOffset.x
        
        print("offset : \(offset)")
        if (offset > finalOffset){
            //왼쪽으로 스와이프
            index = indexOfCellBeforeDragging+1
        } else {
            index = indexOfCellBeforeDragging-1
        }
        
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex*/
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / (itemWidth)
        print("최종 오프셋 \(collectionView.contentOffset.x)")
        print("proportionalOffset \(proportionalOffset)")
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("시작")
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        finalOffset = collectionView.contentOffset.x
        print("오프셋 \(collectionView.contentOffset.x)")
        
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
