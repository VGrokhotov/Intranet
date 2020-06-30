//
//  ChatsStorageManager.swift
//  Intranet
//
//  Created by Владислав on 30.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//


import UIKit
import CoreData

protocol ChatsDataManager {
    
    func saveChat(chat: Chat, completion: @escaping () -> ())
    
    func getChats() -> [Chat]
    
    func deleteChatWith(id: UUID, completion: @escaping () -> ())
    
}

class ChatsStorageManager: ChatsDataManager {
    
    public static let shared: ChatsDataManager = ChatsStorageManager() // создаем Синглтон
    
    private init(){}
    
    let fetchRequest = NSFetchRequest<ChatObject>(entityName: "ChatObject")
    
    private lazy var container: NSPersistentContainer = {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let appDelegate = appDelegate {
            return appDelegate.persistentContainer
        }
        
        return NSPersistentContainer()
    }()

    
    func saveChat(chat: Chat, completion: @escaping () -> ()) {

        container.performBackgroundTask { (context) in

            guard let allChats = try? context.fetch(self.fetchRequest) else { return }
            
            var existingChat: ChatObject? = nil

            for chatInContext in allChats {
                if chatInContext.interlocutorID == chat.interlocutorID {
                    chatInContext.interlocutorName = chat.interlocutorName
                    chatInContext.interlocutorSurname = chat.interlocutorSurname
                    existingChat = chatInContext
                    break
                }
            }
            
            if let _ = existingChat {
                
            } else {
                let currentChatObject = NSEntityDescription.insertNewObject(forEntityName: "ChatObject", into: context) as? ChatObject

                currentChatObject?.interlocutorID = chat.interlocutorID
                currentChatObject?.interlocutorName = chat.interlocutorName
                currentChatObject?.interlocutorSurname = chat.interlocutorSurname
            }

            try? context.save()

            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getChats() -> [Chat] {
        
        guard let allChats = try? container.viewContext.fetch(self.fetchRequest) else { return [] }
        
        
        return allChats.map { (chatObject) -> Chat in
            return chatObject.toChat()
        }
    }
    
    func deleteChatWith(id: UUID, completion: @escaping () -> ()) {
        
        container.performBackgroundTask { (context) in
            
            guard let allChats = try? context.fetch(self.fetchRequest) else { return }
            
            for chatInContext in allChats {
                if chatInContext.interlocutorID == id {
                    context.delete(chatInContext)
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
