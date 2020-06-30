//
//  ChatCell.swift
//  Intranet
//
//  Created by Владислав on 30.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

class ChatCell: UITableViewCell {
    
    var chat: Chat?
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ChatCell: ConfigurableView {
    
    typealias ConfigurationModel = Chat
    
    func configure(with model: Chat) {
        chat = model
        
        nameLabel.text = model.interlocutorSurname + " " + model.interlocutorName
        //настройка лейблов
    }
    
}
