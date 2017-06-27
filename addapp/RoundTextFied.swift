//
//  RoundButton.swift
//  addapp
//
//  Created by Danny Daniil on 6/25/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextField: UITextField{
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet{
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        
        didSet{
            
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            
            _ = NSAttributedString(string: rawString, attributes: [NSForegroundColorAttributeName: placeholderColor!])
        }
    }
    
}

