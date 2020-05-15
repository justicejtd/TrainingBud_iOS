//
//  Preferences.swift
//  TrainingBud
//
//  Created by Zachary G. on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation
import RealmSwift

public class Preferences: Object {
	@objc dynamic var sport: String!
	@objc dynamic var timePreference: String!
	@objc dynamic var startDate: Date?
	@objc dynamic var endDate: Date?
	@objc dynamic var skillLevel: String!
	
	func getInterval() -> DateInterval? {
		if let start = startDate, let end = endDate {
			return DateInterval(start: start, end: end)
		}
		return nil
	}
}
