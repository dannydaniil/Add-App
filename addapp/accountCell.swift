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
    
    @IBOutlet weak var accountTypeSwitch: UISwitch!

    func configureCell(accountType: String){
        
        
        accountTypeLbl.text = "\(accountType)"
        
        
//        lowTemp.text = "\(forecast.lowtemp)"
//        highTemp.text = "\(forecast.highTemp)"
//        weatherType.text = forecast.weatherType
//        dayLabel.text = forecast.date
//        weatherIcon.image = UIImage(named: forecast.weatherType)
    }
    
    

}
