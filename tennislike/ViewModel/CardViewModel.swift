//
//  CardViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 05.12.20.
//

import UIKit


class CardViewModel {
    
    let user: User
    let imageURLs: [String]
    let userInfoText: NSAttributedString
    
    private var imageIndex = 0
    var index: Int { return imageIndex }
    
    var imageUrl: URL?
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name,
                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(rawValue: 32)),
                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "  \(user.age)",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: UIColor.white]))
        self.userInfoText = attributedText
        
        //        self.imageUrl = URL(string: user.profileImageUrl)
        self.imageURLs = user.imageURLs
        self.imageUrl = URL(string: self.imageURLs[0])
    }
    
    func showNextPhoto() {
        guard imageIndex < imageURLs.count - 1 else { return }
        imageIndex += 1
        imageUrl = URL(string: imageURLs[imageIndex])
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        imageUrl = URL(string: imageURLs[imageIndex])
    }
}
