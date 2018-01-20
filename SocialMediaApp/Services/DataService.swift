//
//  DataService.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/20/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import Foundation
import Firebase

// Global Variable

// Database URL located in GoogleService-Info.plist
let DB_BASE = Database.database().reference()

class DataService {

    static let ds = DataService()

    private var _REF_BASE = DB_BASE  // socialmediaapp-190be
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")

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

    // We can get uid when we authenticate
    func createdFirebaseUser(uid: String, userData: Dictionary<String, String>) {

        // reference to where we want to write to, if a uid does not already exist then Firebase will create a new uid (for a new user)
        REF_USERS.child(uid).updateChildValues(userData)

    }

}
