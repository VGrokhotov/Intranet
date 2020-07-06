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
    @IBOutlet weak var messegeImageView: UIImageView!
    
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTextConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeAndTextConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageConstraint: NSLayoutConstraint!
    
    
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
    
    func deactivateTextLabel() {
        textContentLabel.text = ""
        textContentLabel.isHidden = true
        //NSLayoutConstraint.deactivate([leftTextConstraint, rightTextConstraint, topTextConstraint, timeAndTextConstraint])
    }
    
    func deactivateImageView() {
        messegeImageView.image = nil
        messegeImageView.isHidden = true
    }
    
    func activateTextLabel() {
        textContentLabel.isHidden = false
        NSLayoutConstraint.activate([leftTextConstraint, rightTextConstraint, topTextConstraint, timeAndTextConstraint])
    }
    
    func activateImageView() {
        messegeImageView.isHidden = false
        NSLayoutConstraint.activate([leftImageConstraint, rightImageConstraint, topImageConstraint, bottomImageConstraint])
    }
    
}

extension MessageCell: ConfigurableView {
    
    typealias ConfigurationModel = Message
    
    func configure(with model: Message) {
        message = model
        
        //настройка отображения контента
        switch model.contentType {
        case .text:
            deactivateImageView()
            activateTextLabel()
            textContentLabel.attributedText = nil
            textContentLabel.text = String(data: message?.content ?? Data(), encoding: .utf8)
            textContentLabel.textColor = .black
            break
        case .image:
            deactivateTextLabel()
            activateImageView()
            messegeImageView.layer.cornerRadius = 10
            messegeImageView.contentMode = .scaleAspectFit
            messegeImageView.clipsToBounds = true
            if let image = UIImage.init(data: message?.content ?? Data()) {
                messegeImageView.image = image
                self.layoutIfNeeded()
                let frame = messegeImageView.contentClippingRect
                messegeImageView.image = UIImage.resizedCroppedImage(image: image, newSize: frame.size)
                self.layoutIfNeeded()
            }
            break
        case .file:
            deactivateImageView()
            activateTextLabel()
            textContentLabel.text = nil
            if let fileName = message?.fileName, let fileSize = message?.fileSize {
                let string = NSMutableAttributedString.init(string: "\(fileName), \(fileSize/1024) Kb")
                string.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: string.length))
                textContentLabel.attributedText = string
                textContentLabel.textColor = .systemBlue
                
            }
            break
        case .unknown:
            //не поддерживается
            break
        }
        
        if message?.senderID == UserAuthorization.shared.user?.id {
            messageView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            
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
