//
//  MessageCell.swift
//  Intranet
//
//  Created by Владислав on 30.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var message: Message?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MessageCell: ConfigurableView {
    
    typealias ConfigurationModel = Message
    
    func configure(with model: Message) {
        message = model
        
        //настройка отображения контента
        switch model.contentType {
        case .text:
            break
        case .image:
            break
        case .file:
            break
        case .unknown:
            //не поддерживается
            break
        }
        
        //timeLabel.text = model.time.description
        
    }
    
}
