//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Tien on 3/26/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var newReplyTextField: UITextField!
    @IBOutlet weak var sendReplyButton: UIButton!
    
    let dateFormatter = NSDateFormatter()
    var tweet:Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "h:mm a dd MMM yy"
        self.title = "Tweet"
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 8
        
        self.bindTweetDetail()
    }
    
    @IBAction func replyButtonClicked(sender: UIButton) {
        let replyData = TweetReplyData(tweetId: tweet.tweetId!, authorHandle: tweet.user!.screenName!, authorName: tweet.user!.name!)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let composer = sb.instantiateViewControllerWithIdentifier("TweetComposerVC")
            as! TweetComposeViewController
//        composer.delegate = self
        composer.replyToTweetData = replyData
        composer.modalPresentationStyle = .OverCurrentContext
        composer.modalTransitionStyle = .CrossDissolve
        self.presentViewController(composer, animated: true, completion: nil)
    }
    
    @IBAction func retweetButtonClicked(sender: UIButton) {
        if (tweet.retweeted) {
            TwitterClient.sharedClient.retweet(tweet.tweetId!, success: nil, failure: nil)
            tweet.reTweetCount -= 1
        } else {
            TwitterClient.sharedClient.retweet(tweet.tweetId!, success: nil, failure: nil)
            tweet.reTweetCount += 1
        }
        tweet.retweeted = !tweet.retweeted
        
        self.bindTweetDetail()
    }
    
    @IBAction func likeButtonClicked(sender: UIButton) {
        if (tweet.favorited) {
            TwitterClient.sharedClient.unlikeTweet(tweet.tweetId!, success: nil, failure: nil)
            tweet.favouriteCount -= 1
        } else {
            TwitterClient.sharedClient.likeTweet(tweet.tweetId!, success: nil, failure: nil)
            tweet.favouriteCount += 1
        }
        tweet.favorited = !tweet.favorited
        
        self.bindTweetDetail()
    }

    @IBAction func shareButtonClciked(sender: UIButton) {
    }
    
    func bindTweetDetail() {
        self.textLabel.text = self.tweet.text
        self.timestampLabel.text = dateFormatter.stringFromDate(self.tweet.timeStamp!)
        if let user = self.tweet.user {
            self.bindUserData(user)
        }
        // Action buttons
        if self.tweet.retweeted {
            self.retweetButton.setImage(UIImage(named: "retweet-on"), forState: .Normal)
            self.retweetButton.setImage(UIImage(named: "retweet-on-pressed"), forState: .Highlighted)
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-off"), forState: .Normal)
            self.retweetButton.setImage(UIImage(named: "retweet-off-pressed"), forState: .Highlighted)
        }
        
        if self.tweet.favorited {
            self.likeButton.setImage(UIImage(named: "like-on"), forState: .Normal)
            self.likeButton.setImage(UIImage(named: "like-on-pressed"), forState: .Highlighted)
        } else {
            self.likeButton.setImage(UIImage(named: "like-off"), forState: .Normal)
            self.likeButton.setImage(UIImage(named: "like-off-pressed"), forState: .Highlighted)
        }
        
        self.retweetButton.enabled = true
        if let userId = self.tweet.user?.userId {
            if userId == User.currentUser?.userId! {
                self.retweetButton.enabled = false
            }
        }
    }
    
    func bindUserData(user:User) {
        if let profileImageUrl = user.profileImageURL {
            self.profileImageView.setImageWithURL(profileImageUrl)
        }
        if let name = user.name {
            self.nameLabel.text = name
        }
        if let handle = user.screenName {
            self.handleLabel.text = "@\(handle)"
        }
    }
}
