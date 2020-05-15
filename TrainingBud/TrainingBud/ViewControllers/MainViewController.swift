//
//  MainViewController.swift
//  abseil
//
//  Created by Zachary G. on 16/04/2020.
//

import UIKit
import MapKit

class MainViewController: UITabBarController {
	
	@IBOutlet var blurView: UIVisualEffectView!
	@IBOutlet var popupView: UIView!
	
	var popupViewController: UIViewController!
	
	private let locationManager = CLLocationManager()
	
	var currentCity: String?

    override func viewDidLoad() {
        super.viewDidLoad()
	
		setupPopup()
		removeModal()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkLocationPermissions()
	}
	
	private func updateCurrentCity() {
		if let location = locationManager.location {
			let geoCoder = CLGeocoder()
			geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
				placemarks?.forEach { (placemark) in
					if let city = placemark.locality, let country = placemark.country {
						self.currentCity = "\(city), \(country)"
					}
				}
			})
		}
	}
	
	private func checkLocationPermissions() {
		if CLLocationManager.locationServicesEnabled() {
			checkLocationAuthorization()
		}
	}
	
	private func checkLocationAuthorization() {
		switch CLLocationManager.authorizationStatus() {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
			break
		case .restricted:
			// Show an alert
			break
		case .denied:
			// Show an alert
			break
		case .authorizedAlways:
			// Show an alert
			break
		case .authorizedWhenInUse:
			// Get the current location
			updateCurrentCity()
			break
		@unknown default:
			// Show an alert
			break
		}
	}
	
	private func addModal() {
		var viewControllers = self.viewControllers
		let popupVC = popupViewController as! PopupContainerViewController
		popupVC.setMainVC(mainViewController: self)
		viewControllers?.append(popupVC)
	}
	
	private func removeModal() {
		let indexToRemove = 3
		if indexToRemove < self.viewControllers!.count {
			var viewControllers = self.viewControllers
			popupViewController = viewControllers?.remove(at: indexToRemove)
			self.viewControllers = viewControllers
		}
	}
	
	private func setupPopup() {
		blurView.effect = UIBlurEffect(style: .systemMaterial)
		blurView.bounds = self.view.bounds
		popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.92, height: self.view.bounds.height * 0.6)
	}
	
	public func showPopup() {
		animateIn(desiredView: blurView)
		animateIn(desiredView: popupView)
		addModal()
	}
	
	public func hidePopup(completion: @escaping () -> Void) {
		animateOut(desiredView: popupView)
		animateOut(desiredView: blurView)
		removeModal()
		completion()
	}
	
	private func animateIn(desiredView: UIView) {
		let backgroundView = self.view!
		backgroundView.addSubview(desiredView)
		
		desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
		desiredView.alpha = 0
		desiredView.center = backgroundView.center
		
		UIView.animate(withDuration: 0.3, animations: {
			desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
			desiredView.alpha = 1
		})
	}
	
	private func animateOut(desiredView: UIView) {
		UIView.animate(withDuration: 0.2, animations: {
			desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
			desiredView.alpha = 0
		}, completion: { _ in
			desiredView.removeFromSuperview()
		})
	}
}
