//
//  TwitterClient.swift
//  Twitter
//
//  Created by Tien on 3/23/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

let twitterBaseUrl = "https://api.twitter.com/"
let twitterConsumerKey = "IJiEwmzlsTLqy35mjUMgQqPox"
let twitterConsumerSecret = "9ju2FgfIeOWglUxMaOW6fEOLQbMYEqEB4TqUaC2ZhNXSEI21hq"

class TwitterClient: NSObject {
    private var oauthSessionManager: BDBOAuth1SessionManager!
    
    var loginSuccessClosure: (()->())?
    var loginFailureClosure: ((NSError)->())?
    
    class var sharedClient: TwitterClient {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance: TwitterClient? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TwitterClient(consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    init(consumerKey:String!, consumerSecret:String!) {
        let baseUrl = NSURL(string: twitterBaseUrl)
        oauthSessionManager = BDBOAuth1SessionManager(baseURL: baseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    // MARK: - Login/Logout
    /**
     Login then get current user. Success only if get current user success.
     
     - parameter success: block of code tend to be called when login success
     - parameter failure: block of code tend to be called when login failure
     */
    func loginWithSuccess(success: ()->(), failure: (NSError)->()) {
        loginSuccessClosure = success
        loginFailureClosure = failure
        
        oauthSessionManager.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "xxxTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let authorizeUrl = NSURL(string: "\(twitterBaseUrl)oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authorizeUrl!)
            
        }) { (error: NSError!) in
            self.loginFailureClosure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        self.oauthSessionManager.deauthorize()
    }
    
    func handleOpenUrl(url: NSURL) {
        let queryString = url.query
        let requestToken = BDBOAuth1Credential(queryString: queryString)
        oauthSessionManager.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
            
            self.currentUser({ (user: User) in
                
                self.loginSuccessClosure?()
                
                }, failure: { (error: NSError) in
                    self.loginFailureClosure?(error)
            })
            
        }) { (error: NSError!) in
            self.loginFailureClosure?(error)
        }
    }
    
    func currentUser(success: (User)->(), failure: (NSError)->()) {
        oauthSessionManager.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dic = response as! NSDictionary
            let user = User(json: dic)
            User.currentUser = user
            success(user)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("getAcccount error \(error)")
            failure(error)
        }
    }
    
    func homeTimeline(sucess:(([Tweet])->())?, failure: ((NSError)->())?) {
        oauthSessionManager.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("homeTimeline success")
            let dics = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dics)
            sucess?(tweets)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("homeTimeline error \(error)")
            failure?(error)
        }
    }
    
    func newSimpleTweet(tweet:String, inReplyToTweet tweetId:String?, success:(()->())?, failure: ((NSError)->())?) {
        var param = ["status":tweet]
        if tweetId != nil {
            param["in_reply_to_status_id"] = tweetId
        }
        
        oauthSessionManager.POST("1.1/statuses/update.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success?()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure?(error)
        }
    }
    
    // MARK: - Favorite create/destroy
    func likeTweet(tweetId:String, success:(()->())?, failure:((NSError)->())?) {
        let param = ["id":tweetId]
        oauthSessionManager.POST("1.1/favorites/create.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("Favorite success")
            success?()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Favorite failure \(error)")
            failure?(error)
        }
    }
    
    func unlikeTweet(tweetId:String, success:(()->())?, failure:((NSError)->())?) {
        let param = ["id":tweetId]
        oauthSessionManager.POST("1.1/favorites/destroy.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("Remove favorite success")
            success?()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Remove favorite failure \(error)")
            failure?(error)
        }
    }
    
    // MARK: - Retweet - Unretweet
    func retweet(tweetId:String, success:(()->())?, failure:((NSError)->())?) {
        oauthSessionManager.POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("Retweet success")
            success?()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Retweet failure \(error)")
            failure?(error)
        }
    }
    
    func unretweet(tweetId:String, success:(()->())?, failure:((NSError)->())?) {
        oauthSessionManager.POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("Unretweet success")
            success?()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Unretweet failure \(error)")
            failure?(error)
        }
    }
}
