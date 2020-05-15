//
//  SelectedSessionViewController.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 09/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase

class SelectedSessionViewController: UIViewController {

    @IBOutlet weak var tableViewParticipants: UITableView!
    @IBOutlet weak var lbHostName: UILabel!
    @IBOutlet weak var lbSportType: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var imgHostPic: UIImageView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var viewTop: UIView!
    
    
    private var dbRef = Database.database().reference(withPath: "users");
    private var dbRefSession = Database.database().reference(withPath: "Sessions")
    private var joinedParticipants: [User] = []
    private let currentUser = Auth.auth().currentUser!
    var selectedSession: TrainingSession!
    var sessionKey: String!
    var hostName: String!
    private var participants: [String]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.LoadValues()
//        btn
//           .frame = CGRect(x: 285, y: 485, width: btn.frame.size.width, height: btn.frame.size.height)
        
        if (currentUser.uid == selectedSession.hostId){
            self.btn.isEnabled = false
            self.btn.isHidden = true
        }
        else{
            if self.selectedSession.participants.contains(currentUser.uid){
                self.btnJoin.setTitle("Leave", for: UIControl.State.normal)
                self.btnJoin.setTitleColor(UIColor.red, for: UIControl.State.normal)
            }
            else{
                self.btnJoin.setTitle("Join", for: UIControl.State.normal)
                self.btnJoin.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
            }
        }

        //Update when someone has join or leave
        Database.database().reference(withPath: "Sessions").child(self.sessionKey).observe(.value) { snapshot in
            let value = snapshot.value as? [String: AnyObject]
            self.participants = value?["participants"] as? [String]
            
            //Get user
            self.dbRef.observe(.value) { snapshot in
            var updatedUsers: [User] = []
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    for child1 in children {
                        let userId = child1.key
                        let joinedUser = User(snapshot: child1)
                        
                        for u in self.participants!{
                            if u == userId && userId != self.selectedSession.hostId{
                                updatedUsers.append(joinedUser!)
                            }
                        }
                            
            self.joinedParticipants = updatedUsers
            self.tableViewParticipants.reloadData()
                    }
                }
            }
        }
        
//        self.tableViewParticipants.delegate = self
//        self.tableViewParticipants.dataSource = self
    }
    
    private func LoadValues(){
        self.lbHostName.text = hostName
        self.lbSportType.text = self.selectedSession.sport
        self.lbDescription.text = self.selectedSession.getInformation()
        self.imgHostPic.image = UIImage(named: "hostSample")
    }
    
    @IBAction func join_onClick(_ sender: UIButton){
        if self.selectedSession.participants.contains(currentUser.uid){
            self.btnJoin.setTitle("Join", for: UIControl.State.normal)
            self.btnJoin.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
            self.selectedSession.participants.removeAll { uId -> Bool in
                return uId == currentUser.uid
            }
            self.dbRefSession.child(sessionKey).child("participants").setValue(self.selectedSession.participants)
        }
        else{
            self.btnJoin.setTitle("Leave", for: UIControl.State.normal)
            self.btnJoin.setTitleColor(UIColor.red, for: UIControl.State.normal)
            self.selectedSession.participants.append(currentUser.uid)
            self.dbRefSession.child(sessionKey).child("participants").setValue(self.selectedSession.participants)
        }
    }
}

//extension SelectedSessionViewController: UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.joinedParticipants.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "participantCell", for: indexPath) as! ParticipantViewCell
//
//        // Configure the cell...
//        cell.selectedParticipant = self.joinedParticipants[indexPath.row].id
//        cell = UIImage(named: "hostSample")
//        cell.lbUserName.text = self.joinedParticipants[indexPath.row].Name()
//        cell.lbUserInterest.text = self.joinedParticipants[indexPath.row].interest
//
//        if self.joinedParticipants[indexPath.row].email == currentUser.email{
//            cell.btnAddBuddy.isEnabled = false
//            cell.btnAddBuddy.isHidden = true
//        }
//
//        return cell
//    }
//}
//
//extension SelectedSessionViewController: UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 118
//    }
//}
