//
//  MessagesController.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

private let reuseIdentifier = "MessagesCell"

class MessagesController: UITableViewController {
    
    //MARK: - Properties
    private let user: User
    
    weak var delegate: MessagesController?
    
    private lazy var headerView: MessagesHeader = {
        let header = MessagesHeader()
        header.delegate = self
        return header
    }()
    
    private var conversations = [Conversation]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        configureNavigationBar()
        configureTableView()
        fetchMatches()
        fetchRecentMessages()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    func fetchMatches() {
        Service.fetchMatches { matches in
            self.headerView.matches = matches 
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchRecentMessages() {
        MessagingService.shared.fetchConversations { conversations in
            self.conversations = conversations
        }
    }
    
    //MARK: - Helper Functions
    
    func configureNavigationBar() {
        navigationItem.title = "Nachrichten"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem?.tintColor = .brandingColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleDismissal))
    }
    
    func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
    }
}

//MARK: - UITableView DataSource

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        setTableViewBackgroundGradient(sender: self, UIColor.white, UIColor.brandingColor)
        cell.viewModel = ConversationViewModel(conversation: conversations[indexPath.row])
        return cell
        
    }
}

//MARK: - UITableView Delegate

extension MessagesController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = .black
        label.text = "Nachrichten"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
}

//MARK: - MessagesHeaderDelegate

extension MessagesController: MessagesHeaderDelegate {
    func messagesHeader(_ header: MessagesHeader, wantsToStartChatWith uid: String) {
        Service.fetchUser(withUid: uid) { user in
            let controller = ChatController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}





