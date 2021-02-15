//
//  BottomControllStrackView.swift
//  tennislike
//
//  Created by Maik Nestler on 03.12.20.
//

import UIKit

protocol BottomControllerStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

class BottomControllerStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: BottomControllerStackViewDelegate?
    
    let dislikeButton = UIButton(type: .system)
    let refreshButton = UIButton(type: .system)
    let letsPlayButton = UIButton(type: .system)
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dislikeButton.setImage(#imageLiteral(resourceName: "dislike").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        refreshButton.setImage(#imageLiteral(resourceName: "refresh").withRenderingMode(.alwaysOriginal), for: .normal)
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        letsPlayButton.setImage(#imageLiteral(resourceName: "like_tennis").withRenderingMode(.alwaysOriginal), for: .normal)
        letsPlayButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        [dislikeButton, UIView(), refreshButton, UIView(), letsPlayButton].forEach { view in
            addArrangedSubview(view)
            
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 60, bottom: 0, right: 60)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleDislike() {
        delegate?.handleDislike()
    }
    
    @objc func handleRefresh() {
        delegate?.handleRefresh()
    }
    
    @objc func handlePlay() {
        delegate?.handleLike()
    }
}
