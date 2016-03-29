//
//  Tweet.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    private static var dateFormatter = NSDateFormatter()
    var tweetId:String?
    var text: String?
    var timeStamp: NSDate?
    var reTweetCount: Int = 0
    var favouriteCount: Int = 0
    var user: User?
    
    var inReplyToHandle:String?
    var retweeted:Bool = false
    var favorited:Bool = false
    
    init(json: NSDictionary) {
        tweetId = json["id_str"] as? String
        text = json["text"] as? String
        if let timeStampString = json["created_at"] as? String {
            // Tue Aug 28 21:08:15 +0000 2012
            Tweet.dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            Tweet.dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            timeStamp = Tweet.dateFormatter.dateFromString(timeStampString)
        }
        if let userDic = json["user"] as? NSDictionary {
            user = User(json: userDic)
        }
        
        inReplyToHandle = json["in_reply_to_screen_name"] as? String 
        
        reTweetCount = json["retweet_count"] as? Int ?? 0
        favouriteCount = json["favorite_count"] as? Int ?? 0
        
        retweeted = json["retweeted"] as? Bool ?? false
        favorited = json["favorited"] as? Bool ?? false
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets:[Tweet] = []
        for dictionary in dictionaries {
            let tweet = Tweet(json: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
