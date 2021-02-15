//
//  ChatViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

struct ChatViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.5529411765, green: 0.7098039216, blue: 0.5882352941, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .white : .white
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    let messageText: String
    
    init(message: Message) {
        self.message = message
        
        messageText = message.text
    }
    
}
