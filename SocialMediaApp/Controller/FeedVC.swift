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

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var imageAdd: CircleView!
    
    // Initialize Array of Post objects
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    // global property b/c we will be using it multiple places
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        // Reference the database
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
            // Breakout into individual objects
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                // get each individual snapshot
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        // add to post property
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    // Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {

            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostCell()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("ANDREW: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }




    @IBAction func signOutButtonTapped(_ sender: UIButton) {

        // Remove ID from Keychain
        let keychainResults = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ANDREW: ID removed from keychain: \(keychainResults)")
        try! Auth.auth().signOut()

        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }

    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        print("imagePicker tapped")

        present(imagePicker, animated: true, completion: nil)
    }









}
