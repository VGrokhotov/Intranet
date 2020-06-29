//
//  ChatObject.swift
//  Intranet
//
//  Created by Владислав on 29.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

@objc(ChatObject)
class ChatObject: NSManagedObject {

    @NSManaged public var interlocutorID: UUID
    @NSManaged public var interlocutorName: String
    @NSManaged public var interlocutorSurname: String

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatObject> {
        return NSFetchRequest<ChatObject>(entityName: "ChatObject");
    }
    

}

extension ChatObject {
    func toChat() -> Chat {
        return Chat(interlocutorID: self.interlocutorID, interlocutorName: self.interlocutorName, interlocutorSurname: self.interlocutorSurname)
    }
}
