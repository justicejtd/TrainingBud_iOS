//
//  User.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 10/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation
import Firebase
import UIKit

public class User: Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var interests: [String]
    var buddies: [String]
    
    init(id: String, firstName: String, lastName: String, email: String, interests: [String]){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.interests = interests
        self.buddies = []
    }
    
    init?(snapshot: DataSnapshot) {
    guard
        let value = snapshot.value as? [String: AnyObject],
        let id = value["id"] as? String,
        let firstName = value["firstName"] as? String,
        let lastName = value["lastName"] as? String,
        let email = value["email"] as? String,
        let interests = value["interests"] as? [String],
        let buddies = value["buddies"] as? [String] else {
        return nil
        }
        
        self.id = id;
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.interests = interests
        self.buddies = buddies
    }
    
    public func Name() -> String{
        return self.firstName + " " + self.lastName
    }
	
	public func toString() -> String {
		return "User[id: \(id), name: \(Name()), email: \(email), interest: \(email)]"
	}
    
	public static func ==(lhs: User, rhs: User) -> Bool {
		return lhs.id == rhs.id
	}
}
