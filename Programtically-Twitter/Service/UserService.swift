//
//  UserService.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 29/09/20.
//

import Foundation
import Firebase

typealias DatabaseComplition = ((Error?, DatabaseReference)-> Void)

class UserService {
    
    static let shared = UserService()
    
    func fetchuser(uid : String, complition : @escaping(User) -> Void)  {
        
        REF_USER.child(uid).observeSingleEvent(of: .value) { snap in
            guard let dictionary = snap.value as? [String : AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            complition(user)
            
        }
        
    }
    
    func fetchuser(complition : @escaping([User]) -> Void)  {
        
        var users = [User]()
        REF_USER.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            complition(users)
            
            
        }
    }
    
    func followuser(uid : String, compiltion : @escaping(DatabaseComplition)) {
        
        guard  let currentuid = Auth.auth().currentUser?.uid else {
            return
        }
        REF_USER_FOLLOWING.child(currentuid).updateChildValues([uid : 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentuid : 1],withCompletionBlock: compiltion)
        }
        
    }
    
    func unfollowuser(uid : String, compiltion : @escaping(DatabaseComplition)) {
        
        guard  let currentuid = Auth.auth().currentUser?.uid else {
            return
        }
        REF_USER_FOLLOWING.child(currentuid).child(uid).removeValue{ (err, ref) in
            REF_USER_FOLLOWERS.child(uid).removeValue { (err, ref) in
                print("Logcat \(ref)")
            }
        }
        
    }
    
    
    func checkIfUserIsFollowed(uid : String, compiltion : @escaping(Bool) -> Void) {
        
        guard  let currentuid = Auth.auth().currentUser?.uid else {
            return
        }
        
        REF_USER_FOLLOWING.child(currentuid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print("LOGCAT : following axis \(snapshot.exists())")
            compiltion(snapshot.exists())
        }
        
    }
    
    func fetchUserStat(uid : String, complition : @escaping(userRelationStat) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                
                
                let followeing = snapshot.children.allObjects.count
                
                let stat = userRelationStat(followers: followers, following: followeing)
                complition(stat)
                
            }
        }
        
    }
    
    func fetchUser(withusername username : String, complition : @escaping (User) -> Void)  {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let uid = snapshot.value as? String else { return }
            self.fetchuser(uid: uid,complition: complition)
        }
    }
}
