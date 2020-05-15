//
//  SportCell.swift
//  TrainingBud
//
//  Created by Zachary G. on 02/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class SportCell: UITableViewCell {
	@IBOutlet weak var iconBorderImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	
	@IBOutlet weak var nameLabel: UILabel!
	
	func setSport(sport: Sport) {
		iconBorderImageView.layer.borderColor = UIColor.gray.cgColor
		iconBorderImageView.layer.borderWidth = 1
		iconBorderImageView.layer.cornerRadius = iconBorderImageView.bounds.width / 2
		iconBorderImageView.layer.masksToBounds = true
		
		iconImageView.image = sport.icon
		nameLabel.text = sport.name
	}
}
