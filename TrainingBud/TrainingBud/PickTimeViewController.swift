//
//  PickTimeViewController.swift
//  TrainingBud
//
//  Created by Zachary G. on 02/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class PickTimeViewController: UIViewController {
	
	private var pageViewController: SearchPageViewController!
	
	@IBOutlet weak var buttonIntervalStart: RoundedWhiteButton!
	@IBOutlet weak var buttonIntervalEnd: RoundedWhiteButton!
	@IBOutlet weak var buttonConfirm: RoundedWhiteButton!
	
	private let INTERVAL_START = 1
	private let INTERVAL_END = 2
	
	private let NOT_SET = "Not set"
	
	private var currentInterval: Int!
	
	private let cellId = "cellId"
	
	private var startDate: Date?
	private var endDate: Date?
	
	let overlay = UIView()
	let timePicker: UIDatePicker = {
		let picker = UIDatePicker(frame: .zero)
		picker.backgroundColor = UIColor.white
		picker.datePickerMode = .time
	
		return picker
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		pageViewController = (self.parent as! SearchPageViewController)
		
		timePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
		
		buttonConfirm.alpha = 0
		buttonConfirm.isEnabled = false
    }
	
	@objc func dateChanged(_ sender: UIDatePicker) {
		let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
		if let hour = components.hour, let minute = components.minute {
			self.setTime(hour: hour, minute: minute) {
				if self.intervalIsSet() && !self.buttonConfirm.isEnabled {
					UIView.animate(withDuration: 0.3) {
						self.buttonConfirm.alpha = 1
						self.buttonConfirm.isEnabled = true
					}
				}
			}
		}
	}
	
	private func setTime(hour: Int, minute: Int, completion: @escaping () -> Void) {
		let time = String(format: "%02d:%02d", hour, minute)
		
		let df = DateFormatter()
		df.dateFormat = "yyy-MM-dd"
		
		let dateString = df.string(from: Date()) + " " + time
		 
		let date = dateString.toNeutralDate()
		
		if currentInterval == INTERVAL_START {
			startDate = date
			buttonIntervalStart.setTitle(title: time)
		}
		else {
			endDate = date
			buttonIntervalEnd.setTitle(title: time)
		}
		completion()
	}
	
	private func intervalIsSet() -> Bool {
		let intervalStart = buttonIntervalStart.titleLabel?.text
		let intervalEnd = buttonIntervalEnd.titleLabel?.text
		
		let intervalIsSet = intervalStart != NOT_SET && intervalEnd != NOT_SET
		return intervalIsSet
	}
	
	@IBAction func asSoonAsPossiblePressed(_ sender: Any) {
		pageViewController.prefs.timePreference = "ASAP"
		
		pageViewController.goForward()
	}
	
	@IBAction func confirm(_ sender: Any) {
		pageViewController.prefs.timePreference = "Interval"
		
		pageViewController.prefs.startDate = startDate
		pageViewController.prefs.endDate = endDate
		
		pageViewController.goForward()
	}
	
	@IBAction func changeIntervalStart(_ sender: Any) {
		showPicker(for: INTERVAL_START, with: buttonIntervalStart.titleLabel!.text!)
	}
	
	@IBAction func changeIntervalEnd(_ sender: Any) {
		showPicker(for: INTERVAL_END, with: buttonIntervalEnd.titleLabel!.text!)
	}
	
	func showPicker(for interval: Int, with time: String) {
		var date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat =  "HH:mm"
		
		if time != NOT_SET {
			date = dateFormatter.date(from: time)!
		}
		
		timePicker.date = date
		currentInterval = interval
		let applicationWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		if let window = applicationWindow {
			overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
			
			overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
			
			window.addSubview(overlay)
			window.addSubview(timePicker)
			
			let height: CGFloat = 250
			let y = window.frame.height - height
			timePicker.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
			
			overlay.frame = window.frame
			overlay.alpha = 0
			
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.overlay.alpha = 1
				self.timePicker.frame = CGRect(x: 0, y: y, width: self.timePicker.frame.width, height: self.timePicker.frame.height)
			}, completion: nil)
		}
	}
	
	@objc func handleDismiss() {
		UIView.animate(withDuration: 0.3) {
			self.overlay.alpha = 0
			
			let applicationWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
			if let window = applicationWindow {
				self.timePicker.frame = CGRect(x: 0, y: window.frame.height, width: self.timePicker.frame.width, height: self.timePicker.frame.height)
			}
		}
	}
}

extension UIButton {
	func setTitle(title: String?) {
		UIView.setAnimationsEnabled(false)
		
		setTitle(title, for: .normal)
		
		layoutIfNeeded()
		UIView.setAnimationsEnabled(true)
	}
}
