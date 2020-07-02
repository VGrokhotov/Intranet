//
//  Chat.swift
//  Intranet
//
//  Created by Владислав on 29.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

struct Chat {
    let interlocutorID: UUID
    let interlocutorName: String
    let interlocutorSurname: String
}

extension Chat {
    func getFullName() -> String {
        return interlocutorSurname + " " + interlocutorName
    }
}
