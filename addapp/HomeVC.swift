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
    var qrcodeImage: CIImage!
    var encodedText: String!
    
    //must tell it what it will work with
    var controller: NSFetchedResultsController<User>!

    
    @IBOutlet weak var imgQRCode: UIImageView!
    

    override func viewDidLoad() {
        
        
        if fetchUserData().isRegistered == false {
            performSegue(withIdentifier: "SignUpVC", sender: nil)
        } else {
            
            nameLbl.text = fetchUserData().firstName! + " " + fetchUserData().lastName!
            
        
            super.viewDidLoad()
            //createContact()
        
            //call only if any switch changed
            presentQRBarcode()
        }
    }
    
    func fetchUserData () -> User {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        let userSort = NSSortDescriptor(key: "firstName", ascending: false, selector: nil)
        
        //passing in the descriptor
        fetchRequest.sortDescriptors = [userSort]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
          controller.delegate = self
          self.controller = controller
        
        //make fetch request
        do{
            try self.controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return controller.fetchedObjects![0]
    }
    
    
    @IBAction func swippedRight(_ sender: Any) {
        
        //present the scanner
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    //3 scanner functions to be changed
    
    //handles identified QR Barcode
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String){
        
        print(code)
        print(type)
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
    
    //deals with error
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error){
        print(error)
    }
    
    //dismisses view controller
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController){
        dismiss(animated: true, completion: nil)
    }

    
    //handle QR code generation and presentation on screen
    func presentQRBarcode() {
        if qrcodeImage == nil {
            
            //text to be encoded
            encodedText = "First:Last:"
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
        else {
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
    
    
    // I think it speaks for itself ==> adds new contact
    func createContact() {
        
        // Creating a new contact
        let newContact = CNMutableContact()
        newContact.givenName = "John"
        newContact.familyName = "Appleseed"
        
        
        // Saving contact
        let saveRequest = CNSaveRequest()
        let store = CNContactStore()
        saveRequest.add(newContact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
    }
    
}

//convert from CIImage to UIImage
func convert(cmage:CIImage) -> UIImage
{
    let context:CIContext = CIContext.init(options: nil)
    let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
    let image:UIImage = UIImage.init(cgImage: cgImage)
    return image
}

func appDelegate () -> AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}



