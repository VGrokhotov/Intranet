//
//  UserAuthorization.swift
//  Intranet
//
//  Created by Владислав on 28.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class UserAuthorization {
    
    var user: User?
    
    var isAuthorized: Bool {
        if let currentUser = UsersStorageManager.shared.getUser() {
            user = currentUser
            return true
        }
        user = nil
        return false
    }
    
    public static let shared = UserAuthorization() // создаем Синглтон
    private init(){}
    
}
