//
//  LoginViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/7/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = "TEMPUSERNAME"
        passwordTextField.text = "TEMPPASSWORD"
        
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if
            let username = usernameTextField.text,
            let password = passwordTextField.text
        {
            MovieDatabaseAuthenticator.sharedAuthenticator.validateLogin(username, password: password, completion: { (success) -> Void in
                
                if success {
                    
                    let navigationController = UINavigationController()
                    let homeViewController = HomeViewController()
                    navigationController.viewControllers = [homeViewController]
                    self.presentViewController(navigationController, animated: true, completion: nil)
                
                } else {
                    
                    let alert = UIAlertController(title: "Come on!", message: "Something went wrong with your login. Learn to type!", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "I'll try...", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                        
                        alert.dismissViewControllerAnimated(false, completion: nil)
                    })
                    
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
