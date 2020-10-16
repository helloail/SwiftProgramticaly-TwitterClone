//
//  Constant.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 28/09/20.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USER = DB_REF.child("users")
let REF_TWEET =  DB_REF.child("tweet")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGE = STORAGE_REF.child("profile_image")

let REF_USER_TWEETS = DB_REF.child("user-tweets")

let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")

let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
