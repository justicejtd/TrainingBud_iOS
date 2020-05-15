//
//  Storage.swift
//  TrainingBud
//
//  Created by Zachary G. on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation
import RealmSwift

public class Storage {
	static let userDefaults = UserDefaults.standard
	
	public static func storePreferences(preferences: Preferences) {
		let realm = try! Realm()
		
		try! realm.write {
			let prefs = realm.objects(Preferences.self)
			realm.delete(prefs)
			realm.add(preferences)
		}
	}
	
	public static func clearPreferences() {
		let realm = try! Realm()
		
		try! realm.write {
			let prefs = realm.objects(Preferences.self)
			realm.delete(prefs)
		}
	}
	
	public static func getPreferences() -> Preferences? {
		let realm = try! Realm()
		
		if let prefs = realm.objects(Preferences.self).first {
			return prefs
		}
		else {
			return nil
		}
	}
	
	private static func saveValue(forKey key: String, value: Any) {
		userDefaults.set(value, forKey: key)
	}
	private static func readValue(forKey key: String) -> Any? {
		return userDefaults.value(forKey: key)
	}
}
