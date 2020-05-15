//
//  FindSessionViewController.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 02/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialChips

class OLD_FIND_SESSION: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var sessions: [TrainingSession] = []
	var displaySessions: [TrainingSession] = []
	let dbRef = Database.database().reference(withPath: "Sessions")
	let dbUserRef = Database.database().reference(withPath: "Users")
	var hostNames: [String] = []
	
	@IBOutlet weak var collectionView1: UICollectionView!
	@IBOutlet weak var stackViewFilter: UIStackView!
	@IBOutlet weak var btnSearch: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadControls()
		
		self.dbRef.observe(.value) { snapshot in
			var updatedSessions: [TrainingSession] = []
			for child in snapshot.children{
				if let snapshot = child as? DataSnapshot,
					let item = TrainingSession(snapshot: snapshot){
					let c = child as? DataSnapshot
					updatedSessions.append(item)
				}
			}
			self.sessions = updatedSessions
			self.displaySessions = updatedSessions
			self.collectionView1.reloadData()
		}
		
		
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.displaySessions.count
	}
	
	func loadControls(){
		let chipViewDuo = MDCChipView()
		chipViewDuo.titleLabel.text = "Duo"
		chipViewDuo.setTitleColor(UIColor.red, for: .selected)
		chipViewDuo.sizeToFit()
		chipViewDuo.addTarget(self, action: #selector(tap), for: .touchUpInside)
		
		let chipViewGroup = MDCChipView()
		chipViewGroup.titleLabel.text = "Group"
		chipViewGroup.setTitleColor(UIColor.red, for: .selected)
		chipViewGroup.sizeToFit()
		chipViewGroup.addTarget(self, action: #selector(tap), for: .touchUpInside)
		
		btnSearch.addTarget(self, action: #selector(search), for: .touchUpInside)
		
		self.stackViewFilter.addArrangedSubview(btnSearch)
		self.stackViewFilter.addArrangedSubview(chipViewDuo)
		self.stackViewFilter.addArrangedSubview(chipViewGroup)
	}
	
	@objc func tap() {
		
	}
	
	@objc func search() {
		let parent = self.parent as! MainViewController
		parent.showPopup()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindSessionCell", for: indexPath) as! FindSessionCellCollectionViewCell
		
		self.dbUserRef.child(self.sessions[indexPath.row].hostId).observeSingleEvent(of: .value, with: { snapshot in
			let user = User(snapshot: snapshot)!
			// cell.lbHostName.text = user.firstName + " " + user.lastName
			self.hostNames.append(user.firstName + " " + user.lastName)
		})
		
		cell.lbSportName.text = self.displaySessions[indexPath
			.row].sport
		cell.lbDescription.text = self.displaySessions[indexPath
			.row].getInformation()
		cell.imgHostPic.image = UIImage(named: "hostSample")
		
		//This creates the shadows and modifies the cards a little bit
		cell.contentView.layer.cornerRadius = 10.0
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UIColor.clear.cgColor
		cell.contentView.layer.masksToBounds = false
		cell.layer.shadowColor = UIColor.gray.cgColor
		cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
		cell.layer.shadowRadius = 4.0
		cell.layer.shadowOpacity = 1.0
		cell.layer.masksToBounds = false
		cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as?
			SelectedSessionViewController, let index =
			collectionView1.indexPathsForSelectedItems?.first {
			destination.selectedSession = displaySessions[index.row]
			destination.hostName = hostNames[index.row]
		}
	}
}

extension String {
	func toDate() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		
		return dateFormatter.date(from: self)
	}
	
	func toNeutralDate() -> Date? {
		let dateFormatter = DateFormatter()
		
		let date = self.toDate()!
		
		dateFormatter.dateFormat = "HH:mm"
		let time = dateFormatter.string(from: date)
		
		let newDate = "2000-01-01 \(time)"
		
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		
		return dateFormatter.date(from: newDate)
	}
}

extension Date {
	func isBetween(_ date1: Date, and date2: Date) -> Bool {
		return (min(date1, date2) ... max(date1, date2)) ~= self
	}
}
