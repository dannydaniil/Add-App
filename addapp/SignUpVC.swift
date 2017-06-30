//
//  SignUpVC.swift
//  addapp
//
//  Created by Danny Daniil on 6/26/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit
import CoreData


class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profilePicture: RoundImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var workNumberTextField: UITextField!
    @IBOutlet weak var LinkedInTextField: UITextField!
    @IBOutlet weak var SnapchatTextField: UITextField!
    @IBOutlet weak var InstagramTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var TwitterTextField: UITextField!

    //user can pick image
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataService.instance.isRegisteredUser() {
            fillForms()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //photo picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // photo picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicture.image = selectedPhoto
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickProfilePicture(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true, completion: nil)
    }
 
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        //create entity to be saved
        
        var user: User!
        
        if DataService.instance.isRegisteredUser() {
            user = DataService.instance.fetchUserData()
        } else {
            user = User(context: context)
        }
        let accounts = Accounts(context: context)
     
        //save the attributes
        if let firstName = firstNameTextField.text {
            user.firstName = firstName
            user.isRegistered = true
        }
        
        if let lastName = lastNameTextField.text {
            user.lastName = lastName
        }
        
        if let mobileNumber = mobileNumberTextField.text {
            user.mobileNumber = mobileNumber
            if mobileNumber.characters.count > 0 {
                accounts.mobileNumber = true
            }
        }
        
        if let workNumber = workNumberTextField.text {
            user.workNumber = workNumber
            if workNumber.characters.count > 0 {
                accounts.workNumber = true
            }
        }
        
        if let email = emailTextField.text {
            user.email = email
            if email.characters.count > 0 {
                accounts.email = true
            }
        }
        
        if let facebookUsername = facebookTextField.text {
            user.facebook = facebookUsername
            if facebookUsername.characters.count > 0 {
                accounts.facebook = true
            }
        }
        
        if let snapchatUsername = SnapchatTextField.text {
            user.snapchat = snapchatUsername
            if snapchatUsername.characters.count > 0 {
                accounts.snapchat = true
            }
        }
        
        if let instagramUsername = InstagramTextField.text {
            user.instagram = instagramUsername
            if instagramUsername.characters.count > 0 {
                accounts.instagram = true
            }
        }
        
        if let linkedInUsername = LinkedInTextField.text {
            user.linkedin = linkedInUsername
            if linkedInUsername.characters.count > 0 {
                accounts.linkedin = true
            }
        }
        
        if let twitterUsername = TwitterTextField.text {
            user.twitter = twitterUsername
            if twitterUsername.characters.count > 0 {
                accounts.twitter = true
            }
        }
        
        if let selectedProfilePic = profilePicture.image {
            user.profilePicture = UIImagePNGRepresentation(selectedProfilePic) as NSData?
//            
//            let png = UIImagePNGRepresentation(selectedProfilePic) as NSData?
//            let imageStr = png?.base64EncodedString(options: .lineLength64Characters)
//            
//            user.profilePicture = imageStr
        }
    
        ad.saveContext()
        //performSegue(withIdentifier: "HomeVC", sender: nil)
        dismiss(animated: true, completion: nil)
     }
    
    func fillForms() {
        let user = DataService.instance.fetchUserData()
        
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        mobileNumberTextField.text = user.mobileNumber
        workNumberTextField.text = user.workNumber
        emailTextField.text = user.email
        facebookTextField.text = user.facebook
        InstagramTextField.text = user.instagram
        TwitterTextField.text = user.twitter
        LinkedInTextField.text = user.linkedin
        profilePicture.image = UIImage(data: (user.profilePicture as! NSData) as Data)
 
    }
    
}
