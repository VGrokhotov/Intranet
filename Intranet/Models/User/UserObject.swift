//
//  UserObject.swift
//  Intranet
//
//  Created by Владислав on 28.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

@objc(UserObject)
class UserObject: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var surname: String

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserObject> {
        return NSFetchRequest<UserObject>(entityName: "UserObject");
    }
    

}

extension UserObject{
    func toUser() -> User {
        return User(id: self.id, name: self.name, surname: self.surname)
    }
}
