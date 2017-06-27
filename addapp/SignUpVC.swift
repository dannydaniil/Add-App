//
//  SignUpVC.swift
//  addapp
//
//  Created by Danny Daniil on 6/26/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit
import CoreData

class SignUpVC: UIViewController {
    
    
    var isRegisteredUser = false

    @IBOutlet weak var workNumberTextField: UITextField!
    @IBOutlet weak var LinkedInTextField: UITextField!
    @IBOutlet weak var SnapchatTextField: UITextField!
    @IBOutlet weak var InstagramTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        //create entity to be saved
         let user = User(context: context)
        
        //save the attributes
        if let firstName = firstNameTextField.text {
            user.firstName = firstName
            isRegisteredUser = true
        }
        if let lastName = lastNameTextField.text {
            user.lastName = lastName
        }
        if let mobileNumber = mobileNumberTextField.text {
            user.mobileNumber = mobileNumber
        }
        if let workNumber = workNumberTextField.text {
            user.workNumber = workNumber
        }
        if let email = emailTextField.text {
            user.email = email
        }
        if let facebookUsername = facebookTextField.text {
            user.facebookUsername = facebookUsername
        }
        if let snapchatUsername = SnapchatTextField.text {
            user.snapchatUsername = snapchatUsername
        }
        if let instagramUsername = InstagramTextField.text {
            user.instagramUsername = instagramUsername
        }
        if let linkedInUsername = LinkedInTextField.text {
            user.linkedInUsername = linkedInUsername
        }
        
        ad.saveContext()
        dismiss(animated: true, completion: nil)
    }

}
