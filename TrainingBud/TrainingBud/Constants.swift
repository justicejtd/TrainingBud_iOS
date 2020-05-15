//
//  Constants.swift
//  TrainingBud
//
//  Created by Zachary G. on 17/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import Foundation
import UIKit

class Constants {
	class Keys {
		// Notification names
		static let PreferencesUpdated = "PreferencesUpdated"
		
		static let Sport = "Sport"
		static let TimePreference = "TimePreference"
		static let SkillLevel = "SkillLevel"
	}
	
	class Colors {
		static let Main		  = (UIColor.systemPurple, UIColor.systemPink)
		static let Roseanna   = (UIColor(hex: "#ffafbd"), UIColor(hex: "#ffc3a0"))
		static let SexyBlue   = (UIColor(hex: "#2193b0"), UIColor(hex: "#6dd5ed"))
		static let PurpleLove = (UIColor(hex: "#cc2b5e"), UIColor(hex: "#753a88"))
		static let Piglet 	  = (UIColor(hex: "#ee9ca7"), UIColor(hex: "#ffdde1"))
		static let LostMemory = (UIColor(hex: "#de6262"), UIColor(hex: "#ffb88c"))
		static let Socialive  = (UIColor(hex: "#06beb6"), UIColor(hex: "#48b1bf"))
		static let Cherry     = (UIColor(hex: "#eb3349"), UIColor(hex: "#f45c43"))
		static let Pinky 	  = (UIColor(hex: "#dd5e89"), UIColor(hex: "#f7bb97"))
		static let Kashmir 	  = (UIColor(hex: "#614385"), UIColor(hex: "#516395"))
		static let Almost 	  = (UIColor(hex: "#ddd6f3"), UIColor(hex: "#faaca8"))
		
		static let All = [Roseanna, SexyBlue, PurpleLove, Piglet, LostMemory, Socialive, Cherry, Pinky, Kashmir, Almost]
	}
}

extension UIColor {
	public convenience init?(hex: String) {
		let r, g, b, a: CGFloat
		
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])
			
			if hexColor.count == 6 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat(hexNumber & 0x000000ff) / 255
					
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			}
		}
		return nil
	}
}
