//
//  MessageCell.swift
//  Intranet
//
//  Created by Владислав on 30.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var textContentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var message: Message?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.layer.cornerRadius = 10
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
        case "text":
            textContentLabel.text = String(data: message?.content ?? Data(), encoding: .utf8)
            break
        case "image":
            break
        case "file":
            break
        default:
            //не поддерживается
            break
        }
        
        if message?.senderID == UserAuthorization.shared.user?.id {
            messageView.backgroundColor = #colorLiteral(red: 0.3076745272, green: 0.5609909296, blue: 0.9542145133, alpha: 1)
            
            NSLayoutConstraint.deactivate([leftConstraint])
            NSLayoutConstraint.activate([rightConstraint])
        } else {
            messageView.backgroundColor = #colorLiteral(red: 0.8470765352, green: 0.8470765352, blue: 0.8470765352, alpha: 1)
            
            NSLayoutConstraint.deactivate([rightConstraint])
            NSLayoutConstraint.activate([leftConstraint])
        }
        
        let date = model.time
        
        let today = Date() // сегодня
        let calendar = Calendar.current
            
        let date0 = Calendar.current.startOfDay(for: today)//now 00:00
        let dateFormatterPrint = DateFormatter()

        if (calendar.compare(date0, to: date, toGranularity: .day) == .orderedDescending){
            if (calendar.compare(date0, to: date, toGranularity: .year) == .orderedDescending){
                dateFormatterPrint.dateFormat = "dd MMM, yyyy"
            } else{
                dateFormatterPrint.dateFormat = "dd MMM"
            }
        } else{
            dateFormatterPrint.dateFormat = "HH:mm"
        }
        
        timeLabel.text  = dateFormatterPrint.string(from: date)
        
    }
    
}
