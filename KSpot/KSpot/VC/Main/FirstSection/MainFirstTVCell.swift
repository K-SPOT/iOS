//
//  MainFirstTVCell.swift
//  KSpot
//
//  Created by 강수진 on 2018. 8. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import ImageSlideshow

class MainFirstTVCell: UITableViewCell {
    
   /* @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var delegate : SelectSectionelegate?
     var currentPages = 0
     let sunglassArr = [#imageLiteral(resourceName: "aimg"),#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "cimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
     override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        pageControl.numberOfPages = sunglassArr.count
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        pageControl.currentPageIndicatorTintColor = ColorChip.shared().mainColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.pageControl.currentPage = 0
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }*/
  
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var localSource : [ImageSource] = []
    
    var delegate : SelectSectionelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customUnder(padding: 30))
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = ColorChip.shared().mainColor
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            //print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(localSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(MainFirstTVCell.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    
    @objc func didTap() {
        delegate?.tap(section: .first, seledtedId: slideshow.currentPage)
    }
}

/*extension MainFirstTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sunglassArr.count
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MainFirstCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFirstCVCell.reuseIdentifier, for: indexPath) as? MainFirstCVCell
        {
           
            
            cell.myImgView.image = sunglassArr[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tap(section: .first, seledtedId: indexPath.row)
    }
}

extension MainFirstTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: (364/375)*self.frame.width)
        //return CGSize(width: 375, height: 375)
    }
}

extension MainFirstTVCell : UIScrollViewDelegate{
    
    //ScrollView delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        self.currentPages = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = self.currentPages
    
    }
    
}*/
