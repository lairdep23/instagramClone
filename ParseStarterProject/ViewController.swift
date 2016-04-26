/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

// Put in terminal to get parse dashboard "parse-dashboard --appId instagramclone24 --masterKey 242424242424 --serverURL "http://instagramclone24.herokuapp.com/parse" --appName instagramclone24"

class ViewController: UIViewController {
    
  
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var registeredText: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signupActive = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
   
    @IBAction func signup(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Sign Up Failed", message: "Please enter a username and password")
            
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later."
            
            if signupActive == true {
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            
            
            user.signUpInBackgroundWithBlock({ (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                    
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                    }
                    self.displayAlert("Failed Sign Up", message: errorMessage)
                }
            })
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text! , block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        self.displayAlert("Failed Login", message: errorMessage)
                    }
                })
                
            }
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            
            registeredText.text = "Not registered?"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already registered?"
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    
    
}
