//
//  ProfileHeaderViewModel.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 12/10/20.
//

import Foundation
import UIKit


struct ProfileHeaderViewModel {
    
    private let user : User
    
    let usernametext : String
    let fullnametext : String
    
    
    var followersString : NSAttributedString {
        return attributeText(withvalue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString : NSAttributedString {
        
        return attributeText(withvalue: user.stats?.following ?? 0, text: "following")
        
    }
    
    var actionbuttontittle : String {
        if user.isCurretUser {
            return "edit profile"
        }
        
        if !user.isFollowed && !user.isCurretUser{
            return "Following"
        }
        
        if user.isFollowed {
            return "Follow"
        }
        return "Loading"
    }
    
    init(user : User) {
        self.user = user
        self.usernametext = "@\(user.username)"
        
        self.fullnametext = "@\(user.fullname)"
    }
    
    private func attributeText(withvalue value : Int, text : String) -> NSAttributedString{
        
        let attributedtitle = NSMutableAttributedString(string: "\(value)", attributes:[.font : UIFont.boldSystemFont(ofSize: 14)] )
        
        
        attributedtitle.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        
        return attributedtitle
        
    }
    
    
    
}
