//
//  ProfileFilterView.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 11/10/20.
//

import Foundation
import UIKit


private let reuseIdentifire = "ProfileFilterCell"

class ProfileFilterView : UIView  {
    
    //Mark: - Properties
    
    
    lazy var collectionview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
        
        
    }()
    
    //Mark: - Lifestyle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionview.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifire)
        addSubview(collectionview)
        collectionview.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark: - Helper
    
    //Mark: - Selector
    
    //Mark: - UICollectionViewDataSource
    
}


//Mark: - UICollectionViewDelegate

extension ProfileFilterView : UICollectionViewDelegate {

}


//Mark: - UICollectionViewFlowLayout

extension ProfileFilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3 , height: frame.width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}


//Mark: - UICollectionViewDataSource

extension ProfileFilterView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: reuseIdentifire, for: indexPath) as! ProfileFilterCell
        
        return cell
    }

}
