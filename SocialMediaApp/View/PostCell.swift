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

    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // If the image is not in our cache then we need to download it (optional)
    // img: has a default value of nil
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
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
    }

    




    

}
