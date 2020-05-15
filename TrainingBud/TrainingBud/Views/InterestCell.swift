//
//  InterestCell.swift
//  TrainingBud
//
//  Created by Zachary G. on 19/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	
	let gradientLayer = CAGradientLayer()
	
	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradientLayer.frame = self.bounds
	}
	
	func configureCell() {
		let color = Constants.Colors.All[Int.random(in: 0 ... Constants.Colors.All.count - 1)]
		let colorSet = [color.0!, color.1!]

		self.contentView.addGradient(with: gradientLayer, colorSet: colorSet)
		self.bringSubviewToFront(titleLabel)
	}
}
