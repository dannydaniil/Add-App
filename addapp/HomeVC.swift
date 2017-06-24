//
//  HomeVC.swift
//  addapp
//
//  Created by Danny Daniil on 6/23/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit
import CoreImage

class HomeVC: UIViewController {
    
    var qrcodeImage: CIImage!
    var encodedText: String!

    
     @IBOutlet weak var generateQRBtn: UIButton!
    @IBOutlet weak var imgQRCode: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
          }
    
    @IBAction func changeQRCode(_ sender: Any) {
        
        if qrcodeImage == nil {
            
            encodedText = "Hello World"
            
            if  encodedText == "" {
                return 
            }

        
        let data = encodedText.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        //imgQRCode.image = convert(cmage: qrcodeImage)
            
            displayQRCodeImage()
            
        generateQRBtn.setTitle("Clear", for: UIControlState.normal)
        }
        else {
            imgQRCode.image = nil
            qrcodeImage = nil
            generateQRBtn.setTitle("Generate", for: UIControlState.normal)
        }
        
    }//end of changeQRCode
    
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        
        imgQRCode.image = convert(cmage: transformedImage)
        
    }
}





func convert(cmage:CIImage) -> UIImage
{
    let context:CIContext = CIContext.init(options: nil)
    let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
    let image:UIImage = UIImage.init(cgImage: cgImage)
    return image
}


