//
//  User.swift
//  Intranet
//
//  Created by Владислав on 28.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: UUID
    let name: String
    let surname: String
}

extension User {
    func getFullName() -> String {
        return surname + " " + name
    }
}
