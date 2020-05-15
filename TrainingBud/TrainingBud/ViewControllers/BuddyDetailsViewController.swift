//
//  BuddyDetailsViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 21/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase

class BuddyDetailsViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var btnAddBuddy: GradientButton!
    
    static var user: User!
    static var profileImage: UIImage!
    var userId = Auth.auth().currentUser!.uid
    let dbRef = Database.database().reference(withPath: "Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 20
        profileImage.image = BuddyDetailsViewController.profileImage
        
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        
        self.nameLabel.text = BuddyDetailsViewController.user.Name()
        
        self.dbRef.child(userId).observe(.value, with: { snapshot in
            let user = User(snapshot: snapshot)
            let buddies = user!.buddies
            if (BuddyDetailsViewController.user.id != self.userId){
                if (buddies.contains(BuddyDetailsViewController.user.id)){
                    self.btnAddBuddy.setTitle("Unfollow", for: UIControl.State.normal)
                    self.btnAddBuddy.setTitleColor(UIColor.red, for: UIControl.State.normal)
                    self.btnAddBuddy.isHidden = true
                    self.btnAddBuddy.isEnabled = false
                }
                else{
                    self.btnAddBuddy.setTitle("Follow", for: UIControl.State.normal)
                    
                    self.btnAddBuddy.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
                }
                
            }
            else{
                self.btnAddBuddy.isEnabled = false
                self.btnAddBuddy.isHidden = true
            }
        })
        
    }
    
    static func instantiate(buddy: User, profileImage: UIImage) -> BuddyDetailsViewController {
        BuddyDetailsViewController.user = buddy
        BuddyDetailsViewController.profileImage = profileImage
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "buddyDetails") as! BuddyDetailsViewController
    }
    
    @IBAction func addBuddy(_ sender: Any) {
        self.dbRef.child(userId).observeSingleEvent(of: .value, with: { snapshot in
            print("test")
            let user = User(snapshot: snapshot)!
            var buddies = user.buddies
            if (buddies.contains(BuddyDetailsViewController.user.id)){
                buddies.removeAll { uId -> Bool in
                    return uId == BuddyDetailsViewController.user.id
                }
                if (buddies.count == 0){
                    buddies.append("")
                }
                print(buddies)
                self.dbRef.child(self.userId).child("buddies").setValue(buddies)
            }
            else{
                print("test3")
                buddies.append(BuddyDetailsViewController.user.id)
                self.dbRef.child(self.userId).child("buddies").setValue(buddies)
            }
        }
        )}
}

extension BuddyDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BuddyDetailsViewController.user.interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.titleLabel.text = BuddyDetailsViewController.user.interests[indexPath.row]
        cell.titleLabel.textColor = .white
        cell.layer.cornerRadius = 20
        
        cell.bringSubviewToFront(cell.titleLabel)
        
        cell.configureCell()
        
        return cell
    }
}

extension BuddyDetailsViewController: UICollectionViewDelegate {
    
}
