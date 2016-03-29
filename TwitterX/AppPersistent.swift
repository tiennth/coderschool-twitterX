//
//  AppPersistent.swift
//  Twitter
//
//  Created by Tien on 3/27/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import Foundation

let kUserDataKey = "UserData"
extension NSUserDefaults {
    func saveCurrentUser(user:User?) {
        if let user = user {
            let data = try! NSJSONSerialization.dataWithJSONObject(user.originalJson!, options: [])
            self.setObject(data, forKey: kUserDataKey)
        } else {
            self.setObject(nil, forKey: kUserDataKey)
        }
    
        self.synchronize()
    }
    
    func currentUser() -> User? {
        var user: User? = nil
        let data = self.objectForKey(kUserDataKey) as? NSData
        if let data = data {
            let json = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            user = User(json: json)
        }
        return user
    }
}