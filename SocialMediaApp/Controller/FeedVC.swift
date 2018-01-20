//
//  FeedVC.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/20/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

    }

    // Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }


    @IBAction func signOutButtonTapped(_ sender: UIButton) {

        // Remove ID from Keychain
        let keychainResults = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ANDREW: ID removed from keychain: \(keychainResults)")
        try! Auth.auth().signOut()

        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }

}
