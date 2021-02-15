//
//  HomeController.swift
//  tennislike
//
//  Created by Maik Nestler on 03.12.20.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    private var user: User?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControllerStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        return view
    }()
    
    //MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkIfUserIsLoggedIn()
        fetchCurrentUserAndCards()
        
    }
    
    //MARK: - API

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: User is logged in..")
        }
    }
    
    func fetchUsers(forCurrentUser user: User) {
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
    
    func fetchCurrentUserAndCards() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.fetchUsers(forCurrentUser: user)
        }
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipe(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            guard didLike == true else { return }
            
            Service.checkIfMatchExists(forUser: user) { didMatch in
                self.presentMatchView(forUser: user)
                
                guard let currentUser = self.user else { return }
                Service.uploadMatch(currentUser: currentUser, matchedUser: user)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Failed to sign out..")
        }
    }
    
    //MARK: - HelperFunctions
    
    func configureUI() {
        configureGradientLayer()
        
        topStack.delegate = self
        bottomStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
//            cardViews.append(cardView)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: (self.topCardView?.frame.width)!,
                                             height: (self.topCardView?.frame.height)!)
        }) { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = tennislike.MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func startChat(withUser user: User) {
        guard let currentUser = self.user else { return }
        let controller = MessagesController(user: currentUser)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true) {
            let controller = ChatController(user: user)
            nav.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
    }
}

// MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: { view == $0 })
        
        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        //controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
   }
}

//MARK: - HomeNavigationStack Delegate

extension HomeController: HomeNavigationStackViewDelegate {
    
    func showSettings() {
        guard let user = user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self 
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showMessages() {
        guard let user = user else { return }
        let controller = MessagesController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - BottomControllerStackViewDelegate

extension HomeController: BottomControllerStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
        
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        guard let user = self.user else { return }
        
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
}

//MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        controller.dismiss(animated: true, completion: nil)
        logout()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}

//MARK: - MatchViewDelegate

extension HomeController: MatchViewDelegate {
    func MatchView(_ view: MatchView, wantsToSendMessageTo user: User) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
        }) { _ in
            view.removeFromSuperview()
            self.startChat(withUser: user)
        }
    }
}

