//
//  Item.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 03/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation

struct GroceryItem {

let key: String
let name: String
let addedByUser: String
var completed: Bool

    init(name: String, addedByUser: String, completed: Bool, key: String = "") {
      self.key = key
      self.name = name
      self.addedByUser = addedByUser
      self.completed = completed
    }
}
