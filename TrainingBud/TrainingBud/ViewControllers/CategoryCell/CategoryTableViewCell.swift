//
//  CategoryTableViewCell.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase
import AnimatedCollectionViewLayout

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewSessions: UICollectionView!
    @IBOutlet weak var lbCategoryName: UILabel!
    
    let dbUserRef = Database.database().reference(withPath: "users")
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
	
    var sessions: [TrainingSession]!
	
    var hostNames: [String] = []
    var navigationController: UINavigationController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewSessions.delegate = self
        collectionViewSessions.dataSource = self
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()
        layout.scrollDirection = .horizontal
        collectionViewSessions.collectionViewLayout = layout
        collectionViewSessions.isPagingEnabled = true
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("Session count: \(sessions.count)")
        return sessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SessionDetails") as! SessionDetailsViewController
        vc.currentSession = sessions[indexPath.row]
        vc.backgroundColor = sessions[indexPath.row].backgroundColor
        navigationController.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sessionCell", for: indexPath) as! CategoryCollectionViewCell
        let session = sessions[indexPath.row]
		
		print("Session id: \(session.id) with participants \(session.participants.count)")
        
        cell.lbSessionName.text = session.name
        cell.lbLocation.text = session.location
        cell.lbSkillLevel.text = "\(session.skillLevel) level"
		let df = DateFormatter()
		df.dateFormat = "d MMMM"
		
		let startDate = session.startDate.toDate()
		let endDate = session.endDate.toDate()
		
		let sessionDate = df.string(from: startDate!)
		
		df.dateFormat = "HH:mm"
		
		let startTime = df.string(from: startDate!)
		let endTime = df.string(from: endDate!)
		
		cell.lbDateAndTime.text = "\(sessionDate) | \(startTime) - \(endTime)"
		
        cell.lbSessionType.text = session.type
        cell.lbNrOfPeopleGoing.text = "\(session.participants.count) going"
        cell.gradient = session.backgroundColor
        let gradientView = cell.contentView as! GradientView
		gradientView.cornerRadius = 10
        gradientView.setGradientColor(color: session.backgroundColor)
        cell.clipsToBounds = animator?.1 ?? true
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 300, height: 205)
        guard let animator = animator else { return collectionView.bounds.size }
        return CGSize(width: collectionView.bounds.width / CGFloat(animator.2), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

