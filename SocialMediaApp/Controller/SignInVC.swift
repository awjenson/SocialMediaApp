//
//  SignInVC.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/18/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: DesignTextField!

    @IBOutlet weak var passwordTextField: DesignTextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // NOTE: Do not call a segue in viewDidLoad (too early).
    }

    override func viewDidAppear(_ animated: Bool) {
        // Segues to be performed in the beginning need to occur after the view loaded.
        // Check if a key already exists, then segue to next VC
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("ANDREW: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {

        // 2 steps to authenticate with Facebook
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ANDREW: Unable to auth with FB, \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("ANDREW: User cancelled FB auth")
            } else {
                print("ANDREW: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                // call method with successful credential
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credential: AuthCredential) {
        // Auth with Firebase
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("ANDREW: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("ANDREW: Successfully authenticated with Firebase")
                // Add a string value to keychain
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }

    @IBAction func signInTapped(_ sender: Any) {

        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    // Success (no error)
                    print("ANDREW: Email user authenticated with Firebase")
                } else {
                    // Error
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("ANDREW: Unable to authenticate with Firebase using email")
                            // Add a string value to keychain
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        } else {
                            print("ANDREW: Successfully authenticate with Firebase")
                            // Add a string value to keychain
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }

    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createdFirebaseUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ANDREW: Data saved to keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}
