//
//  DataService.swift
//  addapp
//
//  Created by Anmol Jain on 6/28/17.
//  Copyright © 2017 Jain, Anmol. All rights reserved.
//

import UIKit
import CoreData

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var profiles = ["Mobile Number", "Work Number", "Email", "Facebook", "Instagram", "Snapchat", "LinkedIn", "Twitter"]
    
    func selectProfile(profile: String) {
        
    }
    
    func deselectProfile(profile: String) {
    
    }
    
    func saveAccounts() {
        
    }
    
    func loadAccounts() {
        
    }
    
}
