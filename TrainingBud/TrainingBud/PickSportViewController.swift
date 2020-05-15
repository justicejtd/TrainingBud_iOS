//
//  BlueViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 02/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

public struct Sport {
	let icon: UIImage!
	let name: String!
}

class PickSportViewController: UIViewController {
	@IBOutlet weak var sportsTableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var pageViewController: SearchPageViewController!
	
	var sports = [Sport]()
	var currentSports = [Sport]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		pageViewController = (self.parent as! SearchPageViewController)
		
		setupTableView()
		setupSearchBar()
    }
}

extension PickSportViewController: UISearchBarDelegate {
	private func setupSearchBar() {
		searchBar.delegate = self
		searchBar.searchTextField.clearButtonMode = .whileEditing
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.searchTextField.resignFirstResponder()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		searchBar.setShowsCancelButton(false, animated: true)
		currentSports = sports
		sportsTableView.reloadData()
		searchBar.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard !searchText.isEmpty else {
			currentSports = sports
			sportsTableView.reloadData()
			return
		}
		
		searchBar.setShowsCancelButton(true, animated: true)
		
		currentSports = sports.filter({ sport -> Bool in
			return sport.name.lowercased().starts(with: searchText.lowercased())
		})
		sportsTableView.reloadData()
	}
}

extension PickSportViewController: UITableViewDelegate {
	private func setupTableView() {
		sportsTableView.delegate = self
		sportsTableView.dataSource = self
		
		sportsTableView.backgroundColor = UIColor.white
		sportsTableView.layer.cornerRadius = 15
		
		setupSports()
	}
	
	private func setupSports() {
		let basketball = Sport.init(icon: UIImage(named: "basketball"), name: "Basketball")
		let football = Sport.init(icon: UIImage(named: "football"), name: "Football")
		let swimming = Sport.init(icon: UIImage(named: "swimming"), name: "Swimming")
		let tennis = Sport.init(icon: UIImage(named: "tennis"), name: "Tennis")
		let running = Sport.init(icon: UIImage(named: "running"), name: "Running")
		let cycling = Sport.init(icon: UIImage(named: "cycling"), name: "Cycling")
		let golf = Sport.init(icon: UIImage(named: "golf"), name: "Golf")
		
		sports = [basketball, football, swimming, tennis, running, cycling, golf]
		currentSports = sports
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sport = currentSports[indexPath.row]
		tableView.deselectRow(at: indexPath, animated: true)
		
		pageViewController.prefs.sport = sport.name
		pageViewController.goForward()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}
}

extension PickSportViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currentSports.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let sport = currentSports[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell") as! SportCell
		
		cell.setSport(sport: sport)
		
		cell.selectionStyle = .blue
		
		return cell
	}
}
