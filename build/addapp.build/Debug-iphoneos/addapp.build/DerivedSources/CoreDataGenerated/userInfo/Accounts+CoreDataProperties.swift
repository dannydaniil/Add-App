//
//  Accounts+CoreDataProperties.swift
//  
//
//  Created by Anmol Jain on 6/29/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Accounts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accounts> {
        return NSFetchRequest<Accounts>(entityName: "Accounts")
    }

    @NSManaged public var email: Bool
    @NSManaged public var facebook: Bool
    @NSManaged public var instagram: Bool
    @NSManaged public var linkedin: Bool
    @NSManaged public var mobileNumber: Bool
    @NSManaged public var snapchat: Bool
    @NSManaged public var twitter: Bool
    @NSManaged public var workNumber: Bool

}
