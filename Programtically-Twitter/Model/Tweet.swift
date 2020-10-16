//
//  Tweet.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 04/10/20.
//

import Foundation


struct Tweet {
    let caption : String
    let tweetID : String
    let uid : String
    let likes : Int
    var timestamp : Date!
    let retweetcount : Int
    let user : User
    
    init (user : User,tweetID : String, dictionary : [String : Any]){
        self.tweetID = tweetID
        self.user = user 
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetcount = dictionary["retweetcount"] as? Int ?? 0
        
        
        if let timestamp = dictionary["timestamp"] as? Double  {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        

    }
}
