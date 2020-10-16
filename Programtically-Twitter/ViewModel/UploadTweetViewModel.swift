//
//  UploadTweetViewModel.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 16/10/20.
//

import UIKit

enum UploadTwetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtontittle : String
    let placeholdertext : String
    var shouldShowReplyLabel : Bool
    var replytext : String?
    init(config : UploadTwetConfiguration) {
        switch config {
        case .tweet:
            actionButtontittle = "Tweet"
            placeholdertext = "What's Happening"
            shouldShowReplyLabel = false
            
        case .reply(let tweet):
            
            actionButtontittle = "Reply"
            placeholdertext = "Tweet your reply"
            shouldShowReplyLabel = true
            replytext = "reply to @\(tweet.user.username)"
        }
    }
}
