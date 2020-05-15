//
//  SearchPageViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 02/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class SearchPageViewController: UIPageViewController {
	
	private lazy var controllers: [UIViewController] = {
		return [self.addViewController(with: "vcPickSport"),
				self.addViewController(with: "vcPickTime"),
				self.addViewController(with: "vcPickSkillLevel")]
	}()
	
	private var currentPageIndex: Int!
	
	var prefs: Preferences!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		prefs = Preferences()
		
		setupControllers(animated: true)
    }
	
	func setupControllers(animated: Bool) {
		if controllers.isEmpty {
			self.controllers.append(addViewController(with: "vcPickSport"))
			self.controllers.append(addViewController(with: "vcPickTime"))
			self.controllers.append(addViewController(with: "vcPickSkillLevel"))
		}
		
		currentPageIndex = 0
		
		if let firstViewController = controllers.first {
			setViewControllers([firstViewController],
							   direction: .forward,
							   animated: animated,
							   completion: nil)
		}
	}
	
	func close() {
		if let parent = self.parent as? PopupContainerViewController {
			print("Parent is \(parent)")
			Storage.storePreferences(preferences: prefs)
			
			let data:[String: Preferences] = ["prefs": prefs]
			let notificationName = Notification.Name(rawValue: Constants.Keys.PreferencesUpdated)
			NotificationCenter.default.post(Notification(name: notificationName,
														 object: nil,
														 userInfo: data))
			
			parent.closePopup(self)
		}
	}
	
	func reset() {
		print("Reset")
		prefs = Preferences()
		controllers = [UIViewController]()
		setupControllers(animated: false)
	}
	
	func goForward() {
		if currentPageIndex! < controllers.count {
			let nextIndex = currentPageIndex + 1
			self.setViewControllers([controllers[nextIndex]], direction: .forward, animated: true, completion: nil)
			currentPageIndex = nextIndex
		}
	}
	
	func goBackward() {
		if currentPageIndex! > 0 {
			let previousIndex = currentPageIndex - 1
			self.setViewControllers([controllers[previousIndex]], direction: .reverse, animated: true, completion: nil)
			currentPageIndex = previousIndex
		}
	}
	
	private func addViewController(with identifier: String) -> UIViewController {
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier)
		return vc
	}
}

//extension SearchPageViewController: UIPageViewControllerDelegate {
//}

//extension SearchPageViewController: UIPageViewControllerDataSource {
//	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//		guard let index = controllers.firstIndex(of: viewController) else { return nil }
//
//		let previousIndex = index - 1
//
//		guard previousIndex >= 0 else {
//			return nil
//		}
//
//		guard controllers.count > previousIndex else {
//			return nil
//		}
//
//		return controllers[previousIndex]
//	}
//
//	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//		guard let index = controllers.firstIndex(of: viewController) else { return nil }
//
//		let nextIndex = index + 1
//
//		guard controllers.count != nextIndex else {
//			return nil
//		}
//
//		guard controllers.count > nextIndex else {
//			return nil
//		}
//
//		return controllers[nextIndex]
//	}
//}
