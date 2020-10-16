//
//  UserCell.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 13/10/20.
//

import Foundation
import UIKit


//tanya cell id iru berarti nama class cell nya ya
class UserCell: UITableViewCell {
    
    //Mark : - properties
    var user : User? {
        didSet{
            configure()
        }
    }
    
    
    private lazy var profileimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
    
        return iv
    }()
    
    private let usernamelabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "test caption"
        return  label
    }()
    private let fullnamelabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "test caption"
        return  label
    }()
    
    //Mark : - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(profileimageview)
        profileimageview.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernamelabel,fullnamelabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: profileimageview.rightAnchor, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //Mark : - Helper
    
    func configure() {
        guard let user = user else {
            return
        }
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        
        profileimageview.sd_setImage(with: url)
        usernamelabel.text = user.username
        fullnamelabel.text = user.fullname
    }
}
