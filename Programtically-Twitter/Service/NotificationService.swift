//
//  NotificationService.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 18/10/20.
//

import Foundation
import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type : notificationType,
                            tweet : Tweet? = nil,
                            user : User? =  nil){
        print("LOGCAT : notification debug \(type)")
        guard let uid = Auth.auth().currentUser?.uid  else {
            return
        }
        
        var values: [String : Any] = [ "timestamp" : Int(NSDate().timeIntervalSince1970),
                                       "uid" : uid,
                                       "type": type.rawValue]
//
        if let tweet =  tweet{
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        }else if let user = user{
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    
    func fetchNotification(completion : @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid  else {
            return
        }
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchuser(uid: uid) { (user) in
                let notification = Notification.init(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
