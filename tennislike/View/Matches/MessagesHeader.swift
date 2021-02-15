//
//  MessagesHeader.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

private let cellIdentifier = "MatchCell"

protocol MessagesHeaderDelegate: class {
    func messagesHeader(_ header: MessagesHeader, wantsToStartChatWith uid: String)
}

class MessagesHeader: UICollectionReusableView {
    
    var matches = [Match]() {
        didSet { collectionView.reloadData() }
    }
    
    weak var delegate: MessagesHeaderDelegate?
    
    //MARK: - Properties
    private let newPlayerLabel: UILabel = {
        let label = UILabel()
        label.text = "Neue Spieler"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false 
        cv.delegate = self
        cv.dataSource = self
        cv.register(MatchCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newPlayerLabel)
        newPlayerLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(collectionView)
        collectionView.anchor(top: newPlayerLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor , right: rightAnchor,
                              paddingTop: 4, paddingLeft: 12, paddingBottom: 24, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource

extension MessagesHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MatchCell
        cell.viewModel = MatchCellViewModel(match: matches[indexPath.row])
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension MessagesHeader: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = matches[indexPath.row].uid
        delegate?.messagesHeader(self, wantsToStartChatWith: uid)
    }
}

//MARK: - UICollectionView FlowLayout

extension MessagesHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 124)
    }
}
