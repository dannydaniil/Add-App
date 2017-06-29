//
//  DataService.swift
//  addapp
//
//  Created by Anmol Jain on 6/28/17.
//  Copyright © 2017 Jain, Anmol. All rights reserved.
//

import UIKit
import CoreData

class DataService: NSObject, NSFetchedResultsControllerDelegate {
    private static let _instance = DataService()
    
    var userController: NSFetchedResultsController<User>!
    var accountsController: NSFetchedResultsController<Accounts>!
    
    static var instance: DataService {
        return _instance
    }
    
    func fetchUserData() -> User {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let userSort = NSSortDescriptor(key: "firstName", ascending: false, selector: nil)
        
        //passing in the descriptor
        fetchRequest.sortDescriptors = [userSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.userController = controller
        
        //make fetch request
        do {
            try self.userController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return controller.fetchedObjects![0]
    }
    
    func isRegisteredUser() -> Bool {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let userSort = NSSortDescriptor(key: "firstName", ascending: false, selector: nil)
        
        //passing in the descriptor
        fetchRequest.sortDescriptors = [userSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.userController = controller
        
        //make fetch request
        do {
            try self.userController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        if (controller.fetchedObjects?.isEmpty)! {
            return false
        } else {
            return controller.fetchedObjects![0].isRegistered
        }
    }
    
    func fetchAccountsData() -> Accounts{
        
        let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
        let accountsSort = NSSortDescriptor(key: "facebook", ascending: false, selector: nil)
        
        fetchRequest.sortDescriptors = [accountsSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.accountsController = controller
        
        //make fetch request
        do {
            try self.accountsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        if (controller.fetchedObjects?.isEmpty)! {
            return Accounts()
        }
        
        return controller.fetchedObjects![0]
    }

    
 
}
