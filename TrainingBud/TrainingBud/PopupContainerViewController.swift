//
//  PopupContainerViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 03/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class PopupContainerViewController: UIViewController {
	private var searchPageViewController: SearchPageViewController!
	private var mainViewController: MainViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.layer.cornerRadius = 15
		
		if let pageViewController = self.children.first as? SearchPageViewController {
			searchPageViewController = pageViewController
		}
    }
	
	public func setMainVC(mainViewController: MainViewController) {
		self.mainViewController = mainViewController
	}
	
	@IBAction func closePopup(_ sender: Any) {
		mainViewController.hidePopup() {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
				self.searchPageViewController.reset()
			})
		}
	}
}
