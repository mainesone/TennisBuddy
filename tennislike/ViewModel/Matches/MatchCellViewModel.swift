//
//  MatchCellViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

struct MatchCellViewModel {
    
    let nameText: String
    let profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid 
    }
}
