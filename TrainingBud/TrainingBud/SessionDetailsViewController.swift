//
//  SessionDetailsViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase

class SessionDetailsViewController: UIViewController {
	
    @IBOutlet weak var lbSkillLevel: UILabel!
    @IBOutlet weak var lbName: UILabel!
	@IBOutlet weak var lbDate: UILabel!
	@IBOutlet weak var lbNrGoing: UILabel!
	@IBOutlet weak var detailView: UIView!
	@IBOutlet weak var lbType: UILabel!
	@IBOutlet weak var btnJoin: UIButton!
	@IBOutlet weak var lbDescription: UILabel!
	@IBOutlet weak var lbLocation: UILabel!
	@IBOutlet weak var collectionViewParticipants: UICollectionView!
	
	@IBOutlet weak var gradientView: GradientView!
	
	var currentSession: TrainingSession!
    var currentUserId: String = Auth.auth().currentUser!.uid
	var participants: [User] = [User]()
    var dbRefSession = Database.database().reference(withPath: "Sessions")
    var backgroundColor: (UIColor, UIColor)!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		populateData()
		fetchUsers()
		
		self.collectionViewParticipants.delegate = self
		self.collectionViewParticipants.dataSource = self
		if (currentUserId == currentSession.hostId){
			self.btnJoin.isEnabled = false
			self.btnJoin.isHidden = true
		}
		else{
			if self.currentSession.participants.contains(currentUserId){
				self.btnJoin.setTitle("Leave", for: UIControl.State.normal)
				self.btnJoin.setTitleColor(UIColor.red, for: UIControl.State.normal)
			}
			else{
				self.btnJoin.setTitle("Join", for: UIControl.State.normal)
				self.btnJoin.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
			}
		}
	}
	
	@IBAction func goBack(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	private func addParticipant(participant: User) {
        self.participants.append(participant)
		self.collectionViewParticipants.reloadData()
	}
	
	func fetchUsers() {
        //Update when someone has join or leave
		print("Fetching users for session ID: \(self.currentSession.id)")
		self.dbRefSession.child(self.currentSession.id).observe(.value) { snapshot in
            let value = snapshot.value as? [String: AnyObject]
            self.currentSession.participants = value?["participants"] as! [String]
            self.participants = []
            for participant in self.currentSession.participants {
				print("Participant: \(participant)")
                let dbUserRef = Database.database().reference(withPath: "Users").child(participant)
                dbUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let user = User(snapshot: snapshot) {
                        self.addParticipant(participant: user)
                    }
                })
            }
            self.populateData()
        }
	}
	
	func setupViews(){
//        let gradientTopView = viewTop.layer.backgroundColor = self.backgroundColor as! CGColor
		detailView.layer.cornerRadius = 25
		detailView.layer.masksToBounds = false
		detailView.layer.shadowColor = UIColor.black.cgColor
		detailView.layer.shadowOffset = CGSize(width: 0, height: 10)
		detailView.layer.shadowOpacity = 0.24
		detailView.layer.shadowRadius = CGFloat(10)
		
		gradientView.setGradientColor(color: currentSession.backgroundColor)
		
		view.bringSubviewToFront(detailView)
	}
	
	private func populateData(){
		self.lbName.text = currentSession.name
		self.lbLocation.text = currentSession.location
		self.lbType.text = currentSession.type
		self.lbNrGoing.text = "\(currentSession.participants.count) going"
		self.lbDescription.text = self.currentSession.description
        self.lbSkillLevel.text = "\(self.currentSession.skillLevel) level"
		let df = DateFormatter()
		df.dateFormat = "d MMMM"
		
		let startDate = currentSession.startDate.toDate()
		let endDate = currentSession.endDate.toDate()
		
		let sessionDate = df.string(from: startDate!)
		
		df.dateFormat = "HH:mm"
		
		let startTime = df.string(from: startDate!)
		let endTime = df.string(from: endDate!)
		
		self.lbDate.text = "\(sessionDate) | \(startTime) - \(endTime)"
	}
	
	@IBAction func join_onClick(_ sender: UIButton){
		if self.currentSession.participants.contains(currentUserId){
			self.btnJoin.setTitle("Join", for: UIControl.State.normal)
			self.btnJoin.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
			self.currentSession.participants.removeAll { uId -> Bool in
				return uId == currentUserId
			}
			self.dbRefSession.child(self.currentSession.id).child("participants").setValue(self.currentSession.participants)
		}
		else{
			self.btnJoin.setTitle("Leave", for: UIControl.State.normal)
			self.btnJoin.setTitleColor(UIColor.red, for: UIControl.State.normal)
			self.currentSession.participants.append(currentUserId)
			self.dbRefSession.child(self.currentSession.id).child("participants").setValue(self.currentSession.participants)
		}
	}
}

extension SessionDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return participants.count
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionViewParticipants.cellForItem(at: indexPath) as! ParticipantViewCell
		if let profileImage = cell.imgProfilePic.image {
			let user = participants[indexPath.row]
			showUserProfile(for: user, with: profileImage)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantCell", for: indexPath) as! ParticipantViewCell
		let imageName = String(format: "profile%01d", (indexPath.row + 1))
		cell.imgProfilePic?.image = UIImage(named: imageName)
		cell.imgProfilePic.layer.cornerRadius = 20
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 100, height: 100)
	}
}
