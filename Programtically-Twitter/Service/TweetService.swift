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
        guard let currentuid = Auth.auth().currentUser?.uid  else {
            return
        }
        
        REF_USER_FOLLOWING.child(currentuid).observe(.childAdded) { (snapshot) in
            let followinguid = snapshot.key
            
            REF_USER_TWEETS.child(followinguid).observe(.childAdded) { (snapshot) in
                let tweetid = snapshot.key
                self.fetchtweet(withTweetID: tweetid) { tweet in
                    tweets.append(tweet)
                    
                    complition(tweets)
                }
            }
            
            
        }
        REF_USER_TWEETS.child(currentuid).observe(.childAdded) { (snapshot) in
            let tweetid = snapshot.key
            self.fetchtweet(withTweetID: tweetid) { tweet in
                tweets.append(tweet)
                
                complition(tweets)
            }
        }
        
    }
    
    
    func fetchtweet(forUser user : User, complition : @escaping([Tweet]) -> Void ) {
        var tweets = [Tweet]()
        
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            
            let tweetid = snapshot.key
            self.fetchtweet(withTweetID: tweetid) { (tweet) in
                tweets.append(tweet)
                complition(tweets)
            }
        }
    }
    
    
    func fetchtweet(withTweetID tweetID : String, complition: @escaping(Tweet) -> Void) {
        REF_TWEET.child(tweetID).observeSingleEvent(of: .value){ snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchuser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                complition(tweet)
                
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
    
    func liketweet(tweet : Tweet, complition : @escaping (DatabaseComplition)) {
        let likes = tweet.didlike ? tweet.likes - 1 : tweet.likes + 1
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        REF_TWEET_REPLIES.child(tweet.tweetID).setValue(likes)
        
        
        if tweet.didlike {
            REF_USER_LIKE.child(uid).child(tweet.tweetID).removeValue { (err, ref) in
                REF_TWEET_LIKE.child(tweet.tweetID).removeValue(completionBlock: complition)
            }
        }else {
            REF_USER_LIKE.child(uid).updateChildValues([tweet.tweetID : 1]){ (err, ref) in
                REF_TWEET_LIKE.child(tweet.tweetID).updateChildValues([uid : 1], withCompletionBlock: complition)
            }
        }
    }
    
    func chckIFUserLikedTweettweet (_ tweet: Tweet, complition : @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        REF_USER_LIKE.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value){ snapshot in
            complition(snapshot.exists())
        }
    }
}
