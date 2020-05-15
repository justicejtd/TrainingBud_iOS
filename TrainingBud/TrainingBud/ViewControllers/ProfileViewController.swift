//
//  ProfileViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 19/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FittedSheets

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var gradientView: GradientView!
	
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var profileView: UIView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	
	@IBOutlet weak var buddiesCollectionView: UICollectionView!
	@IBOutlet weak var interestsCollectionView: UICollectionView!
	
	private var buddies: [User] = [User]()
	private var interests: [String] = [String]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		gradientView.setGradientColor(color: Constants.Colors.Main)
		
		fetchInterests()
		setupViews()
    }
		
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let mainVC = self.parent as? MainViewController {
			self.cityLabel.text = mainVC.currentCity
		}
		resetBuddies()
        fetchBuddies()
	}
	
	private func fetchInterests() {
		let dbUserRef = Database.database().reference(withPath: "Users")
		if let currentUserId = Auth.auth().currentUser?.uid {
			dbUserRef.child(currentUserId).child("interests").observeSingleEvent(of: .value) { (snapshot) in
				for child in snapshot.children.allObjects as! [DataSnapshot] {
					if let interest = child.value as? String {
						self.interests.append(interest)
					}
				}
				self.interestsCollectionView.reloadData()
			}
		}
	}
	
	private func fetchBuddies() {
		let dbUserRef = Database.database().reference(withPath: "Users")
		if let currentUserId = Auth.auth().currentUser?.uid {
			dbUserRef.child(currentUserId).child("buddies").observeSingleEvent(of: .value, with: { snapshot in
				for child in snapshot.children.allObjects as! [DataSnapshot] {
					if let buddyId = child.value as? String {
						dbUserRef.child(buddyId).observeSingleEvent(of: .value) { snap in
							if let user = User(snapshot: snap) {
								self.addBuddy(buddy: user)
							}
						}
					}
				}
			})
		}
	}
	
	private func addBuddy(buddy: User) {
		self.buddies.append(buddy)
		self.buddiesCollectionView.reloadData()
	}
	
	private func resetBuddies() {
		self.buddies = [User]()
		self.buddiesCollectionView.reloadData()
	}
	
	private func addInterest(interest: String) {
		// Add locally in collection view
		self.interests.append(interest)
		var indexPaths = [IndexPath]()
		let index = self.interests.count - 1
		indexPaths.append(IndexPath(row: index, section: 0))
		self.interestsCollectionView.insertItems(at: indexPaths)
		
		// Upload to Firebase
		let dbUserRef = Database.database().reference(withPath: "Users")
		if let currentUserId = Auth.auth().currentUser?.uid {
			dbUserRef.child(currentUserId).child("interests").child("\(index)").setValue(interest)
		}
	}
	
	private func removeInterest(interest: String) {
		// Remove locally
		let index = self.interests.firstIndex(of: interest)!
		self.interests.remove(at: index)
		var indexPaths = [IndexPath]()
		indexPaths.append(IndexPath(row: index, section: 0))
		self.interestsCollectionView.deleteItems(at: indexPaths)
		
		// Remove from firebase
		let dbUserRef = Database.database().reference(withPath: "Users")
		if let currentUserId = Auth.auth().currentUser?.uid {
			dbUserRef.child(currentUserId).child("interests").child("\(index)").setValue(nil)
		}
    }
	
	
	private func removeBuddy(buddy: User) {
		// Remove locally
		let index = self.buddies.firstIndex(of: buddy)!
		self.buddies.remove(at: index)
		var indexPaths = [IndexPath]()
		indexPaths.append(IndexPath(row: index, section: 0))
		self.buddiesCollectionView.deleteItems(at: indexPaths)
		
		 //Remove from firebase
		let dbUserRef = Database.database().reference(withPath: "Users")
		if let currentUserId = Auth.auth().currentUser?.uid {
			dbUserRef.child(currentUserId).child("buddies").child("\(index)").setValue(nil)
        }
    }
	
	@IBAction func signOutu(_ sender: Any) {
		try! Auth.auth().signOut()
	}
	
	@IBAction func addInterest(_ sender: Any) {
		let alertController = UIAlertController(title: "Add new interest", message: "", preferredStyle: UIAlertController.Style.alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
			(action : UIAlertAction!) -> Void in })
		
		let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
			let interestTextField = alertController.textFields![0] as UITextField
			if let interest = interestTextField.text {
				self.addInterest(interest: interest)
			}
		})
		
		alertController.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Interest"
			textField.autocapitalizationType = .words
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	private func setupViews() {
		profileView.layer.cornerRadius = 15
		profileView.layer.masksToBounds = false
		profileView.layer.shadowColor = UIColor.black.cgColor
		profileView.layer.shadowOffset = CGSize(width: 0, height: 10)
		profileView.layer.shadowOpacity = 0.24
		profileView.layer.shadowRadius = CGFloat(10)
		profileView.layer.opacity = 0.97
		
		profileImage.layer.cornerRadius = profileImage.layer.bounds.width / 2
		
		nameLabel.text = Auth.auth().currentUser?.displayName
		
		buddiesCollectionView.delegate = self
		interestsCollectionView.delegate = self
		
		buddiesCollectionView.dataSource = self
		interestsCollectionView.dataSource = self
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.buddiesCollectionView {
			return buddies.count
		}
		else {
			return interests.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == buddiesCollectionView {
			let cell = buddiesCollectionView.cellForItem(at: indexPath) as! ParticipantViewCell
			if let profileImage = cell.imgProfilePic.image {
				let buddy = buddies[indexPath.row]
				showUserProfile(for: buddy, with: profileImage)
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.buddiesCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantCell", for: indexPath) as! ParticipantViewCell
			let imageName = String(format: "profile%01d", (indexPath.row + 1))
			cell.imgProfilePic?.image = UIImage(named: imageName)
			cell.imgProfilePic.layer.cornerRadius = 20
			
			return cell
		}
		else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
			cell.titleLabel.text = interests[indexPath.row]
			cell.titleLabel.textColor = .white
			cell.layer.cornerRadius = 20
			
			cell.bringSubviewToFront(cell.titleLabel)
			
			cell.configureCell()

			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView == self.buddiesCollectionView {
			return CGSize(width: 100, height: 100)
		}
		return CGSize(width: 150, height: 20)
	}
}

extension ProfileViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		if collectionView == interestsCollectionView {
			let configuration = UIContextMenuConfiguration(identifier: "\(indexPath.row)" as NSCopying, previewProvider: {
				return nil
			}){ action in
				let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
					let interest = self.interests[indexPath.row]
					print("Delete clicked for \(interest)")
					self.removeInterest(interest: interest)
				})
				
				return UIMenu(title: "", image: nil, identifier: nil, children: [delete])
			}
			
			return configuration
		}
		else {
			let configuration = UIContextMenuConfiguration(identifier: "\(indexPath.row)" as NSCopying, previewProvider: {
				return nil
			}){ action in
				let delete = UIAction(title: "Remove", image: UIImage(systemName: "xmark.circle"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
					let buddy = self.buddies[indexPath.row]
					print("Remove clicked for \(buddy.Name())")
					self.removeBuddy(buddy: buddy)
				})
				
				return UIMenu(title: "", image: nil, identifier: nil, children: [delete])
			}
			
			return configuration
		}
	}
}

extension UIView {
	func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor]) {
		layer.frame = gradientFrame ?? self.bounds
		layer.frame.origin = .zero
		
		let locations = [0.0, 1.0]
		
		let layerColorSet = colorSet.map { $0.cgColor }
		let layerLocations = locations.map { $0 as NSNumber }
		
		layer.colors = layerColorSet
		layer.locations = layerLocations
		
		layer.startPoint = CGPoint(x: 0, y: 0.5)
		layer.endPoint = CGPoint(x: 1, y: 0.5)
		
		self.layer.insertSublayer(layer, at: 0)
	}
}

extension UIViewController {
	func showUserProfile(for buddy: User, with profileImage: UIImage) {
		let controller = BuddyDetailsViewController.instantiate(buddy: buddy, profileImage: profileImage)
		let stringSizes = ["550", "550"]
		var sizes: [SheetSize] = stringSizes.compactMap({
			Int($0.trimmingCharacters(in: .whitespacesAndNewlines))
		}).map({
			SheetSize.fixed(CGFloat($0))
		})
		sizes.append(.halfScreen)
		
		let sheetController = SheetViewController(controller: controller, sizes: sizes)
		sheetController.adjustForBottomSafeArea = false
		sheetController.blurBottomSafeArea = true
		sheetController.dismissOnBackgroundTap = true
		sheetController.extendBackgroundBehindHandle = false
		sheetController.topCornersRadius = 15
		
		self.present(sheetController, animated: false, completion: nil)
	}
}
