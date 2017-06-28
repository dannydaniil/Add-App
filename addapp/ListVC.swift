//
//  ListVC.swift
//  addapp
//
//  Created by Anmol Jain on 6/27/17.
//  Copyright © 2017 Jain, Anmol. All rights reserved.
//

import UIKit

class ListVC : UIViewController, UITableViewDelegate,
UITableViewDataSource {
    
    var profiles = ["Mobile Number", "Work Number", "Email", "Facebook", "Instagram", "Snapchat", "Twitter", "LinkedIn", "Pinterest", "Vimeo", "Venmo", "Google+", "Reddit", "Tumblr"]
    var selectedProfiles = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollViewDidScroll(tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        //print(maximumOffset - contentOffset)
        
        //temporary swipe up to main screen
        if maximumOffset - contentOffset == -10 {
            //let swipe = UISwipeGestureRecognizer(target: self, action:#selector(swipeUp))
            //swipe.direction = UISwipeGestureRecognizerDirection.up;
            performSegue(withIdentifier: "swipeUp", sender: self)
        }
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
        cell.setCheckmark(selected: true)
        
        selectedProfiles.append(profiles[indexPath.row])
        print(selectedProfiles)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! accountCell
        cell.setCheckmark(selected: false)
        
        if let index = selectedProfiles.index(of: profiles[indexPath.row]) {
            selectedProfiles.remove(at: index)
        }
        print(selectedProfiles)
    }
    
    //replicates the prototype cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! accountCell
        let name = profiles[indexPath.row]
        cell.configureCell(accountType: name)
        cell.selectionStyle = .none
        
        let index = selectedProfiles.index(of: name)
        if index != nil {
            cell.setCheckmark(selected: true)
        } else {
            cell.setCheckmark(selected: false)
        }
        
        return cell
    }
    
    //swipe up to dismiss list
    //    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
    //        performSegue(withIdentifier: "swipeUp", sender: self)
    //    }
}
