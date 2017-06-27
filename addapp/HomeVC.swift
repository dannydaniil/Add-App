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

class HomeVC: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    var qrcodeImage: CIImage!
    var encodedText: String!

    
    @IBOutlet weak var imgQRCode: UIImageView!
    

    override func viewDidLoad() {
        
        if SignUpVC.isRegisteredUser {
            
        }
            
        super.viewDidLoad()
        //createContact()
        
        
        //call only if any switch changed
        presentQRBarcode()
        
        //createContact()
        
        
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



