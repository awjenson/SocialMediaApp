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
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var likeImg: UIImageView!
    


    // Initialize Array of Post objects
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    // global property b/c we will be using it multiple places
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false

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

            // Image Cache Logic
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("ANDREW: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text! as AnyObject,
        "imageUrl": imageUrl as AnyObject,
        "likes": 0 as AnyObject
        ]

        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)

        // Reset UI after successful post
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")

        tableView.reloadData()
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

    @IBAction func postButtonTapped(_ sender: Any) {

        // Only can post if an image has been selected
        guard let caption = captionField.text, caption != "" else {
            print("ANDREW: caption must be entered")
            return
        }

        guard let img = imageAdd.image, imageSelected == true else {
            print("ANDREW: An image must be selected")
            return
        }

        if let imgData = UIImageJPEGRepresentation(img, 0.2) {

            // Get a random string of characters
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("ANDREW: Unable to upload image to Firebase Storage")
                } else {
                    print("ANDREW: Sucessfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                    }
                }
            })
        }
    }
    









}
