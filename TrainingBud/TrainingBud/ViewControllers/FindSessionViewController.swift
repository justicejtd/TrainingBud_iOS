//
//  FindSessionViewController.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase

class FindSessionViewController: UIViewController {
	@IBOutlet weak var tableViewCategories: UITableView!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var clearFiltersButton: UIButton!
	
	@IBOutlet weak var gradientView: GradientView!
	
	var sessions: [TrainingSession] = []
	let dbRef = Database.database().reference(withPath: "Sessions")
	let dbUserRef = Database.database().reference(withPath: "users")
	var hostNames: [String] = []
	var categories: [String] = []
	
	var prefs: Preferences?
	
	var displayCategories: [String] = []
	
	var displaySessions: [TrainingSession] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableViewCategories.delegate = self
		tableViewCategories.dataSource = self
		
		gradientView.setGradientColor(color: Constants.Colors.Main)
		
		let spacing: CGFloat = 10.0
		clearFiltersButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
		clearFiltersButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
		
		clearFiltersButton.semanticContentAttribute = UIApplication.shared
			.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
		
		self.dbRef.observe(.value) { snapshot in
			var updatedSessions: [TrainingSession] = []
			for child in snapshot.children{
				if let snapshot = child as? DataSnapshot,
					let session = TrainingSession(snapshot: snapshot) {
					let c = child as? DataSnapshot
					if let sessionStartDate = session.startDate.toDate() {
						if sessionStartDate >= Date() {
							updatedSessions.append(session)
						}
					}
				}
			}
			self.sessions = updatedSessions
			self.loadCategories()
			
			if let storedPrefs = Storage.getPreferences() {
				self.prefs = storedPrefs
				self.filterResults(preferences: storedPrefs)
			}
			else {
				self.tableViewCategories.reloadData()
			}
		}
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(filterResults(_:)),
											   name: Notification.Name(rawValue: Constants.Keys.PreferencesUpdated),
											   object: nil)
	}
	
	private func showClearFiltersButton() {
		searchButton.isHidden = true
		searchButton.isEnabled = false
		
		clearFiltersButton.isHidden = false
		clearFiltersButton.isEnabled = true
		
		titleLabel.text = "Suggested for you"
	}
	
	private func showSearchButton() {
		searchButton.isHidden = false
		searchButton.isEnabled = true
		
		clearFiltersButton.isHidden = true
		clearFiltersButton.isEnabled = false
		
		titleLabel.text = "All sessions"
	}
	
	private func clearFilters() {
		Storage.clearPreferences()
		self.displayCategories = self.categories
		self.prefs = nil
		self.tableViewCategories.reloadData()
		self.showSearchButton()
	}
	
	@objc func filterResults(_ notification: NSNotification) {
		if let prefs = notification.userInfo?["prefs"] as? Preferences {
			filterResults(preferences: prefs)
		}
	}
	
	private func filterResults(preferences: Preferences) {
		self.displayCategories = self.categories.filter({ (category) -> Bool in
			let sportMatches = category.lowercased() == preferences.sport.lowercased()
			
			self.prefs = preferences
			
			return sportMatches
		})
		self.tableViewCategories.reloadData()
		self.showClearFiltersButton()
	}
	
	func loadCategories() {
		categories = []
		for s in sessions {
			if (!categories.contains(s.sport)){
				categories.append(s.sport)
			}
		}
		displayCategories = categories
	}
	
	@IBAction func search(_ sender: Any) {
		let parent = self.parent as! MainViewController
		parent.showPopup()
	}
	
	@IBAction func clearFilters(_ sender: Any) {
		clearFilters()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

extension FindSessionViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayCategories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell else {fatalError("Unable to create category table view cell")}
		let category = displayCategories[indexPath.row]
		cell.lbCategoryName.text = category
		cell.navigationController = navigationController
		
		cell.sessions = sessions.filter({ session -> Bool in
			var matchesFilterCriteria = false
			let matchesSport = session.sport.lowercased() == category.lowercased()
			
			if let prefs = prefs {
				if prefs.timePreference == "Interval" {
					let pStartDate = prefs.startDate!
					let pEndDate = prefs.endDate!
					
					guard let sStartDate = session.startDate.toNeutralDate(),
						let sEndDate = session.endDate.toNeutralDate() else {
							print("Failed to parse dates")
							return false
					}
					
					let fallsBetween = pStartDate.isBetween(sStartDate, and: sEndDate) &&
						pEndDate.isBetween(sStartDate, and: sEndDate)
					
					print("Prefs start date: \(pStartDate.description), Prefs end date: \(pEndDate.description)")
					print("Session start date: \(sStartDate.description), Session end date: \(sEndDate.description)")
					print("Falls between: \(fallsBetween)")
					
					matchesFilterCriteria = fallsBetween
				}
				else {
					matchesFilterCriteria = true
				}
			}
			else {
				return matchesSport
			}
			
			print("Display sessions: \(displaySessions)")
			print("Cell sessions: \(cell.sessions)")
			
			print("Reloading data")
			cell.collectionViewSessions.reloadData()
			
			return matchesSport && matchesFilterCriteria
		})
		cell.collectionViewSessions.reloadData()
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 300
	}
}
