//
//  ListVC.swift
//  addapp
//
//  Created by Anmol Jain on 6/27/17.
//  Copyright © 2017 Jain, Anmol. All rights reserved.
//

import UIKit
import CoreData

class ListVC : UIViewController, UITableViewDelegate,
UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var profiles = ["Mobile Number", "Work Number", "Email", "Facebook", "Instagram", "Snapchat", "LinkedIn", "Twitter", "Pinterest", "Vimeo", "Venmo", "Google+", "Reddit", "Tumblr"]
    var profiles1 = ["Mobile Number", "Work Number", "Email", "Facebook", "Instagram", "Snapchat", "LinkedIn", "Twitter"]
    var selectedProfiles = [String]()
    
    var accounts: Accounts?
    var accountsController: NSFetchedResultsController<Accounts>!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        accounts = DataService.instance.fetchAccountsData()
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! accountCell
        let name = profiles[indexPath.row]
        let selected = profileIsSelected(profile: name)
        
        if selected {
            cell.setCheckmark(selected: false)
            if let index = selectedProfiles.index(of: profiles[indexPath.row]) {
                selectedProfiles.remove(at: index)
                print("deselected")
                print(selectedProfiles)
            }
        } else {
            cell.setCheckmark(selected: true)
            selectedProfiles.append(profiles[indexPath.row])
            print("selected")
            print(selectedProfiles)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! accountCell
        let name = profiles[indexPath.row]
        let selected = profileIsSelected(profile: name)
        
        if !selected {
            cell.setCheckmark(selected: false)
            if let index = selectedProfiles.index(of: profiles[indexPath.row]) {
                selectedProfiles.remove(at: index)
                print("deselected")
                print(selectedProfiles)
            }
        } else {
            cell.setCheckmark(selected: true)
            selectedProfiles.append(profiles[indexPath.row])
            print("selected")
            print(selectedProfiles)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? accountCell {
            let name = profiles[indexPath.row]
            
            let index1 = profiles1.index(of: name)
            if index1 != nil {
                let selected = profileIsSelected(profile: name)
                myCell.setCheckmark(selected: selected)
                if selected {
                    selectedProfiles.append(name)
                    print("will display")
                    print(selectedProfiles)
                }
            }

        }
    }
    
    //replicates the prototype cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! accountCell
        let name = profiles[indexPath.row]
        cell.configureCell(accountType: name)
        cell.selectionStyle = .none
        
        let index1 = profiles1.index(of: name)
        if index1 != nil {
            let index = selectedProfiles.index(of: name)
            if index != nil {
                cell.setCheckmark(selected: true)
            } else {
                cell.setCheckmark(selected: false)
            }
        }
        
        return cell
    }
    
    func updateCoreData() {
        for item in profiles1 {
            let temp = convertProfile(profile: item)
            
            if selectedProfiles.contains(item) {
                accounts?.setValue(true, forKey: temp)
            } else {
                accounts?.setValue(false, forKey: temp)
            }
        }
        
        ad.saveContext()
    }
    
    func profileIsSelected(profile: String) -> Bool {
        let temp = convertProfile(profile: profile)
        if let value = accounts?.value(forKey: temp) as! Bool? {
            if value {
                return true
            } else {
                return false
            }
        }
        return false
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
     
    @IBAction func closeBtnPressed(_ sender: Any) {
        updateCoreData()
        dismiss(animated: true, completion: nil)
    }
}
