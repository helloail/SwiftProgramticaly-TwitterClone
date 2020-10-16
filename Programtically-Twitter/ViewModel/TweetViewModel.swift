//
//  TweetViewModel.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 06/10/20.
//

import Foundation
import UIKit

struct TweetViewModel {
    let tweet : Tweet
    let user : User
    
    init(tweet : Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    var profileimage : URL?  {
        return URL(string: user.profileImageUrl)
    }
    
    var labeltimestamp : String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
        
    }
    
    var username : String {
        return "@\(user.username)"
    }
    
    var headerTtimestamp : String {
        let formater = DateFormatter()
        formater.dateFormat = "h:m a - MM/dd/yyyy"
        return formater.string(from: tweet.timestamp)
    }
    var retweetAtributtedString : NSAttributedString? {
        return attributeText(withvalue: tweet.retweetcount, text: "Retweet")
    }
    
    var liketributtedString : NSAttributedString? {
        
        return attributeText(withvalue: tweet.likes, text: "Likes")
    }
    
    var userinfotext : NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " • \(labeltimestamp)", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        
        return title
    }
    
    
    private func attributeText(withvalue value : Int, text : String) -> NSAttributedString{
        
        let attributedtitle = NSMutableAttributedString(string: "\(value)", attributes:[.font : UIFont.boldSystemFont(ofSize: 14)] )

        attributedtitle.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        
        return attributedtitle
        
    }
    
    func size ( forWidth width : CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
    
}
