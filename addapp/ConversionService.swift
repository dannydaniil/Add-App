//
//  ConversionService.swift
//  addapp
//
//  Created by Anmol Jain on 6/29/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit
import CoreImage

class ConversionService {
    private static let _instance = ConversionService()
    
    static var instance: ConversionService {
        return _instance
    }

    func convertProfile(profile: String) -> String {
        switch profile {
        case "Mobile Number":
            return "mobileNumber"
        case "Work Number":
            return "workNumber"
        default:
            return profile.lowercased()
        }
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
    
    //convert from CIImage to UIImage
    func convertImage(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}
