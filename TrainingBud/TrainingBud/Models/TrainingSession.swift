//
//  TrainingSession.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 03/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation
import Firebase

class TrainingSession {
	
	var id: String
	var sport: String
	var startDate: String
	var endDate: String
	var description: String
	var hostId: String
	var location: String
	var city: String
	var nrOfParticipants: Int
	var type: String
	var participants: [String]
	var name: String
	var skillLevel: String
	
	var backgroundColor: (UIColor, UIColor)
	
	init?() {
		return nil
	}
	init(id: String, sport: String, startDate: String, endDate: String, description: String, hostId: String, location: String, nrOfParticipants: Int, type: String, name: String, skillLevel: String, city: String){
		self.id = id
		self.name = name
		self.skillLevel = skillLevel
		self.sport = sport
		self.startDate = startDate
		self.endDate = endDate
		self.description = description
		self.city = city
		self.hostId = hostId
		self.location = location
		self.nrOfParticipants = nrOfParticipants
		self.type = type
		self.participants = [Auth.auth().currentUser!.uid]
		self.backgroundColor = Constants.Colors.All[Int.random(in: 0 ... Constants.Colors.All.count - 1)] as! (UIColor, UIColor)
	}
	
	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let skillLevel = value["skillLevel"] as? String,
			let name = value["name"] as? String,
			let sport = value["sport"] as? String,
			let startDate = value["startDate"] as? String,
			let endDate = value["endDate"] as? String,
			let description = value["description"] as? String,
			let hostId = value["hostId"] as? String,
			let city = value["city"] as? String,
			let location = value["location"] as? String,
			let nrOfParticipants = value["nrOfParticipants"] as? Int,
			let type = value["type"] as? String,
			let participants = value["participants"] as? [String] else {
				return nil
		}
		
		self.id = snapshot.key
		self.name = name
		self.skillLevel = skillLevel
		self.sport = sport
		self.startDate = startDate
		self.endDate = endDate
		self.description = description
		self.city = city
		self.hostId = hostId
		self.location = location
		self.nrOfParticipants = nrOfParticipants
		self.type = type
		self.participants = participants
		self.backgroundColor = Constants.Colors.All[Int.random(in: 0 ... Constants.Colors.All.count - 1)] as! (UIColor, UIColor)
	}
	
	public func getInformation() -> String{
		
		return "\(self.description) \nlocation: \(self.location) \nCity: \(self.city) \nDate: \(self.startDate) - \(self.endDate) \nSession: \(type) \nNr of participants: \(self.nrOfParticipants)"
	}
	
	func toAnyObject() -> Any {
		return [
			"name": name,
			"skillLevel": skillLevel,
			"sport": sport,
			"startDate": startDate,
			"endDate": endDate,
			"description": description,
			"hostId": hostId,
			"city": city,
			"location": location,
			"nrOfParticipants": nrOfParticipants,
			"type": type,
			"participants": participants
		]
	}
}
