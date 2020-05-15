//
//  Participant.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 10/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation
import Firebase

public class Participant{
    
    var firstName: String
    var lastName: String
    var email: String
    var interest: String
    var buddies: [String]
    
    init(firstName: String, lastName: String, email: String, interest: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.interest = interest
        self.buddies = []
    }
    
    init?(snapshot: DataSnapshot) {
    guard
        let value = snapshot.value as? [String: AnyObject],
        let firstName = value["firstName"] as? String,
        let lastName = value["lastName"] as? String,
        let email = value["email"] as? String,
        let interest = value["interest"] as? String,
        let buddies = value["buddies"] as? [String] else {
        return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.interest = interest
        self.buddies = buddies
    }
    
    public func Name() -> String{
        return self.firstName + " " + self.lastName
    }
    
}

