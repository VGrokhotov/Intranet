//
//  Messages.swift
//  Intranet
//
//  Created by Владислав on 29.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class Messages: NSObject, NSCoding {
    
    var messages: [Message] = []
    
    enum Key: String {
        case messages = "messages"
    }
    
    init(messages: [Message]) {
        self.messages = messages
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(messages, forKey: Key.messages.rawValue)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let messages = coder.decodeObject(forKey: Key.messages.rawValue) as? [Message] else { return nil }
        
        self.init(messages: messages)
    }
    
}
