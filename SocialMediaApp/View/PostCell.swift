//
//  PostCell.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/20/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!

    var post: Post!
    var likesRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Creat tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true

    }

    // If the image is not in our cache then we need to download it (optional)
    // img: has a default value of nil
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USERS_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"

        // This is where we are going to download the images from Firebase
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: (2 * 1024 * 1024), completion: { (data, error) in
                if error != nil {
                    print("ANDREW: Unable to download image from Firebase Storage")
                } else {
                    print("ANDREW: Image downloaded from Firebase Storage")
                    // Save data to cache
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }

        // When this cell is configured, it checks if the image has been like by the user, and display an empty-heart if the user has not liked the image, and display a filled-heart if the user has liked the image.

        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            // Firebase works with JSON which uses Null (not nil)
            if let _ = snapshot.value as? NSNull {
                // If this is null, then set our like image
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                // User has liked it
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        }

    }

    @objc func likeTapped(sender: UITapGestureRecognizer) {

        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            // Firebase works with JSON which uses Null (not nil)
            if let _ = snapshot.value as? NSNull {
                // If this is null, then set our like image
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                // User has liked it
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        }
    }

    

    




    

}
