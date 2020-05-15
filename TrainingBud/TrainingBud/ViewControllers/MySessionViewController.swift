//
//  MySessionViewController.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 15/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialChips

class MySessionViewController: UIViewController{
	
	@IBOutlet weak var gradientView: GradientView!
	
	@IBOutlet weak var overlayView: UIView!
	
        @IBOutlet weak var tableViewCategories: UITableView!
        var sessions: [TrainingSession] = []
        let dbRef = Database.database().reference(withPath: "Sessions")
        let dbUserRef = Database.database().reference(withPath: "Users")
        var hostNames: [String] = []
        var categories: [String] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadControler()
			
			gradientView.setGradientColor(color: Constants.Colors.Main)
    //        let sess = TrainingSession(name: "SlowCyclists", sport: "Cycling", startDate: "23 April 2020 19:00", endDate: "23 April 20:00", description: "Hey I am looking for a slow team", hostId: String(describing: Auth.auth().currentUser?.uid), location: "Strijp s 111", city: "Eindhoven", nrOfParticipants: 15, type: "Group")
    //                sess.participants.append(Auth.auth().currentUser!.uid)
          //  self.dbRef.childByAutoId().setValue(sess.toAnyObject())
            
            self.dbRef.observe(.value) { snapshot in
                var updatedSessions: [TrainingSession] = []
                for child in snapshot.children{
                    if let snapshot = child as? DataSnapshot,
                        let session = TrainingSession(snapshot: snapshot){
                        let c = child as? DataSnapshot
                        if (session.hostId == Auth.auth().currentUser?.uid){
                            updatedSessions.append(session)
                        }
                    }
                }
                self.sessions = updatedSessions
                self.loadCategories()
				print("Categories loaded - \(self.categories)")
				if self.categories.isEmpty {
					self.showOverlay()
				}
				else {
					self.hideOverlay()
					self.tableViewCategories.reloadData()
				}
            }
        }
	
	private func showOverlay() {
		overlayView.isHidden = false
	}
	
	private func hideOverlay() {
		overlayView.isHidden = true
	}
        
        func loadCategories() {
            categories = []
            for s in sessions{
                if (!categories.contains(s.sport)){
                    categories.append(s.sport)
                }
            }
        }
        
        func loadControler(){
            tableViewCategories.layer.cornerRadius = 20.0
            tableViewCategories.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }

        @IBAction func search(_ sender: Any) {
            let parent = self.parent as! MainViewController
            parent.showPopup()
        }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    }

    extension MySessionViewController: UITableViewDelegate, UITableViewDataSource {
     
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell else {fatalError("Unable to create category table view cell")}
            let category = categories[indexPath.row]
            cell.lbCategoryName.text = category
            cell.navigationController = navigationController

            cell.sessions = sessions.filter({ t -> Bool in
                return t.sport == category
            })
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
        }
    }
