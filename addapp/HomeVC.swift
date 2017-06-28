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
        
        if isRegisteredUser() == false {
            performSegue(withIdentifier: "SignUpVC", sender: self)
        } else {
            user = fetchUserData()
            
            nameLbl.text = (user?.firstName)! + " " + (user?.lastName)!
            profilePic.image = UIImage(data: (user?.profilePicture as! NSData) as Data)
            //createContact()
            
            accounts = fetchAccountsData()
            
            //create a data service where only fields filled by the user show up in the list
            //instantiate true for all those fields, update tableviewcell based on the bool
            //since all these values will be instantiated a qr code will all fields will be genrated automatically
            
            //call only if any switch changed
            presentQRBarcode()
        }
        
    }
    
    func fetchUserData() -> User {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let userSort = NSSortDescriptor(key: "firstName", ascending: false, selector: nil)
        
        //passing in the descriptor
        fetchRequest.sortDescriptors = [userSort]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.userController = controller
        
        //make fetch request
        do {
            try self.userController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return controller.fetchedObjects![0]
    }
    
    func isRegisteredUser() -> Bool {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let userSort = NSSortDescriptor(key: "firstName", ascending: false, selector: nil)
        
        //passing in the descriptor
        fetchRequest.sortDescriptors = [userSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.userController = controller
        
        //make fetch request
        do {
            try self.userController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        if (controller.fetchedObjects?.isEmpty)! {
            return false
        } else {
            return controller.fetchedObjects![0].isRegistered
        }
    }
    
    func fetchAccountsData() -> Accounts{
        
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        let accountsSort = NSSortDescriptor(key: "facebook", ascending: false, selector: nil)
        
        fetchRequest.sortDescriptors = [accountsSort]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.accountsController = controller
        
        //make fetch request
        do {
            try self.accountsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        if (controller.fetchedObjects?.isEmpty)! {
            return Accounts()
        }
        
        return controller.fetchedObjects![0]
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
        //print(type)
        
        decryptScannedCode(encryptedCode: code)
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
    
    func decryptScannedCode(encryptedCode: String) {
        
        //print(stringToDictionary(text: encryptedCode)!)
        //print(type(of:stringToDictionary(text: encryptedCode)!))
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
        if qrcodeImage == nil {
            
            var dict = Dictionary<String, AnyObject>()
            dict["first"] = user?.firstName as AnyObject
            dict["last"] = user?.lastName as AnyObject
//          dict["picture"] = user?.profilePicture
            
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
        } else {
            imgQRCode.image = nil
            qrcodeImage = nil
        }
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
        newContact.givenName = dic["firstName"]!
        newContact.familyName = dic["lastName"]!
        //newContact.imageData = dic["profilePicture"]!
        
        // Saving contact
        let saveRequest = CNSaveRequest()
        let store = CNContactStore()
        
        saveRequest.add(newContact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "swipeDown", sender: self)
    }
}

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



