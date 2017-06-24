//
//  RoundImageView.swift
//  addapp
//
//  Created by Danny Daniil on 6/23/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit

@IBDesignable class RoundImageView: UIImageView{
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = frame.height / 2
            layer.masksToBounds = false
            clipsToBounds = true
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
}
