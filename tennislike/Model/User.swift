//
//  User.swift
//  tennislike
//
//  Created by Maik Nestler on 05.12.20.
//

import UIKit

struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var imageURLs: [String]
    var skill: String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var club: String
    
    init(dictionary:[String:Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.imageURLs = dictionary["imageURLs"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.skill = dictionary["skill"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 16
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 60
        self.club = dictionary["bio"] as? String ?? ""
    }
}
