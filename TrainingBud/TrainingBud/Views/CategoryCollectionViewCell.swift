//
//  CategoryCollectionViewCell.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

public class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lbSessionName: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbDateAndTime: UILabel!
    @IBOutlet weak var lbSessionType: UILabel!
    @IBOutlet weak var lbNrOfPeopleGoing: UILabel!
    @IBOutlet weak var lbSkillLevel: UILabel!
    var hostName: String!
	var gradient: (UIColor, UIColor)!
}
