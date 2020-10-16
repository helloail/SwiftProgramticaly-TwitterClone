//
//  ProfileFilterCell.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 11/10/20.
//

import Foundation
import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //Mark:- Properties
    
     let titlelabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "text filter"
        return label
    }()
    
    
    
//    override var isSelected: Bool {
//        didset {
//            titlelabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16 )
//                : UIFont.systemFont(ofSize: 14)
//            titlelabel.textColor = isSelected ? .twitterblue : .lightGray
//        }
//    }
    
    //Mark:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(titlelabel)
        titlelabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
