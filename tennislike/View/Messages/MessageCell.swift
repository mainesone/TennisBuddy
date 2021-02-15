//
//  MessageCell.swift
//  tennislike
//
//  Created by Maik Nestler on 22.12.20.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: ChatViewModel? {
        didSet { configure() }
    }
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    var anchoredConstraints: AnchoredConstraints!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        textView.text = viewModel.messageText
        textView.textColor = viewModel.messageTextColor
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        anchoredConstraints.trailing?.isActive = viewModel.rightAnchorActive
        anchoredConstraints.leading?.isActive = viewModel.leftAnchorActive
    }
}
