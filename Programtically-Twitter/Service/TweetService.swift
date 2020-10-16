//
//  TweetService.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 03/10/20.
//

import Foundation
import Firebase

class TweetService {
    static let shared = TweetService()
    
    func uploadtweet(caption : String, type : UploadTwetConfiguration, complition : @escaping ( Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid  else {
            return
        }
        
        let value = ["uid" : uid,
                     "timestamp" : Int(NSDate().timeIntervalSince1970),
                     "likes": 0,
                     "retweet" : 0,
                     "caption" : caption] as [String : Any]
        
        switch type {
        case .reply(let tweet):
            
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(value, withCompletionBlock: complition)
        case .tweet:
            
            REF_TWEET.childByAutoId().updateChildValues(value) { (err, ref) in
                guard let tweetID = ref.key else { return }
                
                REF_USER_TWEETS.child(uid).updateChildValues ([tweetID : 1], withCompletionBlock: complition)
            }
        }
        
    }
    
    func fetchtweet(complition : @escaping([Tweet]) -> Void ) {
        var tweets = [Tweet]()
        
        
        REF_TWEET.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetid = snapshot.key
            
            UserService.shared.fetchuser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetid, dictionary: dictionary)
                tweets.append(tweet)
                
                complition(tweets)
                
            }
        }
    }
    
    
    func fetchtweet(forUser user : User, complition : @escaping([Tweet]) -> Void ) {
        var tweets = [Tweet]()
        
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            
            let tweetid = snapshot.key
            
            
            REF_TWEET.child(tweetid).observeSingleEvent(of: .value){ snapshot in
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchuser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetid, dictionary: dictionary)
                    tweets.append(tweet)
                    
                    complition(tweets)
                    
                }
            }
        }
    }
    
    func fetchreplies(fortweet tweet : Tweet, complition : @escaping([Tweet])-> Void) {
        var tweets =  [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded){ snapshot in
            
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetid = snapshot.key
            
            
            UserService.shared.fetchuser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetid, dictionary: dictionary)
                tweets.append(tweet)
                
                complition(tweets)
                
            }
        }
    }
    
}
