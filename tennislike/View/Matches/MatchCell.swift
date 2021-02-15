//
//  MatchCell.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

class MatchCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: MatchCellViewModel! {
        didSet {
            usernameLabel.text = viewModel.nameText
            profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.setDimensions(height: 80, width: 80)
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        
        addSubview(stack)
        stack.fillSuperview()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
