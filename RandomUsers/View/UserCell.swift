//
//  UserCell.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 10/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {

    static let cellIdentifier = "UserCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var savedLabel: UILabel!

    func setUser(user: UserProtocol) {
        self.userName.text  = user.getName()
        self.userEmail.text = user.getEmail()
        self.userImageView.sd_setImage(with: user.getImageUrl(), completed: nil)
    }
    
    func setSaved(saved: Bool) {
        self.savedLabel.isHidden = !saved
    }
    
}
