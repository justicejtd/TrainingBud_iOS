//
//  CreateSessionViewController.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 16/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit
import Firebase

class CreateSessionViewController: UIViewController {
	
	// Variables
	
	var sessionName: String?
	var city: String?
	var address: String?
	var sessionDescription: String?
	
	var type: String?
	var sport: String?
	
	var startTime: String?
	var endTime: String?
	
	var participants: Int?
	
	var skillLevel: String?
	
	var date: Date?
	
	var pickerComponents: [Any] = []
	
	// TextFields
	@IBOutlet weak var sessionNameTextField: UITextField!
	@IBOutlet weak var cityTextField: UITextField!
	@IBOutlet weak var addressTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	
	// Button outlets
	@IBOutlet weak var typeButton: GradientButton!
	@IBOutlet weak var sportButton: GradientButton!
	@IBOutlet weak var startTimeButton: GradientButton!
	@IBOutlet weak var endTimeButton: GradientButton!
	@IBOutlet weak var participantsButton: GradientButton!
	@IBOutlet weak var skillLevelButton: GradientButton!
	@IBOutlet weak var dateButton: GradientButton!
	@IBOutlet weak var saveButton: GradientButton!
	
	@IBOutlet weak var pickerMaxNrOfParticipants: UIPickerView!
	private var numbers: [Int] = []
	private var sports: [String] = []
	private var types: [String] = []
	private var skillLevels: [String] = []
	private var newSession: TrainingSession!
	@IBOutlet weak var tbxName: UITextField!
	@IBOutlet weak var tbxDescription: UITextField!
	@IBOutlet weak var lbCity: UITextField!
	@IBOutlet weak var lbAddress: UITextField!
	@IBOutlet weak var btnStartTime: UIButton!
	@IBOutlet weak var btnEndTime: UIButton!
	@IBOutlet weak var pickerDate: UIDatePicker!
	
	private let INTERVAL_START = 1
	private let INTERVAL_END = 2
	
	private let SET = "SET"
	
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
	
	let picker: UIPickerView = {
		let picker = UIPickerView(frame: .zero)
		picker.backgroundColor = UIColor.white
		
		return picker
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pickerComponents.append("TEst")
		pickerComponents.append("Sdadsadas")
		//        timePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
		//        pickerDate.addTarget(self, action: #selector(setDate(_:)), for: .valueChanged)
		Database.database().reference(withPath:  "Data").child("Sports").observe(.value) { snapshot in
			for child in snapshot.children{
				let c = child as! DataSnapshot
				self.sports.append(c.value as! String)
			}
			//            self.populateData()
			//            self.pickerMaxNrOfParticipants.delegate = self
			//            self.pickerMaxNrOfParticipants.dataSource = self
			//            self.pickerType.delegate = self
			//            self.pickerType.dataSource = self
			//            self.pickerSkillLevel.delegate = self
			//            self.pickerSkillLevel.dataSource = self
			//            self.pickerSports.delegate = self
			//            self.pickerSports.dataSource = self
		}
	}
	@objc func setDate(_ sender: UIDatePicker) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyy-MM-dd"
		let strDate = dateFormatter.string(from: self.pickerDate.date)
		self.newSession.startDate = "\(strDate) \(newSession.startDate)"
		self.newSession.endDate = "\(strDate) \(newSession.endDate)"
	}
	@objc func dateChanged(_ sender: UIDatePicker) {
		let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
		if let hour = components.hour, let minute = components.minute {
			self.setTime(hour: hour, minute: minute) {
			}
		}
	}
	
	private func setTime(hour: Int, minute: Int, completion: @escaping () -> Void) {
		let time = String(format: "%02d:%02d", hour, minute)
		
		let df = DateFormatter()
		df.dateFormat = "yyy-MM-dd"
		
		let dateString = df.string(from: Date()) + " " + time
		print("Date string: \(dateString)")
		
		df.dateFormat = "yyyy-MM-dd HH:mm"
		let date = df.date(from: dateString)
		
		if currentInterval == INTERVAL_START {
			startDate = date
			self.newSession.startDate = time
			self.btnStartTime.setTitle(title: time)
		}
		else {
			endDate = date
			self.newSession.endDate = time
			self.btnEndTime.setTitle(title: time)
		}
		completion()
	}
	
	//    func populateData(){
	//		self.newSession = TrainingSession(id: UUID().uuidString, sport: "Running", startDate: "String", endDate: "String", description: "", hostId: "", location: "", nrOfParticipants: 1, type: "Duo", name: "", skillLevel: "Beginner", city: "")
	//        self.pickerMaxNrOfParticipants.tag = 1
	//        self.pickerSports.tag = 2
	//        self.pickerType.tag = 3
	//        self.pickerSkillLevel.tag = 4
	//
	//        for index in 1...100 {
	//            numbers.append(index)
	//        }
	//
	//        types.append("Duo")
	//        types.append("Group")
	//        skillLevels.append("Beginner")
	//        skillLevels.append("Intermediate")
	//        skillLevels.append("Advanced")
	//
	//    }
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
//	@IBAction func setStartTime(_ sender: Any) {
//		showPicker(for: INTERVAL_START, with: self.btnStartTime.titleLabel!.text!)
//	}
//
//	@IBAction func setEndTime(_ sender: Any) {
//		showPicker(for: INTERVAL_END, with: self.btnEndTime.titleLabel!.text!)
//	}
	
	private func intervalIsSet() -> Bool {
		let intervalStart = btnStartTime.titleLabel?.text
		let intervalEnd = btnEndTime.titleLabel?.text
		
		let intervalIsSet = intervalStart != SET && intervalEnd != SET
		return intervalIsSet
	}
	
	func showPicker(for field: String) {
		var buttonText: String
		var tag: Int
		var timeMode = false
		
		switch field {
		case "type":
			tag = 1
			buttonText = typeButton.titleLabel!.text!
			pickerComponents = ["Duo", "Group"]
			break
		case "sport":
			tag = 2
			buttonText = sportButton.titleLabel!.text!
			pickerComponents = ["Basketball", "Football", "Swimming", "Tennis", "Running", "Cycling","Golf"]
			break
		case "startTime":
			tag = 3
			buttonText = startTimeButton.titleLabel!.text!
			timeMode = true
			break
		case "endTime":
			tag = 4
			buttonText = endTimeButton.titleLabel!.text!
			timeMode = true
			break
		case "participants":
			tag = 5
			buttonText = participantsButton.titleLabel!.text!
			pickerComponents = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
			break
		case "skillLevel":
			tag = 6
			buttonText = skillLevelButton.titleLabel!.text!
			pickerComponents = ["Beginner", "Intermediate", "Advanced"]
			break
		default:
			// Date
			tag = 7
			buttonText = dateButton.titleLabel!.text!
			break
		}
		
		self.picker.tag = tag
		self.picker.delegate = self
		self.picker.dataSource = self
		
		let applicationWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		if let window = applicationWindow {
			overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
			
			overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
			
			window.addSubview(overlay)
			window.addSubview(picker)
			
			let height: CGFloat = 250
			let y = window.frame.height - height
			self.picker.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
			
			overlay.frame = window.frame
			overlay.alpha = 0
			
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.overlay.alpha = 1
				self.picker.frame = CGRect(x: 0, y: y, width: self.picker.frame.width, height: self.picker.frame.height)
			}, completion: nil)
		}
	}
	
	@objc func handleDismiss() {
		UIView.animate(withDuration: 0.3) {
			self.overlay.alpha = 0
			
			let applicationWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
			if let window = applicationWindow {
				self.picker.frame = CGRect(x: 0, y: window.frame.height, width: self.picker.frame.width, height: self.picker.frame.height)
			}
		}
	}

	
	@IBAction func save(_ sender: Any) {
		guard let name = sessionName,
			let city = city,
			let address = address,
			let description = sessionDescription,
			let type = type,
			let sport = sport,
			let startTime = startTime,
			let endTime = endTime,
			let participants = participants,
			let skillLevel = skillLevel,
			let date = date else {
				let alert = UIAlertController(title: "Error", message: "Please fill in all required fields", preferredStyle: UIAlertController.Style.alert)
				
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
		}
	}
	
	@IBAction func saveSession(_ sender: Any) {
		self.newSession.description = self.tbxDescription.text!
		self.newSession.hostId = String(Auth.auth().currentUser!.uid)
		self.newSession.location = self.lbAddress.text!
		self.newSession.name = self.tbxName.text!
		self.newSession.city = self.lbCity.text!
		
		Database.database().reference(withPath: "Sessions").childByAutoId().setValue(self.newSession.toAnyObject())
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func chooseType(_ sender: Any) {
		showPicker(for: "type")
	}
	
	@IBAction func chooseSport(_ sender: Any) {
		showPicker(for: "sport")
	}
	
	@IBAction func chooseParticipants(_ sender: Any) {
		showPicker(for: "participants")
	}
	
	@IBAction func chooseSkillLevel(_ sender: Any) {
		showPicker(for: "skillLevel")
	}
	
}

extension CreateSessionViewController: UIPickerViewDelegate {
	
}

extension CreateSessionViewController: UIPickerViewDataSource {
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerComponents.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "\(pickerComponents[row])"
	}
}
