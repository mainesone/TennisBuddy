//
//  MatchViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

struct MatchViewViewModel {
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    
    var currentUserImageUrl: URL?
    var matchedUserImageUrl: URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "Hey, du hast gerade \(matchedUser.name) als Spielpartner gefunden. Verabredet euch jetzt für eine Runde Tennis."
        
        guard let imageUrlString = currentUser.imageURLs.first else { return }
        guard let matchedImageUrlString = matchedUser.imageURLs.first else { return }
        currentUserImageUrl = URL(string: imageUrlString)
        matchedUserImageUrl = URL(string: matchedImageUrlString)
    }
}
