//
//  DesignView.swift
//  SocialMediaApp
//
//  Created by Andrew Jenson on 1/19/18.
//  Copyright © 2018 Andrew Jenson. All rights reserved.
//

import UIKit

class DesignView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0 // how far the shadow spans out
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        
    }

}
