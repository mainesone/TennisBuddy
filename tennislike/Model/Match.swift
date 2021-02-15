//
//  Match.swift
//  tennislike
//
//  Created by Maik Nestler on 21.12.20.
//

import UIKit

struct Match {
    let name: String
    let profileImageUrl: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
