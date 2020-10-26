//
//  NotificationViewModel.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 18/10/20.
//

import UIKit
struct NotificationViewModel {
    private let notification : Notification
    
    private let type : notificationType
    private let user : User
    
    var timestampstring : String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
        
    }
    
    var notificationmessage : String {
        switch type {
        
        case .follow:
            return "stated follow"
        case .like:
            
            return "stated like"
        case .reply:
            
            return "stated reply"
        case .retweet:
            
            return "stated retweet"
        case .mention:
            
            return "stated mention"
        }
    }
    
    var followbuttontextt : String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var shouldHideFollowButton : Bool {
        return type != .follow
    }
    
    var notificationText : NSAttributedString? {
        guard let timestamp = timestampstring else { return nil }
        
        let attributedtitle = NSMutableAttributedString(string: user.username, attributes:[.font : UIFont.boldSystemFont(ofSize: 12)] )
        
        
        attributedtitle.append(NSAttributedString(string: notificationmessage, attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        

        attributedtitle.append(NSAttributedString(string: timestamp, attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        
        return attributedtitle
    }
    
     var profileimage : URL? {
        guard let urlimage = URL(string: user.profileImageUrl) else {
            return nil
        }
        return urlimage
    }
    
    init(notification : Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
