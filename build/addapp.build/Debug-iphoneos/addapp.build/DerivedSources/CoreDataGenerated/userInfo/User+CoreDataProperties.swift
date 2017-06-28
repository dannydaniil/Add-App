//
//  User+CoreDataProperties.swift
//  
//
//  Created by Anmol Jain on 6/27/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var facebook: String?
    @NSManaged public var firstName: String?
    @NSManaged public var instagram: String?
    @NSManaged public var isRegistered: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var linkedin: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var profilePicture: NSData?
    @NSManaged public var snapchat: String?
    @NSManaged public var workNumber: String?

}
