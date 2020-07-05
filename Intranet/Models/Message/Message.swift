//
//  Message.swift
//  Intranet
//
//  Created by Владислав on 29.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class Message: NSObject, NSCoding, Codable {
    
    var senderID: UUID
    var content: Data
    var contentType: ContentType
    var time: Date
    var fileSize: Int?
    var fileName: String?
    
    enum Key: String {
        case senderID = "senderID"
        case content = "content"
        case contentType = "contentType"
        case time = "time"
        case fileSize = "fileSize"
        case fileName = "fileName"
    }
    
    init(senderID: UUID, content: Data, contentType: ContentType, time: Date, fileSize: Int? = nil, fileName: String? = nil) {
        self.senderID = senderID
        self.content = content
        self.contentType = contentType
        self.time = time
        self.fileSize = fileSize
        self.fileName = fileName
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(senderID, forKey: Key.senderID.rawValue)
        coder.encode(content, forKey: Key.content.rawValue)
        coder.encode(contentType.rawValue, forKey: Key.contentType.rawValue)
        coder.encode(time, forKey: Key.time.rawValue)
        coder.encode(fileSize, forKey: Key.fileSize.rawValue)
        coder.encode(fileName, forKey: Key.fileName.rawValue)
    }
    
    required init?(coder: NSCoder) {
        guard
            let senderID = coder.decodeObject(forKey: Key.senderID.rawValue) as? UUID,
            let content = coder.decodeObject(forKey: Key.content.rawValue) as? Data,
            let contentTypeString = coder.decodeObject(forKey: Key.contentType.rawValue) as? String,
            let contentType = ContentType(rawValue: contentTypeString),
            let time = coder.decodeObject(forKey: Key.time.rawValue) as? Date
        else { return nil }
        
        self.senderID = senderID
        self.content = content
        self.contentType = contentType
        self.time = time
        self.fileSize = coder.decodeObject(forKey: Key.fileSize.rawValue) as? Int
        self.fileName = coder.decodeObject(forKey: Key.fileName.rawValue) as? String
    }
}

enum ContentType: String, Codable{
    case text = "text"
    case image = "image"
    case file = "file"
    case unknown = "unknown"
}
