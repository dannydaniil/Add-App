//
//  SlideDownSegue.swift
//  addapp
//
//  Created by Anmol Jain on 6/29/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit

class SlideDownSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = self.source
        let destination = self.destination
        
        source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
        destination.view.transform = CGAffineTransform(translationX: 0, y: -source.view.frame.size.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (Finished) in
            source.present(destination, animated: false, completion: nil)
        }
    }
}
