//
//  EditProfileHeader.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 20/10/20.
//

import UIKit
 
protocol EditProfileHeaderDelegate : class {
    func didtapChangProfilePhoto()
}

class EditProfileHeader: UIView {
    
    //Mark - Properties
    
    
    private let user :  User
    weak var delegate : EditProfileHeaderDelegate?
    
     let profileImageView : UIImageView  = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3.0
        
        return iv
    }()
    
    
    private let changebuttoncolor : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo profile", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    
    init(user : User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 50 , height: 50)
        profileImageView.layer.cornerRadius = 50/2
        
        
        addSubview(changebuttoncolor)
        changebuttoncolor.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        
        profileImageView.sd_setImage(with: user.imagerURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark - Lifecycle
    
    
    //Mark - Selector
    @objc func handleChangeProfilePhoto(){
        delegate?.didtapChangProfilePhoto()
    }
    
}
