//
//  MessagesStorageManager.swift
//  Intranet
//
//  Created by Владислав on 30.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesDataManager {
    
    func saveNewMessages(interlocutorID: UUID, messages: [Message], completion: @escaping () -> ())
    
    func getMessagesWith(interlocutorID: UUID) -> [Message]
    
    func deleteMessagesWith(interlocutorID: UUID, completion: @escaping () -> ())
    
}

class MessagesStorageManager: MessagesDataManager {
    
    public static let shared: MessagesDataManager = MessagesStorageManager() // создаем Синглтон
    
    private init(){}
    
    let fetchRequest = NSFetchRequest<MessagesObject>(entityName: "MessagesObject")
    
    private lazy var container: NSPersistentContainer = {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let appDelegate = appDelegate {
            return appDelegate.persistentContainer
        }
        
        return NSPersistentContainer()
    }()
    
    
    func saveNewMessages(interlocutorID: UUID, messages: [Message], completion: @escaping () -> ()) {
        
        container.performBackgroundTask { (context) in
            
            guard let allMessages = try? context.fetch(self.fetchRequest) else { return }
            
            var existingMessagesModel: MessagesObject? = nil
            
            for messagesInContext in allMessages {
                if messagesInContext.interlocutorID == interlocutorID {
                    existingMessagesModel = messagesInContext
                    break
                }
            }
            
            if let existingMessagesModel = existingMessagesModel {
                existingMessagesModel.array.append(contentsOf: messages)
            } else {
                let currentMessagesObject = NSEntityDescription.insertNewObject(forEntityName: "MessagesObject", into: context) as? MessagesObject
                
                currentMessagesObject?.interlocutorID = interlocutorID
                currentMessagesObject?.array = messages
            }
            
            try? context.save()
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getMessagesWith(interlocutorID: UUID) -> [Message] {
        
        guard let allMessages = try? container.viewContext.fetch(self.fetchRequest) else { return [] }
        
        
        for messagesInContext in allMessages {
            if messagesInContext.interlocutorID == interlocutorID {
                return messagesInContext.getMessagesArray()
            }
        }
        
        return []
    }
    
    func deleteMessagesWith(interlocutorID: UUID, completion: @escaping () -> ()) {
        
        container.performBackgroundTask { (context) in
            
            guard let allMessages = try? context.fetch(self.fetchRequest) else { return }
            
            for messagesInContext in allMessages {
                if messagesInContext.interlocutorID == interlocutorID {
                    context.delete(messagesInContext)
                    break
                }
            }
            
            try? context.save()
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
}
