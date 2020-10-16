//
//  ProfileHeader.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 10/10/20.
//

import Foundation
import UIKit


protocol ProfileHeaderDelegate {
    func profiledissmis()
    func handleProfileFollower(_ header : ProfileHeader)
}


class ProfileHeader : UICollectionReusableView {
    
    //Mark:- Properties
    
    var user : User? {
        didSet {
            configure()
        }
    }
    
    var delegate : ProfileHeaderDelegate?
    private let filterbar = ProfileFilterView()
    
    private lazy var containerview : UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top : view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        //tanya kenapa kok left: view.leftAnchor g bisa di kasih leading
        backButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for:  .normal)
        button.addTarget(self, action: #selector(handledissmis), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profileimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80/2
    
        return iv
    }()
    
     lazy var editprofileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36/2
        button.addTarget(self, action: #selector(HandleProfileFollower), for: .touchUpInside)
        return button
        
    }()
    
    private let fullnamelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    
    private let usernamelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let biolabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "nujshbvushvijvishudsujdhsdckosaivduhs njklcsoaivuhbnjcskoADVIJSFHUGDSIJOFHUDG"
        return label
    }()
 
    private let followinglabel: UILabel = {
        let label = UILabel()
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handlerFollowingTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "0 Following"
        return label
    }()
    
    private let followerlabel: UILabel = {
        let label = UILabel()
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handlerFollowerTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "2 Followers"
        return label
    }()
 
    
    //Mark:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerview)
        containerview.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 100)
        
        
        addSubview(profileimageview)
        profileimageview.anchor(top : containerview.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        
        addSubview(editprofileFollowButton)
        editprofileFollowButton.anchor( top : containerview.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        let userdetailstack = UIStackView(arrangedSubviews : [fullnamelabel, usernamelabel, biolabel])
        userdetailstack.axis = .vertical
        userdetailstack.distribution = .fillProportionally
        userdetailstack.spacing = 4
        
        addSubview(userdetailstack)
        userdetailstack.anchor(top : profileimageview.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let followstack = UIStackView(arrangedSubviews : [followinglabel,followerlabel])
        followstack.axis = .horizontal
        followstack.spacing = 8
        followstack.distribution = .fillEqually
        
        addSubview(followstack)
        followstack.anchor(top: userdetailstack.bottomAnchor, left: leftAnchor,paddingTop: 8, paddingLeft: 12)
        
//        addSubview(filterbar)
//        filterbar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark:- Selector
    @objc func handledissmis(){
        delegate?.profiledissmis()
    }
    
    
    @objc func HandleProfileFollower(){
        delegate?.handleProfileFollower(self)
    }
    
    
    @objc func handlerFollowerTap(){
        
    }
    
    
    @objc func handlerFollowingTap(){
        
    }
    
    
//    Mark: -  Helper
    
    func configure() {
        guard let user = user else {
            return
        }
        
        let viewmodel = ProfileHeaderViewModel(user: user)
        followerlabel.attributedText = viewmodel.followersString
        
        followinglabel.attributedText = viewmodel.followingString
        
        editprofileFollowButton.setTitle(viewmodel.actionbuttontittle, for: .normal)
        
        fullnamelabel.text = viewmodel.fullnametext
        usernamelabel.text = viewmodel.usernametext
        
        guard let url = URL(string: user.profileImageUrl) else {
            return
        }
        
        profileimageview.sd_setImage(with: url )
        
    }
}
