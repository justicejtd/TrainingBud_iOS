import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
	@IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(secondaryColor, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 74)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.white
        continueButton.addTarget(self, action: #selector(checkInput), for: .touchUpInside)
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
		activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        
        view.addSubview(activityView)
        
        firstNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        firstNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameField.becomeFirstResponder()
		NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firstNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        let info = notification.userInfo!
		let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    
    /**
     Enables the continue button if the **username**, **email**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    @objc func textFieldChanged(_ target:UITextField) {
        let username = firstNameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// Resigns the target textField and assigns the next textField in the form.
        switch textField {
        case firstNameField:
            firstNameField.resignFirstResponder()
            emailField.becomeFirstResponder()
            break
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            checkInput()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
	
	private func disableContinueButton() {
		setContinueButton(enabled: false)
		continueButton.setTitle("", for: .normal)
		activityView.startAnimating()
	}
	
	private func enableContinueButton() {
		setContinueButton(enabled: true)
		continueButton.setTitle("Continue", for: .normal)
		activityView.stopAnimating()
	}
	
	@objc func checkInput() {
		guard let firstName = firstNameField.text else { return }
		guard let lastName = lastNameField.text else { return }
		guard let email = emailField.text else { return }
		guard let password = passwordField.text else { return }
		
		disableContinueButton()
		
		if password.count < 6 {
			showToast(controller: self, message: "Password must be at least 6 characters")
			enableContinueButton()
			return
		}
		
		if !email.isValidEmail() {
			showToast(controller: self, message: "Please enter a valid email")
			enableContinueButton()
			return
		}
		
		signUp(firstName: firstName, lastName: lastName, email: email, password: password)
	}
    
	private func signUp(firstName: String, lastName: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = firstName + " " + lastName
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
						
						if let user = user?.user {
							let ref = Database.database().reference()
							let userRef = ref.child("users/\(user.uid)")
							
							userRef.setValue(["firstName": firstName,
											  "lastName": lastName,
											  "email": email])
						}
						self.performSegue(withIdentifier: "toHomeScreenFromSignUp", sender: self)
                    } else {
                        print("Error: \(error!.localizedDescription)")
						self.showToast(controller: self, message: error!.localizedDescription)
						self.enableContinueButton()
                    }
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
				self.enableContinueButton()
            }
        }
    }
}

extension UIViewController {
	func showToast(controller: UIViewController, message : String) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.view.backgroundColor = .black
		alert.view.alpha = 0.5
		alert.view.layer.cornerRadius = 15
		
		controller.present(alert, animated: true)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
			alert.dismiss(animated: true)
		}
	}
}

extension String {
	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: self)
	}
}
