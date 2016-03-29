//
//  LoginViewController.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var batImageView: UIImageView!
    var tapOnBatGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LoginViewController.batImageViewLongClicked))
//        longPressGesture.minimumPressDuration = 1
        tapOnBatGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.batImageViewLongClicked))
        self.batImageView.addGestureRecognizer(tapOnBatGesture)
        
    }
    
    func batImageViewLongClicked() {
        self.batImageView.removeGestureRecognizer(tapOnBatGesture)
        
        TwitterClient.sharedClient.loginWithSuccess({
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error) in
            self.onLoginFailure(error)
        }
    }
    
    func onLoginFailure(error: NSError) {
        
    }
}
