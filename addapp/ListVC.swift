//
//  ListVC.swift
//  addapp
//
//  Created by Danny Daniil on 6/24/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import Foundation
import UIKit

class ListVC : UIViewController, UITableViewDelegate,
UITableViewDataSource {
    
    
    var socialMediaNames = ["Facebook","Snapchat","Instagram","LinkedIn","Twitter","Pinterest","Vimeo","Venmo","Google +","Reddit","Tumblr","Vine","Classmates"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMediaNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0;//Choose your custom row height
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as? accountCell {
            
            let name = socialMediaNames[indexPath.row]
            cell.configureCell(accountType: name)
            
            return cell
        }else {
            print("Error on weather cell")
            return accountCell()
        }
    }
    
    
    
    @IBAction func swippedUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    
}
