//
//  accountCell.swift
//  addapp
//
//  Created by Danny Daniil on 6/24/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit

class accountCell: UITableViewCell {

   
    @IBOutlet weak var accountTypeLbl: UILabel!

    func configureCell(accountType: String){
        accountTypeLbl.text = "\(accountType)"
    }
    

    
    @IBAction func switchFlipped(_ sender: Any) {
        
        
    }

}
