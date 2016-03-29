//
//  TweetReplyData.swift
//  Twitter
//
//  Created by Tien on 3/27/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import Foundation

struct TweetReplyData {
    var tweetId:String
    var authorScreenName:String
    var authorName:String
    
    init(tweetId: String, authorHandle:String, authorName:String) {
        self.tweetId = tweetId
        self.authorScreenName = authorHandle
        self.authorName = authorName
    }
}