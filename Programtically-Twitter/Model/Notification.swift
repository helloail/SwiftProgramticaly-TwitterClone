//
//  Notification.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 18/10/20.
//

import Foundation

enum notificationType : Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID : String?
    var timestamp : Date!
    var user : User
    var type : notificationType!
    
    
    init (user : User ,  dictionary: [String : AnyObject]) {
        self.user = user
        
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = notificationType(rawValue: type)
        }
        
    }
    
}
