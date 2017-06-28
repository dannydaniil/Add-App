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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCheckmark(selected: false)
    }
    
    func configureCell(accountType: String){
        accountTypeLbl.text = "\(accountType)"
    }
    
    func setCheckmark(selected: Bool) {
        
        //for custom accessory view
        //let imageStr = selected ? "messageindicatorchecked1" : "messageindicator1"
        //self.accessoryView = UIImageView(image: UIImage(named: imageStr))
        
        if selected {
            self.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            self.accessoryType = UITableViewCellAccessoryType.none
        }
    }
}
