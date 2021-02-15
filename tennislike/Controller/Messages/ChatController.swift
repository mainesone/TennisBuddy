//
//  ChatController.swift
//  tennislike
//
//  Created by Maik Nestler on 22.12.20.
//

import UIKit

private let reuseIdentifer = "MessageCell"

class ChatController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let user: User
    private var messages = [Message]()
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.delegate = self
        return civ
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        configureCollectionView()
        fetchMessages()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    func fetchMessages() {
        MessagingService.shared.fetchMessages(forUser: user) { messages in
            DispatchQueue.main.async {
                self.messages = messages
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                                 at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = user.name
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifer)
    }
}

// MARK: - UICollectionViewDataSource

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! MessageCell
        cell.viewModel = ChatViewModel(message: messages[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.viewModel = ChatViewModel(message: messages[indexPath.row])
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

// MARK: - CustomInputAccessoryViewDelegate

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        MessagingService.shared.uploadMessage(message, to: user) { error in
            inputView.messageInputTextView.text = nil
        }
    }
}


