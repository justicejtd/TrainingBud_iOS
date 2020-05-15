//
//  PickSkillLevelViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 16/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class PickSkillLevelViewController: UIViewController {
	
	@IBOutlet weak var borderView1: UIView!
	@IBOutlet weak var borderView2: UIView!
	@IBOutlet weak var borderView3: UIView!
	
	@IBOutlet weak var stackViewBeginner: UIStackView!
	@IBOutlet weak var stackViewIntermediate: UIStackView!
	@IBOutlet weak var stackViewAdvanced: UIStackView!
	
	var pageViewController: SearchPageViewController!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		pageViewController = (self.parent as! SearchPageViewController)
		
		setupBorders()
		setupGestureRecognizers()
    }
	
	private func setupGestureRecognizers() {
		let gr1 = UITapGestureRecognizer(target: self, action: #selector(beginnerPressed))
		let gr2 = UITapGestureRecognizer(target: self, action: #selector(intermediatePressed))
		let gr3 = UITapGestureRecognizer(target: self, action: #selector(advancedPressed))
		
		stackViewBeginner.addGestureRecognizer(gr1)
		stackViewIntermediate.addGestureRecognizer(gr2)
		stackViewAdvanced.addGestureRecognizer(gr3)
	}
	
	private func setupBorders() {
		roundCorners(of: borderView1)
		roundCorners(of: borderView2)
		roundCorners(of: borderView3)
	}
	
	private func roundCorners(of view: UIView) {
		view.layer.borderColor = UIColor.gray.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = view.bounds.width / 2
		view.layer.masksToBounds = true
	}
	
	@objc func beginnerPressed() {
		skillLevelChosen(level: "Beginner")
	}
	
	@objc func intermediatePressed() {
		skillLevelChosen(level: "Intermediate")
	}
	
	@objc func advancedPressed() {
		skillLevelChosen(level: "Advanced")
	}
	
	private func skillLevelChosen(level: String) {
		pageViewController.prefs.skillLevel = level
		pageViewController.close()
	}
}
