//
//  User.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 29/09/20.
//

import Foundation
import Firebase

struct User {
    let fullname : String
    let email : String
    let username : String
    let profileImageUrl : String
    let uid : String
    var isFollowed = false
    var stats : userRelationStat?
    
    
    var isCurretUser : Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    
    init (uid : String, dictionary : [String : AnyObject]){
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileimageurl"] as? String ?? ""

    }
}

struct userRelationStat {
    var followers : Int
    var following  : Int
    
}
