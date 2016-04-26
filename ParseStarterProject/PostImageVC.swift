//
//  PostImageVC.swift
//  InstagramClone
//
//  Created by Evan on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var message: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image.clipsToBounds = true


        
    }

    @IBAction func chooseImage(sender: AnyObject) {
        
        var images = UIImagePickerController()
        images.delegate = self
        images.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        images.allowsEditing = false
        
        
        self.presentViewController(images, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.image.image = image
        
        
    }
    
    @IBAction func postImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()?.objectId
        
        if self.image.image != UIImage(named: "Blank") {
        
        let imageData = UIImagePNGRepresentation(image.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted", message: "Image has been posted successfully")
                
                self.image.image = UIImage(named: "Blank")
                self.message.text = ""
            } else {
                
                self.displayAlert("Image post failed", message: "Please try again")
            }
        }
        
        
        } else {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            displayAlert("Choose an Image", message: "Must have an image to post")
            
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }


}
