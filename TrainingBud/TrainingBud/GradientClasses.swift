//
//  GradientButton.swift
//  TrainingBud
//
//  Created by Zachary G. on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
class GradientButton: UIButton {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
		self.setTitleColor(UIColor.white, for: .normal)
		self.backgroundColor = UIColor.white
	}
	
	private lazy var gradientLayer: CAGradientLayer = {
		let l = CAGradientLayer()
		l.frame = self.bounds
		l.colors = [Constants.Colors.Main.0.cgColor, Constants.Colors.Main.1.cgColor]
		l.startPoint = CGPoint(x: 0, y: 0.5)
		l.endPoint = CGPoint(x: 1, y: 0.5)
		l.cornerRadius = 23
		layer.insertSublayer(l, at: 0)
		return l
	}()
}

class GradientView: UIView {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
	}
	
	var cornerRadius: CGFloat = 0
	
	private lazy var gradientLayer: CAGradientLayer = {
		let l = CAGradientLayer()
		l.frame = self.bounds
		l.colors = [Constants.Colors.Main.0.cgColor, Constants.Colors.Main.1.cgColor]
		l.startPoint = CGPoint(x: 0, y: 0.5)
		l.endPoint = CGPoint(x: 1, y: 0.5)
		l.cornerRadius = self.cornerRadius
//		layer.insertSublayer(l, at: 0)
		return l
	}()
	
	func setGradientColor(color: (UIColor, UIColor)) {
		gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [color.0.cgColor, color.1.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		gradientLayer.cornerRadius = self.cornerRadius
		layer.insertSublayer(gradientLayer, at: 0)
		super.layoutSubviews()
		gradientLayer.frame = bounds
	}
}

