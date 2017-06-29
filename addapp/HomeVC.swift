//
//  HomeVC.swift
//  addapp
//
//  Created by Danny Daniil on 6/23/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit
import CoreImage
import BarcodeScanner
import Contacts
import CoreData

class HomeVC: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePic: RoundImageView!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var settingsBtn: UIButton!
    var qrcodeImage: CIImage!
    var encodedText: String!
    //must tell it what it will work with
    var userController: NSFetchedResultsController<User>!
    var accountsController: NSFetchedResultsController<Accounts>!
    var user: User?
    var accounts: Accounts?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if DataService.instance.isRegisteredUser() == false {
            performSegue(withIdentifier: "SignUpVC", sender: self)
        } else {
            user = DataService.instance.fetchUserData()
            accounts = DataService.instance.fetchAccountsData()
            
            //present barcode
            presentQRBarcode()
            
            //present name
            nameLbl.text = (user?.firstName)! + " " + (user?.lastName)!
            
            //present picture
            profilePic.image = UIImage(data: (user?.profilePicture as! NSData) as Data)
        }
    }
    
    
    // TODO:
    
    @IBAction func swipeRight(_ sender: Any) {
        
        //present the scanner
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    //3 scanner functions to be changed
    
    //handles identified QR Barcode
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        
        print(code)
        decryptScannedCode(encryptedCode: code)
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
    
    func decryptScannedCode(encryptedCode: String) {
        createContact(dic: stringToDictionary(text: encryptedCode)!)
    }
    
    //deals with error
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
    
    //dismisses view controller
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        dismiss(animated: true, completion: nil)
    }

    //handle QR code generation and presentation on screen
    func presentQRBarcode() {
            
        var dict = Dictionary<String, AnyObject>()
        dict["first"] = user?.firstName as AnyObject
        dict["last"] = user?.lastName as AnyObject
//      dict["picture"] = user?.profilePicture
            
        for key in (accounts?.entity.attributesByName.keys)! {
            if let value = accounts?.value(forKey: key) as! Bool? {
                if value {
                    dict[key] = user?.value(forKeyPath: key) as AnyObject
                } else {
                    dict[key] = "" as AnyObject
                }
            }
        }
            
        //text to be encoded
        encodedText = dictionaryToString(dict: dict)
        print(encodedText)
        if  encodedText == "" {
            return
        }
            
        // encode data
        let data = encodedText.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        imgQRCode.image = convert(cmage: qrcodeImage)
            
        //display encoded data as QR barcode
        displayQRCodeImage()
    }
    
    //scale image to remove blur, barcode still works
    func displayQRCodeImage() {
        
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        imgQRCode.image = convert(cmage: transformedImage)
    }
    
    //adds new contact to the contact book
    func createContact(dic: Dictionary<String,String>) {
        // Creating a new contact
        let newContact = CNMutableContact()
        newContact.givenName = dic["first"]!
        newContact.familyName = dic["last"]!
        let workPhone = CNLabeledValue(label: CNLabelWork, value:CNPhoneNumber(stringValue: dic["workNumber"]!))
        newContact.phoneNumbers = [workPhone]
        let mobilePhone = CNLabeledValue(label: CNLabelOther, value:CNPhoneNumber(stringValue: dic["mobileNumber"]!))
        newContact.phoneNumbers = [mobilePhone]
        //let email = CNLabeledValue(label: CNLabelWork, value: dic["email"]! as NSSecureCoding)
        //newContact.emailAddresses = [email]
        
        
        // Saving contact
        let saveRequest = CNSaveRequest()
        let store = CNContactStore()
        
        saveRequest.add(newContact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "swipeDown", sender: self)
    }
    
    @IBAction func settingsBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SignUpVC", sender: self)
    }
} //end of class

func dictionaryToString(dict: Dictionary<String, AnyObject>) -> String {
    var datastring = String()
    
    do {
        let thisJSON = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        datastring = String(data: thisJSON, encoding: String.Encoding.utf8)!
    } catch {
        print(error)
    }

    return datastring
}

func stringToDictionary(text: String) -> [String: String]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

//convert from CIImage to UIImage
func convert(cmage:CIImage) -> UIImage {
    let context:CIContext = CIContext.init(options: nil)
    let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
    let image:UIImage = UIImage.init(cgImage: cgImage)
    return image
}

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}



