//
//  ProfileViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 15.12.20.
//

import UIKit

struct ProfileViewModel {
    
    private let user: User
    
    let userDetailAttributedSting: NSAttributedString
    let skill: String
    let club: String
    
    var imageURLs: [URL] {
        return user.imageURLs.map({ URL(string: $0)! })
    }
    
    var imageCount: Int {
        return user.imageURLs.count 
    }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        
        attributedText.append(NSAttributedString(string: "   \(user.age)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        
        userDetailAttributedSting = attributedText
        skill = user.skill
        club = user.club
    }
}
