//
//  Message.swift
//  Intranet
//
//  Created by Владислав on 29.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class Message: NSObject, NSCoding {
    
    var senderID: UUID
    var content: Data
    var contentType: ContentType
    var time: Date
    
    enum Key: String {
        case senderID = "senderID"
        case content = "content"
        case contentType = "contentType"
        case time = "time"
    }
    
    init(senderID: UUID, content: Data, contentType: ContentType, time: Date) {
        self.senderID = senderID
        self.content = content
        self.contentType = contentType
        self.time = time
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(senderID, forKey: Key.senderID.rawValue)
        coder.encode(content, forKey: Key.content.rawValue)
        coder.encode(contentType, forKey: Key.contentType.rawValue)
        coder.encode(time, forKey: Key.time.rawValue)
    }
    
    required convenience init?(coder: NSCoder) {
        guard
            let senderID = coder.decodeObject(forKey: Key.senderID.rawValue) as? UUID,
            let content = coder.decodeObject(forKey: Key.content.rawValue) as? Data,
            let contentType = coder.decodeObject(forKey: Key.contentType.rawValue) as? ContentType,
            let time = coder.decodeObject(forKey: Key.time.rawValue) as? Date
        else { return nil }
        
        self.init(senderID: senderID, content: content, contentType: contentType, time: time)
    }
}

enum ContentType {
    case text
    case image
    case file
    case unknown
}
