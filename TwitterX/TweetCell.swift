//
//  TweetCell.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

protocol TweetCellActionDelegate {
    // Bool value is always true :3
    func didClickReplyInTweetCell(cell:TweetCell)
    func didClickRetweetInTweetCell(cell:TweetCell)
    func didClickLikeInTweetCell(cell:TweetCell)
}

class TweetCell: UITableViewCell {

    // View outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var actionStringLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    
    @IBOutlet weak var actionViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: TweetCellActionDelegate?
    
    // Data
    var tweet:Tweet! {
        didSet {
            self.tweetMessageLabel.text = self.tweet.text
            self.retweetCountLabel.text = self.tweet.reTweetCount > 0 ? "\(self.tweet.reTweetCount)": ""
            self.likeCountLabel.text = self.tweet.favouriteCount > 0 ? "\(self.tweet.favouriteCount)": ""
            self.createdLabel.text = NSDate().stringDifferentFrom(self.tweet.timeStamp!)
            self.bindActionData()
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 8
    }

    @IBAction func replyButtonClicked(sender: UIButton) {
        self.delegate?.didClickReplyInTweetCell(self)
    }
    
    @IBAction func retweetButtonClicked(sender: UIButton) {
        self.delegate?.didClickRetweetInTweetCell(self)
    }
    
    @IBAction func likeButtonClicked(sender: UIButton) {
        self.delegate?.didClickLikeInTweetCell(self)
    }
    
    func bindUserData(user:User) {
        if let profileImageUrl = user.profileImageURL {
            self.profileImageView.setImageWithURL(profileImageUrl)
        }
        if let name = user.name {
            self.nameLabel.text = name
        }
        if let handle = user.screenName {
            self.handleNameLabel.text = "@\(handle)"
        }
    }
    
    func bindActionData() {
        self.actionViewHeightConstraint.constant = 0
        if let replyTo = self.tweet.inReplyToHandle {
            self.actionImageView.image = UIImage(named: "reply")
            self.actionStringLabel.text = "In reply to @\(replyTo)"
            self.actionViewHeightConstraint.constant = 24
        } else if self.tweet.retweeted {
            self.actionImageView.image = UIImage(named: "retweet-off")
            self.actionStringLabel.text = "You Retweeted"
            self.actionViewHeightConstraint.constant = 24
        }
    }
}
