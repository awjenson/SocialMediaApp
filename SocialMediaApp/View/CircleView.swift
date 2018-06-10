//
//  CircleView.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/20/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews(){
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
