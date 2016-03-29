//
//  User.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class User: NSObject {
    var originalJson:NSDictionary?
    var userId: Int?
    var name:String?
    var profileImageURL:NSURL?
    var screenName:String?
    var followerCount:Int = 0
    var followingCount:Int = 0
    var desc:String?
    var location:String?
    
    static var currentUser: User? {
        set(user) {
            NSUserDefaults.standardUserDefaults().saveCurrentUser(user)
        }
        
        get {
            return NSUserDefaults.standardUserDefaults().currentUser()
        }
    }
    
    init(json:NSDictionary) {
        originalJson = json
        userId = json["id"] as? Int
        name = json["name"] as? String
        if let profileImageUrlString = json["profile_image_url"] as? String {
            profileImageURL = NSURL(string: profileImageUrlString)
        }
        screenName = json["screen_name"] as? String
        followerCount = json["followers_count"] as? Int ?? 0
        followingCount = json["friends_count"] as? Int ?? 0
        desc = json["description"] as? String
        location = json["location"] as? String
    }
}
