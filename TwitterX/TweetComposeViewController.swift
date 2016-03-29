//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Tien on 3/26/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

let kMaxTweetLong = 140

protocol TweetComposerDelegate {
    func tweetComposerController(composer: TweetComposeViewController, didPostTweetMessage tweet:String)
}

class TweetComposeViewController: UIViewController {
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    @IBOutlet weak var tweetView: UIView!
    @IBOutlet weak var tweetViewCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var remainingCharacterLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var actionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionTextLabel: UILabel!
    
    var delegate: TweetComposerDelegate?
    var replyToTweetData: TweetReplyData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetComposeViewController.onBackgroundTap(_:)))
        self.transparentBackgroundView.addGestureRecognizer(tapGesture)
        
        
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 6
        self.tweetTextView.becomeFirstResponder()
        
        if let _ = replyToTweetData {
            actionViewHeightConstraint.constant = 18
        } else {
            actionViewHeightConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
        
        if let replyToTweetData = replyToTweetData {
            actionTextLabel.text = "In reply to \(replyToTweetData.authorName)"
            self.tweetTextView.text = "@\(replyToTweetData.authorScreenName) "
        }
        
        self.bindUserData()
        self.updateTweetButtonWithCharacterCount(self.tweetTextView.text.characters.count)
        self.updateRemainingCharacterCountLabelWithRemainingCount(kMaxTweetLong - self.tweetTextView.text.characters.count)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TweetComposeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TweetComposeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardSizeValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardSizeValue.CGRectValue().size
        let animDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animCurveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(animDurationValue.doubleValue,
                                   delay: 0,
                                   options: UIViewAnimationOptions(rawValue: UInt(animCurveValue.integerValue << 16)),
                                   animations: {
                                    self.tweetViewCenterYConstraint.constant = -(keyboardSize.height - self.tweetView.frame.size.height/2)
                                    self.view.layoutIfNeeded()
            },
                                   completion: nil
        )
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let animDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animCurveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(animDurationValue.doubleValue,
                                   delay: 0,
                                   options: UIViewAnimationOptions(rawValue: UInt(animCurveValue.integerValue << 16)),
                                   animations: {
                                    self.tweetViewCenterYConstraint.constant = 0
                                    self.view.layoutIfNeeded()
            },
                                   completion: nil
        )
    }
    
    func onBackgroundTap(sender: UIView) {
        self.tweetTextView.resignFirstResponder()
    }
    
    @IBAction func buttonCancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buttonTweetClicked(sender: UIButton) {
        var replyToTweetId:String? = nil
        if let replyToTweetData = replyToTweetData {
            replyToTweetId = replyToTweetData.tweetId
        } 
        TwitterClient.sharedClient.newSimpleTweet(self.tweetTextView.text!, inReplyToTweet: replyToTweetId, success: {
            self.delegate?.tweetComposerController(self, didPostTweetMessage: self.tweetTextView.text!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func bindUserData() {
        let user = User.currentUser!
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
    
    func updateTweetButtonWithCharacterCount(count:Int) {
        if count == 0 || count > 140 {
            self.tweetButton.enabled = false
        } else {
            self.tweetButton.enabled = true
        }
        
        if self.tweetButton.enabled {
            self.tweetButton.backgroundColor = UIColor.colorWithHex(0x58AFF0)
            self.tweetButton.alpha = 1
        } else {
            self.tweetButton.backgroundColor = UIColor.colorWithHex(0x1b95e0)
            self.tweetButton.alpha = 0.2
        }
        
    }
    
    func updateRemainingCharacterCountLabelWithRemainingCount(remainingCount:Int) {
        self.remainingCharacterLabel.text = "\(remainingCount)"
        if remainingCount < 10 {
            self.remainingCharacterLabel.textColor = UIColor.colorWithHex(0xd40d12)
        } else if remainingCount <= 20 {
            self.remainingCharacterLabel.textColor = UIColor.colorWithHex(0x5c0002)
        } else {
            self.remainingCharacterLabel.textColor = UIColor.colorWithHex(0x8899A6)
        }
    }
}

extension TweetComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let characterCount = textView.text.characters.count
        let remainingCharacterCount = kMaxTweetLong - characterCount
        self.updateRemainingCharacterCountLabelWithRemainingCount(remainingCharacterCount)
        self.updateTweetButtonWithCharacterCount(characterCount)
    }
    
    
}
