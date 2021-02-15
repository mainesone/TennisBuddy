//
//  API Constants.swift
//  tennislike
//
//  Created by Maik Nestler on 07.12.20.
//

import UIKit
import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_SWIPES = Firestore.firestore().collection("swipes")
let COLLECTION_MATCHES_MESSAGES = Firestore.firestore().collection("matches_messages")

