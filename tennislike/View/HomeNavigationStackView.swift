//
//  HomeNavigationStackView.swift
//  tennislike
//
//  Created by Maik Nestler on 03.12.20.
//

import UIKit

protocol HomeNavigationStackViewDelegate: class {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tennisBuddyLabel = UILabel()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        settingsButton.setImage(#imageLiteral(resourceName: "person_1").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "bubble").withRenderingMode(.alwaysOriginal), for: .normal)
        tennisBuddyLabel.text = "tennisBuddy"
        
        [settingsButton, UIView(), tennisBuddyLabel, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTaped), for: .touchUpInside)
        
        messageButton.addTarget(self, action: #selector(messageButtonTaped), for: .touchUpInside)
      
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    @objc func settingsButtonTaped() {
        delegate?.showSettings()
    }
    
    @objc func messageButtonTaped() {
        delegate?.showMessages()
    }
}
