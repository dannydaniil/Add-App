//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Anmol Jain on 6/27/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var email: Bool
    @NSManaged public var facebook: Bool
    @NSManaged public var instagram: Bool
    @NSManaged public var linkedin: Bool
    @NSManaged public var mobileNumber: Bool
    @NSManaged public var snapchat: Bool
    @NSManaged public var workNumber: Bool

}
