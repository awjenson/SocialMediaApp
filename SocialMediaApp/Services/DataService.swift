//
//  DataService.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/20/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

// Global Variable

// Database URL located in GoogleService-Info.plist
let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {

    static let ds = DataService()
    
    // DB References
    private var _REF_BASE = DB_BASE  // socialmediaapp-190be
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")

    // Storage References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")

    // Computed Properties - To keep code secure (no one can reference them)
    // Use these references to post to Firebase
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }

    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }

    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }

    var REF_USERS_CURRENT: DatabaseReference {
        // get unique keychain value (import keychainwrapper)
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user

    }

    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }

    // We can get uid when we authenticate
    func createdFirebaseUser(uid: String, userData: Dictionary<String, String>) {

        // reference to where we want to write to, if a uid does not already exist then Firebase will create a new uid (for a new user)
        REF_USERS.child(uid).updateChildValues(userData)
    }

}
