//
//  ParticipantViewCell.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 09/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase

class ParticipantViewCell: UICollectionViewCell {

    @IBOutlet weak var imgProfilePic: UIImageView!

    var selectedParticipant: String!
    let dbRef = Database.database().reference().child("users")
    let currentUser = Auth.auth().currentUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func addBuddy(_ sender: Any) {
    }
}
