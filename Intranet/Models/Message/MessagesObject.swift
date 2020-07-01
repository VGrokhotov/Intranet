//
//  MessagesObject.swift
//  Intranet
//
//  Created by Владислав on 29.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

@objc(MessagesObject)
class MessagesObject: NSManagedObject {
    
    @NSManaged public var interlocutorID: UUID
    @NSManaged public var array: [Message]

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessagesObject> {
        return NSFetchRequest<MessagesObject>(entityName: "MessagesObject");
    }
    

}

extension MessagesObject {
    func getMessagesArray() -> [Message] {
        return self.array
    }
}
