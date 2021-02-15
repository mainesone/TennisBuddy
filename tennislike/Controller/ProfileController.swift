//
//  ProfileController.swift
//  tennislike
//
//  Created by Maik Nestler on 14.12.20.
//

import UIKit

private let reuseIdentifier = "ProfileCell"

class ProfileController: UIViewController {
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var viewModel = ProfileViewModel(user: user)
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "card"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let skillLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let clubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadUserData()
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(collectionView)
        
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, skillLabel, clubLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
        configureBarStackView()
    }
    
    func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                            paddingTop: 56, paddingLeft: 8, paddingRight: 8, height: 4)
    }
    
    func loadUserData() {
        infoLabel.attributedText = viewModel.userDetailAttributedSting
        skillLabel.text = viewModel.skill
        clubLabel.text = viewModel.club
    }
}

//MARK: - CollectionView DataSource

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        return cell 
    }
}

//MARK: - CollectionView Delegate

extension ProfileController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlightedBar(index: indexPath.row)
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
