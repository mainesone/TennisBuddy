//
//  SettingsFooter.swift
//  tennislike
//
//  Created by Maik Nestler on 13.12.20.
//

import UIKit

protocol SettingsFooterDelegate: class {
    func handleLogout()
}

class SettingsFooter: UIView {
    
    //MARK: - Properties
    
    weak var delegate: SettingsFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .brandingColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let spacer = UIView()
        spacer.backgroundColor = .clear
        
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)
        
        addSubview(logoutButton)
        logoutButton.anchor(top: spacer.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
