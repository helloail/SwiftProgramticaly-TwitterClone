//
//  NotificationCell.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 18/10/20.
//

import UIKit
import Foundation

protocol NotificationCellDelegate : class {
    func didTapProfileImage(_ cell : NotificationCell)
    func didTapFollow(_ cell : NotificationCell)
}

class NotificationCell: UITableViewCell {
    //Mark :- Properties
    var notification : Notification? {
        didSet{
            configure()
        }
    }
    
    weak var delegate : NotificationCellDelegate?
    
    //Mark :- Lifestyle
    private lazy var profileimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private lazy var followbutton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading ...", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
        
    }()
    
    private let notificationlabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return  label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileimageview,notificationlabel])
        stack.spacing = 8
        addSubview(stack)
        
        stack.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 8)
        stack.anchor(right : rightAnchor,paddingRight: 8)
        
        addSubview(followbutton)
        followbutton.centerY(inView: self)
        followbutton.setDimensions(width: 100, height: 32)
        followbutton.layer.cornerRadius = 32/2
        followbutton.anchor(right : rightAnchor, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark: - Selector
    
    @objc func handlerProfileImageTapped(){
        delegate?.didTapProfileImage(self)
        
        print("LOGCAT : tapped")
        
    }
    
    @objc func handleFollowTapped(){
        delegate?.didTapFollow(self)
        print("LOGCAT : handleFollowTapped")
    }
    
    
    //Mark:- helper
    
    func configure(){
        guard let notification = notification else {
            return
        }
        
        let viewmodel = NotificationViewModel(notification: notification)
        profileimageview.sd_setImage(with: viewmodel.profileimage)
        notificationlabel.attributedText  = viewmodel.notificationText
        followbutton.isHidden = viewmodel.shouldHideFollowButton
        followbutton.setTitle(viewmodel.followbuttontextt, for: .normal)
    }
    
}
