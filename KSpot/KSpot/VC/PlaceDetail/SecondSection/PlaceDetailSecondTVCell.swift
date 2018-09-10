//
//  PlaceDetailSecondTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 9. 4..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class PlaceDetailSecondTVCell: UITableViewCell {
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var showAllBtn: UIButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    var delegate : SelectSectionelegate?
    
    let sunglassArr = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg")]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let ratingLblInt = Double(ratingLbl.text!)
        if let ratingLblInt_ = ratingLblInt {
            setStackViewStar(rating: ratingLblInt_)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    
    func setStackViewStar(rating : Double){
        var temp = rating
        for i in 0..<stackView.arrangedSubviews.count{
            if (temp - 1 >= 0){
                (stackView.arrangedSubviews[i] as! UIImageView).image = #imageLiteral(resourceName: "review_star_full")
                temp -= 1
            } else if (temp - 0.5 >= 0){
                (stackView.arrangedSubviews[i] as! UIImageView).image = #imageLiteral(resourceName: "review_star_half")
                temp -= 0.5
            } else {
                (stackView.arrangedSubviews[i] as! UIImageView).image = #imageLiteral(resourceName: "review_star_empty")
            }
        }
    } //setStackViewStar

}

extension PlaceDetailSecondTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sunglassArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: PlaceDetailSecondCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceDetailSecondCVCell.reuseIdentifier, for: indexPath) as? PlaceDetailSecondCVCell
        {
            cell.reviewImgView.image = sunglassArr[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tap(section: .second, seledtedId: indexPath.row)
    }
}


extension PlaceDetailSecondTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (340/375)*window!.frame.width, height: (206/667)*window!.frame.height)
    }
    
}

extension PlaceDetailSecondTVCell : UIScrollViewDelegate{
    
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

